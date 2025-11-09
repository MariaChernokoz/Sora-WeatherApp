//
//  ContentView.swift
//  Sora
//
//  Created by Chernokoz on 06.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var temperature = "22°"
    @State private var weatherDescription = "Идеальный день для маленького приключения"
    
    var body: some View {
        ZStack {
            
            VideoBackgroundView(videoName: "totoro_rain_1 2") //"totoro_rain_1"
            
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

struct WeatherDetailView: View {
    let icon: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title2)
            Text(value)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    ContentView()
}
