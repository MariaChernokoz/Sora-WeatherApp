//
//  CityService.swift
//  Sora
//
//  Created by Chernokoz on 10.11.2025.
//

import Foundation
import CoreLocation
import MapKit

final class CityService {
    
    func getCoordinates(forCityName cityName: String) async throws -> CLLocationCoordinate2D {

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = cityName
        request.resultTypes = .address
        
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        guard let item = response.mapItems.first,
              let location = item.placemark.location else {
            throw CityServiceError.cityNotFound
        }
        
        return location.coordinate
    }
    
    func getCityName(from coordinates: CLLocationCoordinate2D) async throws -> String {
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first,
              let city = placemark.locality else {
            throw CityServiceError.reverseGeocodingError
        }
        
        return city
    }
}

enum CityServiceError: Error {
    case cityNotFound
    case generalGeocodingError
    case reverseGeocodingError
}
