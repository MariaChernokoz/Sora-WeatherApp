//
//  WeatherUtilities.swift
//  Sora
//
//  Created by Chernokoz on 26.11.2025.
//

import Foundation

public func hPaToMmHg(hPa: Double) -> Int {
    return Int((hPa * 0.75006375541921).rounded())
}

public func windDirection(for degree: Double) -> String {
    let directions = ["Северный", "Северо-Восточный", "Восточный", "Юго-Восточный", "Южный", "Юго-Западный", "Западный", "Севро-Западный"]
    let index = Int((degree + 22.5) / 45.0) % 8
    return directions[index]
}

public func formatTime(from timestamp: TimeInterval?, offset: Int?) -> String {
    guard let timestamp = timestamp, let offset = offset else {
        return "N/A"
    }
    
    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    
    if let timeZone = TimeZone(secondsFromGMT: offset) {
        formatter.timeZone = timeZone
    } else {
        formatter.timeZone = .current
    }
    
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "HH:mm"
    
    return formatter.string(from: date)
}

public func formatTime(from timestamp: TimeInterval, offset: Int? = nil, format: String = "HH:mm") -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    
    if let offset = offset, let timeZone = TimeZone(secondsFromGMT: offset) {
        formatter.timeZone = timeZone
    } else {
        formatter.timeZone = .current
    }
    
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = format
    
    return formatter.string(from: date)
}
