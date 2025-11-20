//
//  WeatherView.swift
//  Sora
//
//  Created by Chernokoz on 07.11.2025.
//

import SwiftUI

struct WeatherView: View {
    @State private var temperature = "22°"
    @State private var weatherDescription = "Идеальный день для маленького приключения"
    
    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: "totoro_rain_1 2", isRotated: true)
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Text(temperature)
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.primary.opacity(0.8))
                    
                    Text(weatherDescription)
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.primary.opacity(0.8))
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 30)
                .glassEffect(.clear)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    WeatherView()
}
