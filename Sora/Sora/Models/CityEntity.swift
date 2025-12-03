//
//  CityEntity.swift
//  Sora
//
//  Created by Chernokoz on 01.12.2025.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class CityEntity {
    var name: String
    var latitude: Double
    var longitude: Double
    var isCurrentLocation: Bool

    init(name: String, latitude: Double, longitude: Double, isCurrentLocation: Bool = false) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isCurrentLocation = isCurrentLocation
    }
}
