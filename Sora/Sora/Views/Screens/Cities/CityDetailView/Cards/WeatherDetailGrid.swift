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
            HStack(spacing: 16) {
                // Ощущается
                WeatherDetailCard(
                    title: "Ощущается как",
                    iconName: "thermometer",
                    iconColor: .orange.opacity(0.8),
                    value: "\(Int(weather.feels_like.rounded()))",
                    unit: "°",
                    description: ""
                )

                // Влажность
                WeatherDetailCard(
                    title: "Влажность",
                    iconName: "drop",
                    iconColor: .blue.opacity(0.8),
                    value: "\(weather.humidity)",
                    unit: "%",
                    description: ""
                )
            }
            .padding(.top, 12)

            HStack(spacing: 16) {
                // Давление
                WeatherDetailCard(
                    title: "Давление",
                    iconName: "barometer",
                    iconColor: .gray,
                    value: "\(hPaToMmHg(hPa: weather.pressure))",
                    unit: "мм ",
                    description: ""
                )
                
                // Ветер
                WeatherDetailCard(
                    title: "Ветер",
                    iconName: "wind",
                    iconColor: .green,
                    value: String(format: "%.1f", weather.windSpeed),
                    unit: "м/с",
                    description: "\(windDirection(for: weather.windDeg))"
                )
            }

            HStack(spacing: 16) {
                // Восход
                WeatherDetailCard(
                    title: "Восход",
                    iconName: "sunrise.fill",
                    iconColor: .yellow,
                    value: formatTime(from: weather.sunrise.map { TimeInterval($0) }, offset: weather.timezoneOffset),
                    unit: "",
                    description: ""
                )
                
                // Закат
                WeatherDetailCard(
                    title: "Закат",
                    iconName: "sunset.fill",
                    iconColor: .orange,
                    value: formatTime(from: weather.sunset.map { TimeInterval($0) }, offset: weather.timezoneOffset),
                    unit: "",
                    description: ""
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

//#Preview {
//    WeatherDetailGrid()
//}
