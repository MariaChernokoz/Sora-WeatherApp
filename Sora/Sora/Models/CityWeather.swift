//
//  CityWeather.swift
//  Sora
//
//  Created by Chernokoz on 17.11.2025.
//

import Foundation

struct CityWeather: Codable, Identifiable {
    let id = UUID()
    let temperature: String
    let symbolName: String
    let description: String
}
