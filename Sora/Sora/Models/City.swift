//
//  City.swift
//  Sora
//
//  Created by Chernokoz on 10.11.2025.
//

import Foundation

struct City: Codable, Identifiable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let isCurrentLocation: Bool
}
