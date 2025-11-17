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

final class CitiesViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var cityInput: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    private let cityService: CityService
    
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
        self.locationService = locationService
        self.cities = initialCities
        
        setupLocationSubscription()
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
                    isCurrentLocation: false
                )
                
                self.cities.append(newCity)
                self.cityInput = ""
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
        Task { @MainActor in
            do {
                self.cities.removeAll(where: { $0.isCurrentLocation })

                let cityName = try await cityService.getCityName(from: coordinates)
                
                let currentLocationCity = City(
                    id: UUID(),
                    name: cityName,
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    isCurrentLocation: true
                )
                
                self.cities.insert(currentLocationCity, at: 0)

            } catch {
                print("Geolocation error: \(error)")
            }
        }
    }
    
    func deleteCities(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }
}


