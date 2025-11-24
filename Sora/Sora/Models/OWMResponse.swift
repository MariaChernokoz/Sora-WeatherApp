//
//  OWMResponse.swift
//  Sora
//
//  Created by Chernokoz on 17.11.2025.
//

import Foundation

struct OWMResponse: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind?
    let sys: Sys?
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Double
        let humidity: Int
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Double
    }

    struct Sys: Codable {
        let sunrise: Int?
        let sunset: Int?
    }
}
