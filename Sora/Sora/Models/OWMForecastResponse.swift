//
//  OWMForecastResponse.swift
//  Sora
//
//  Created by Chernokoz on 26.11.2025.
//

import Foundation

// MARK: - 5 day / 3 hour forecast model
struct ForecastOWMResponse: Codable {
    let list: [ForecastItem]
    let city: CityInfo
    
    struct CityInfo: Codable {
        let name: String
        let coord: Coordinate
    }
    
    struct Coordinate: Codable {
        let lat: Double
        let lon: Double
    }
}

// MARK: - One point forecast model
struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: OWMResponse.Main
    let weather: [OWMResponse.Weather]
    let wind: OWMResponse.Wind?
}

struct HourlyForecast: Codable, Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let rawTemperature: Double
    let time: String
    let temperature: String
    let symbolName: String
    let description: String
}
