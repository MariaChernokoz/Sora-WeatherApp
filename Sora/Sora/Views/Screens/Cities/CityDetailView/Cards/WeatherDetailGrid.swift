//
//  WeatherDetailGrid.swift
//  Sora
//
//  Created by Chernokoz on 26.11.2025.
//

import SwiftUI

struct WeatherDetailsGrid: View {
    let weather: CityWeather

    var body: some View {
        Group {
            HStack(spacing: 20) {
                // Ощущается
                WeatherDetailCard(
                    title: "Ощущается",
                    iconName: "thermometer",
                    iconColor: .orange.opacity(0.8),
                    value: "\(Int(weather.feels_like.rounded()))",
                    unit: "°"
                )

                // Влажность
                WeatherDetailCard(
                    title: "Влажность",
                    iconName: "drop",
                    iconColor: .blue.opacity(0.8),
                    value: "\(weather.humidity)",
                    unit: "%"
                )
            }
            .padding(.top, 12)

            HStack(spacing: 20) {
                // Давление
                WeatherDetailCard(
                    title: "Давление",
                    iconName: "barometer",
                    iconColor: .gray,
                    value: "\(hPaToMmHg(hPa: weather.pressure))",
                    unit: "мм "
                )
                
                // Ветер
                WeatherDetailCard(
                    title: "Ветер \(windDirection(for: weather.windDeg))",
                    iconName: "wind",
                    iconColor: .green,
                    value: String(format: "%.1f", weather.windSpeed),
                    unit: "м/с"
                )
            }

            HStack(spacing: 16) {
                // Восход
                WeatherDetailCard(
                    title: "Восход",
                    iconName: "sunrise.fill",
                    iconColor: .yellow,
                    value: timeString(from: weather.sunrise),
                    unit: ""
                )
                
                // Закат
                WeatherDetailCard(
                    title: "Закат",
                    iconName: "sunset.fill",
                    iconColor: .orange,
                    value: timeString(from: weather.sunset),
                    unit: ""
                )
            }
        }
        //.padding(.horizontal, 16)
    }
}

//#Preview {
//    WeatherDetailGrid()
//}
