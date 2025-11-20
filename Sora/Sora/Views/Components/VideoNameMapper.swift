//
//  VideoNameMapper.swift
//  Sora
//
//  Created by Chernokoz on 19.11.2025.
//

import Foundation

struct VideoNameMapper {
    static func getVideoName(for symbolName: String?) -> String? {
        guard let symbolName = symbolName else { return nil }
        
        switch symbolName {
        case "sun.max.fill", "moon.fill":
            return "clear_sky_day_1"
            
        case "cloud.sun.fill", "cloud.moon.fill", "cloud.fill":
            return "cloudy_day_1"
            
        case "cloud.drizzle.fill":
            return "shower_rain_day_1"
            
        case "cloud.rain.fill", "cloud.heavyrain.fill":
            return "rainy_day_1"
            
        case "cloud.bolt.fill":
            return "stormy_day_1"
            
        case "cloud.snow.fill":
            return "snowy_day_1"
            
        case "cloud.fog.fill", "smoke.fill":
            return "mist"

        default:
            return nil
        }
    }
}
