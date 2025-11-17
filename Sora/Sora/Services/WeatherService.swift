//
//  WeatherService.swift
//  Sora
//
//  Created by Chernokoz on 08.11.2025.
//

import Foundation
import WeatherKit
import CoreLocation

let weatherService = WeatherService()
private let apiKey = getAPIKey()
private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

private func getAPIKey() -> String {
    
    guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: filePath),
          let value = plist.object(forKey: "OpenWeatherMapAPIKey") as? String else {
        
        fatalError("API Key not found in Secrets.plist. Key 'OpenWeatherMapAPIKey' required.")
    }
    
    return value
}
