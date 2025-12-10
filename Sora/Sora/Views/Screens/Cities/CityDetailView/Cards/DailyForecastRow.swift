//
//  DailyForecastRow.swift
//  Sora
//
//  Created by Chernokoz on 04.12.2025.
//

import SwiftUI

struct DailyForecastRow: View {
    let forecast: DailyForecast
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    var body: some View {
        Divider()
            .overlay(Color.white.opacity(0.3))
        
        HStack {
            Text(DailyForecastRow.dayFormatter.string(from: forecast.date))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.9))
                .frame(width: 40, alignment: .leading)

            Spacer()
            
            HStack(spacing: 15) {
                Image(systemName: forecast.symbolName)
                    .renderingMode(.original)
                    .font(.title2)
                    .foregroundColor(.orange)
                    .frame(width: 30)
            }
            
            Spacer()

            HStack(spacing: 8) {
                Text("мин")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("\(Int(forecast.minTemperature.rounded()))°")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 40, alignment: .trailing)
                    .monospacedDigit()
                
                Text("макс")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("\(Int(forecast.maxTemperature.rounded()))°")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 40, alignment: .trailing)
                    .monospacedDigit()
            }
        }
        .padding(.top, 8)
    }
}

//#Preview {
//    DailyForecastRow()
//}
