//
//  CityViewModel.swift
//  Sora
//
//  Created by Chernokoz on 10.11.2025.
//

import Foundation
import MapKit
import Combine
import SwiftUI
import CoreLocation
import SwiftData

@MainActor
final class CityViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var cityInput: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil

    private var weatherTask: Task<Void, Never>?

    private let cityService: CityService
    private let weatherService: WeatherService

    private let locationService: LocationService
    private var cancellables = Set<AnyCancellable>()
    
    private let context: ModelContext

    init(context: ModelContext,
         cityService: CityService = CityService(),
         locationService: LocationService = LocationService()
    ) {
        self.context = context
        self.cityService = cityService
        self.weatherService = WeatherService()
        self.locationService = locationService
        
        self.fetchSavedCities()
        
        setupLocationSubscription()
    }

    func addNewCity() {
        guard !cityInput.isEmpty else { return }

        self.isLoading = true
        self.error = nil

        Task { @MainActor in
            do {
                let coordinates = try await self.cityService.getCoordinates(forCityName: self.cityInput)
                
                let lat = coordinates.latitude
                let lon = coordinates.longitude
                
                let predicate = #Predicate<CityEntity> {
                    $0.latitude == lat && $0.longitude == lon
                }
                let existingCities = try context.fetch(FetchDescriptor<CityEntity>(predicate: predicate))
                
                if !existingCities.isEmpty {
                    self.error = NSError(domain: "CityError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Город уже добавлен."])
                    self.isLoading = false
                    return
                }

                let newEntity = CityEntity(
                    name: self.cityInput,
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    isCurrentLocation: false
                )
                
                context.insert(newEntity)
                try context.save()
                
                self.cityInput = ""
                self.fetchSavedCities()
            } catch {
                self.error = error
            }

            self.isLoading = false
        }
    }

    private func setupLocationSubscription() {
        locationService.requestAuthorization()

        locationService.locationPublisher
            .sink { [weak self] coordinates in
                self?.handleNewLocation(coordinates: coordinates)
            }
            .store(in: &cancellables)

        locationService.$authorizationStatus
            .sink { [weak self] status in
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self?.locationService.startUpdatingLocation()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchSavedCities() {
        do {
            let fetch = FetchDescriptor<CityEntity>()
            let cityEntities = try context.fetch(fetch)
            
            var loadedCities = cityEntities.map { City(entity: $0) }
            
            if let currentLocation = self.cities.first(where: { $0.isCurrentLocation }) {
                loadedCities.insert(currentLocation, at: 0)
            }
            
            self.cities = loadedCities
            
            self.cities.forEach { city in
                self.fetchWeatherForCity(city: city)
            }
        } catch {
            self.error = error
        }
    }

    private func handleNewLocation(coordinates: CLLocationCoordinate2D) {
        
        weatherTask?.cancel()

        print("--- [Location Update] ---")
        print("Новые координаты: Lat \(coordinates.latitude), Lon \(coordinates.longitude)")

        weatherTask = Task { @MainActor in
            
            guard !Task.isCancelled else { return }
            do {
                self.cities.removeAll(where: { $0.isCurrentLocation })

                let cityName = try await cityService.getCityName(from: coordinates)

                guard !Task.isCancelled else { return }

                let weatherData = try await weatherService.fetchWeather(for: coordinates)

                let currentLocationCity = City(
                    name: cityName,
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    isCurrentLocation: true,
                    weatherData: weatherData
                )

                self.cities.insert(currentLocationCity, at: 0)

            } catch {
                print("Geolocation error or WeatherData fetching error: \(error)")
            }
        }
    }

    func fetchWeatherForCity(city: City) {
        Task { @MainActor in
            do {

                let weatherData = try await weatherService.fetchWeather(for: city.coordinate)
                let hourlyForecasts = try await weatherService.fetchForecast(for: city.coordinate)

                var dailyForecasts: [DailyForecast] = []
                
                //MARK: Aggregation logic for Daily Forecast
                let groupedByDay = Dictionary(grouping: hourlyForecasts) { forecast in
                    return Calendar.current.startOfDay(for: forecast.date)
                }
                .sorted(by: { $0.key < $1.key })
                
                let today = Calendar.current.startOfDay(for: Date())
                
                for (date, forecastsForDay) in groupedByDay {
                    
                    if date == today {
                        continue
                    }
                    
                    if dailyForecasts.count >= 4 {
                        break
                    }
                    
                    let minTemp = forecastsForDay.min(by: { $0.rawTemperature < $1.rawTemperature })?.rawTemperature ?? 0
                    let maxTemp = forecastsForDay.max(by: { $0.rawTemperature < $1.rawTemperature })?.rawTemperature ?? 0
                    
                    let middayForecast = forecastsForDay.min(by: { abs(Calendar.current.component(.hour, from: $0.date) - 12) < abs(Calendar.current.component(.hour, from: $1.date) - 12) }) ?? forecastsForDay.first!
                    
                    let dailyForecast = DailyForecast(
                        date: date,
                        minTemperature: minTemp,
                        maxTemperature: maxTemp,
                        symbolName: middayForecast.symbolName,
                        description: middayForecast.description
                    )
                    
                    dailyForecasts.append(dailyForecast)
                }
                

                var updatedCity = city
                updatedCity.weatherData = weatherData
                
                let now = Date()
                updatedCity.hourlyForecasts = hourlyForecasts.filter { $0.date >= now }
                
                updatedCity.dailyForecasts = dailyForecasts
                
                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
                    self.cities[index] = updatedCity
                }
                
            } catch {
                print("Error fetching weather for \(city.name): \(error.localizedDescription)")
            }
        }
    }

    func deleteCities(at offsets: IndexSet) {
        
        let citiesToDelete = offsets.map { self.cities[$0] }
        
        for city in citiesToDelete {
            guard !city.isCurrentLocation else { continue }
            
            let cityName = city.name
            let cityLatitude = city.latitude
            let cityLongitude = city.longitude

            do {
                let predicate = #Predicate<CityEntity> {
                    $0.name == cityName &&
                    $0.latitude == cityLatitude &&
                    $0.longitude == cityLongitude
                }
                
                let fetch = FetchDescriptor<CityEntity>(predicate: predicate)
                
                if let entity = try context.fetch(fetch).first {
                    context.delete(entity)
                }
            } catch {
                print("DELETE-ERROR: Не удалось найти сущность для удаления: \(error)")
            }
        }
        
        do {
            try context.save()
            self.fetchSavedCities()
        } catch {
            print("DELETE-ERROR: Ошибка сохранения после удаления: \(error)")
        }
    }
}
