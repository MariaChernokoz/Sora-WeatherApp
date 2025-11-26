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
    let directions = ["С", "СВ", "В", "ЮВ", "Ю", "ЮЗ", "З", "СЗ"]
    let index = Int((degree + 22.5) / 45.0) % 8
    return directions[index]
}

public func timeString(from timestamp: Int?) -> String {
    guard let timestamp = timestamp else { return "-" }
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}
