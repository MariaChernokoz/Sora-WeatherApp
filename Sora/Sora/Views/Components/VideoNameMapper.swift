//
//  VideoNameMapper.swift
//  Sora
//
//  Created by Chernokoz on 19.11.2025.
//

import Foundation

struct VideoNameMapper {
    //Сопоставление имя SF-символа с именем видеофайла
    static func getVideoName(for symbolName: String?) -> String? {
        guard let symbolName = symbolName else { return nil }
            
        switch symbolName {
        // Ясно
        case "sun.max.fill", "moon.fill":
            return "sunny_day_1"
        
        // Переменчивая облачность
        case "cloud.sun.fill", "cloud.moon.fill":
            return "clear_sky_day_1"
        
        // Облачно
        case "cloud.fill":
            return "cloudy_day_1"
            
        // Легкий дождь/морось
        case "cloud.drizzle.fill":
            return "rainy_day_1"
            
        // Сильный дождь
        case "cloud.rain.fill", "cloud.heavyrain.fill":
            return "totoro_rain_1 2"
            
        // Гроза
        case "cloud.bolt.fill":
            return "stormy_day_1"
            
        // Снег
        case "cloud.snow.fill":
            return "snowy_day_1"
            
        // Туман/смог (!)
        case "cloud.fog.fill", "smoke.fill":
            return "totoro_rain_1 2"

        default:
            return nil
        }
    }
}
