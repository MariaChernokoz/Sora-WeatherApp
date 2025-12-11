//
//  DailyForecast.swift
//  Sora
//
//  Created by Chernokoz on 04.12.2025.
//

import Foundation

public struct DailyForecast: Identifiable, Equatable {
    public let id = UUID()
    let date: Date
    let minTemperature: Double
    let maxTemperature: Double
    let symbolName: String
    let description: String
    
    var formattedMinMaxTemperature: String {
        return "Макс: \(Int(maxTemperature.rounded()))° Мин: \(Int(minTemperature.rounded()))°"
    }
}
