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
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
}
