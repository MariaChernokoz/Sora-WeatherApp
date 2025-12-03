//
//  CityWeather.swift
//  Sora
//
//  Created by Chernokoz on 17.11.2025.
//

import Foundation

struct CityWeather: Codable, Identifiable, Equatable {
    let id = UUID()
    
    let temperature: String
    let symbolName: String
    let description: String
    
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Int
    let sunrise: Int?
    let sunset: Int?
    let windSpeed: Double
    let windDeg: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperature, symbolName, description, feels_like, temp_min, temp_max, pressure, humidity, sunrise, sunset, windSpeed, windDeg
    }
}
