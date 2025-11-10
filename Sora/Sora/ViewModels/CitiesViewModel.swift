//
//  CitiesViewModel.swift
//  Sora
//
//  Created by Chernokoz on 10.11.2025.
//

import Foundation
import SwiftUI
import MapKit
import Combine

final class CitiesViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var cityInput: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    private let cityService: CityService
    
    init(cityService: CityService = CityService(), initialCities: [City] = [
        City(id: UUID(), name: "Москва", latitude: 55.7558, longitude: 37.6176, isCurrentLocation: false),
        City(id: UUID(), name: "Токио", latitude: 35.6895, longitude: 139.6917, isCurrentLocation: false),
        City(id: UUID(), name: "Лондон", latitude: 51.509865, longitude: -0.118092, isCurrentLocation: false),
        City(id: UUID(), name: "Нью-Йорк", latitude: 40.712776, longitude: -74.005974, isCurrentLocation: false),
        City(id: UUID(), name: "Сидней", latitude: -33.868820, longitude: 151.209290, isCurrentLocation: false)
    ]) {
        self.cityService = cityService
        self.cities = initialCities
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
}
