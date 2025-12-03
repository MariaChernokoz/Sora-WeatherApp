//
//  City.swift
//  Sora
//
//  Created by Chernokoz on 10.11.2025.
//

import Foundation
import CoreLocation

struct City: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let isCurrentLocation: Bool
    
    var weatherData: CityWeather?
    var hourlyForecasts: [HourlyForecast]?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(entity: CityEntity) {
        self.name = entity.name
        self.latitude = entity.latitude
        self.longitude = entity.longitude
        self.isCurrentLocation = entity.isCurrentLocation
    }
    
    init(name: String, latitude: Double, longitude: Double, isCurrentLocation: Bool, weatherData: CityWeather? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isCurrentLocation = isCurrentLocation
        self.weatherData = weatherData
    }
}
