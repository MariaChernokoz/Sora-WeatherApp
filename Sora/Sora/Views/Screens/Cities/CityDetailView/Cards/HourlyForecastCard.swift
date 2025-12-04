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
        VStack(spacing: 10) {
            
            Text(forecast.time)
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
//        .frame(width: 80)
//        .background(Color.black.opacity(0.35))
//        .glassEffect(.regular)
//        .cornerRadius(60)
    }
}

//#Preview {
//    HourlyForecastCard()
//}
