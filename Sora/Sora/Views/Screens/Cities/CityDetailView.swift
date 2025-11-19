//
//  CityDetailView.swift
//  Sora
//
//  Created by Chernokoz on 19.11.2025.
//

import SwiftUI

struct CityDetailView: View {
    let city: City
    var body: some View {
        VStack {
            Text(city.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let weather = city.weatherData {
                HStack(spacing: 15) {
                    Image(systemName: weather.symbolName)
                        .imageScale(.large)
                        .foregroundColor(.yellow)
                        .font(.system(size: 40))
                    
                    Text(weather.temperature)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                }
                    
                Text(weather.description.capitalized)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
            } else {
                Text("Погодные данные временно недоступны.")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let sampleWeather = CityWeather(
        temperature: "22°",
        symbolName: "sun.max.fill",
        description: "Ясно"
    )
    let sampleCity = City(
        id: UUID(),
        name: "Москва",
        latitude: 55.7558,
        longitude: 37.6173,
        isCurrentLocation: false,
        weatherData: sampleWeather
    )
    CityDetailView(city: sampleCity)
}
