//
//  HourlyForecastCard.swift
//  Sora
//
//  Created by Chernokoz on 26.11.2025.
//

import SwiftUI

struct HourlyForecastCard: View {
    let forecast: HourlyForecast
    
    var body: some View {
        VStack(spacing: 8) {
            
            // Время (напр., 15:00)
            Text(forecast.time)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
            
            // Иконка SFSymbol
            Image(systemName: forecast.symbolName)
                .renderingMode(.original)
                .font(.title2)
                .frame(height: 30) // Для равномерного размера
            
            // Температура (напр., 12°)
            Text(forecast.temperature)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(12)
        .frame(width: 80) // Фиксированная ширина для скролла
        .background(Color.black.opacity(0.35))
        .glassEffect(.regular)
        .cornerRadius(20)
    }
}

//#Preview {
//    HourlyForecastCard()
//}
