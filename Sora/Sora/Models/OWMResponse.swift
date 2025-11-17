//
//  OWMResponse.swift
//  Sora
//
//  Created by Chernokoz on 17.11.2025.
//

import Foundation

struct OWMResponse: Decodable {
    let main: Main
    let weather: [Weather]
    
    struct Main: Decodable {
        let temp: Double
    }
    
    struct Weather: Decodable {
        let id: Int
        let description: String
        let icon: String
    }
}
