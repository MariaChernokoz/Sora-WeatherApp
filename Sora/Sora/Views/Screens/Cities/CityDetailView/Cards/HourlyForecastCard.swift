//
//  HourlyForecastCard.swift
//  Sora
//
//  Created by Chernokoz on 26.11.2025.
//

import SwiftUI

struct HourlyForecastCard: View {
    let forecast: HourlyForecast
    let timezoneOffset: Int?
    
    private func formatTime(from date: Date, offset: Int?) -> String {
        let formatter = DateFormatter()
        if let offset = offset, let timeZone = TimeZone(secondsFromGMT: offset) {
            formatter.timeZone = timeZone
        } else {
            formatter.timeZone = .current
        }
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text(formatTime(from: forecast.date, offset: timezoneOffset))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
            
            Image(systemName: forecast.symbolName)
                .renderingMode(.original)
                .font(.title2)
                .frame(height: 30)
            
            Text(forecast.temperature)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.top, 8)
    }
}

//#Preview {
//    HourlyForecastCard()
//}
