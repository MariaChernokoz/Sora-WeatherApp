//
//  VideoNameMapper.swift
//  Sora
//
//  Created by Chernokoz on 19.11.2025.
//

import Foundation

struct VideoNameMapper {
    
    private static let videoCounts: [String: Int] = [
        "sunny_day": 3,
        "sunny_night": 4,
        "clear_sky_day": 3,
        "clear_sky_night": 3,
        "cloudy_day": 3,
        "drizzle": 2,
        "rain": 2,
        "heavyrain": 2,
        "stormy": 2,
        "snowy": 3,
        "fog": 2,
        "smoke": 1
    ]
    
    private static func getRandomVideoName(prefix: String) -> String? {
        guard let count = videoCounts[prefix], count > 0 else {
            return "\(prefix)_1"
        }
        
        let randomNumber = Int.random(in: 1...count)
        
        return "\(prefix)_\(randomNumber)"
    }
    
    //Сопоставление имя SF-символа с именем видеофайла
    static func getVideoName(for symbolName: String?) -> String? {
        guard let symbolName = symbolName else { return nil }
            
        switch symbolName {
        // Ясно
        case "sun.max.fill":
            return getRandomVideoName(prefix: "sunny_day")
        
        // Ясно ночь
        case "moon.fill":
            return getRandomVideoName(prefix: "sunny_night")
        
        // Переменчивая облачность
        case "cloud.sun.fill":
            return getRandomVideoName(prefix: "clear_sky_day")
        
        // Переменчивая облачность ночь
        case "cloud.moon.fill":
            return getRandomVideoName(prefix: "clear_sky_night")
            
        // Облачно
        case "cloud.fill":
            return getRandomVideoName(prefix: "cloudy_day")
            
        // Легкий дождь/морось
        case "cloud.drizzle.fill":
            return getRandomVideoName(prefix: "drizzle")
            
        // Сильный дождь
        case "cloud.rain.fill":
            return getRandomVideoName(prefix: "rain")
           
        // Ливень
        case "cloud.heavyrain.fill":
            return getRandomVideoName(prefix: "heavyrain")
            
        // Гроза
        case "cloud.bolt.fill":
            return getRandomVideoName(prefix: "stormy")
            
        // Снег
        case "cloud.snow.fill":
            return getRandomVideoName(prefix: "snowy")
            
        // Туман/смог
        case "cloud.fog.fill":
            return getRandomVideoName(prefix: "fog")
            
        // Смог
        case "smoke.fill":
            return getRandomVideoName(prefix: "smoke")

        default:
            return nil
        }
    }
}
