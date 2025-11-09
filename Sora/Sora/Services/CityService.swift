//
//  CityService.swift
//  Sora
//
//  Created by Chernokoz on 10.11.2025.
//

import Foundation
import CoreLocation

final class CityService {
    
    private let geocoder = CLGeocoder()
    
    func getCoordinates(forCityName cityName: String) async throws-> CLLocationCoordinate2D {
        
        let placemarks = try await geocoder.geocodeAddressString(cityName)
        guard let location = placemarks.first?.location else {
            throw CityServiceError.cityNotFound
        }
        
        return location.coordinate
    }
}


enum CityServiceError: Error {
    case cityNotFound
    case generalGeocodingError
}
