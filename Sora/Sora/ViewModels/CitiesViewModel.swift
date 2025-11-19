//
//  CitiesViewModel.swift
//  Sora
//
//  Created by Chernokoz on 10.11.2025.
//

import Foundation
import MapKit
import Combine
import SwiftUI
import CoreLocation

final class CitiesViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var cityInput: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil

    private var weatherTask: Task<Void, Never>?

    private let cityService: CityService
    private let weatherService: WeatherService

    private let locationService: LocationService
    private var cancellables = Set<AnyCancellable>()

    init(cityService: CityService = CityService(),
         locationService: LocationService = LocationService(),
         initialCities: [City] = [
        City(id: UUID(), name: "Москва", latitude: 55.7558, longitude: 37.6176, isCurrentLocation: false),
        City(id: UUID(), name: "Токио", latitude: 35.6895, longitude: 139.6917, isCurrentLocation: false),
        City(id: UUID(), name: "Лондон", latitude: 51.509865, longitude: -0.118092, isCurrentLocation: false),
        City(id: UUID(), name: "Нью-Йорк", latitude: 40.712776, longitude: -74.005974, isCurrentLocation: false),
        City(id: UUID(), name: "Сидней", latitude: -33.868820, longitude: 151.209290, isCurrentLocation: false)
    ]) {
        self.cityService = cityService
        self.weatherService = WeatherService()
        self.locationService = locationService
        self.cities = initialCities

        setupLocationSubscription()

        self.cities.forEach { city in
            self.fetchWeatherForCity(city: city)
        }
    }

    func addNewCity() {
        guard !cityInput.isEmpty else { return }

        self.isLoading = true
        self.error = nil

        Task {
            do {
                let coordinates = try await self.cityService.getCoordinates(forCityName: self.cityInput)

                let newCity = City(
                    id: UUID(),
                    name: self.cityInput,
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    isCurrentLocation: false,
                    weatherData: nil
                )

                self.cities.append(newCity)
                self.cityInput = ""
                self.fetchWeatherForCity(city: newCity)
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
                    id: UUID(),
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

                var updatedCity = city
                updatedCity.weatherData = weatherData

                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
                    self.cities[index] = updatedCity
                }

            } catch {
                print("Error fetching weather for \(city.name): \(error.localizedDescription)")
            }
        }
    }

    func deleteCities(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }
}
