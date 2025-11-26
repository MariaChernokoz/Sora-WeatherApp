import SwiftUI

struct CityDetailView: View {
    let city: City
    let videoName: String?
    
    var body: some View {
        ZStack {
            if let videoName, !videoName.isEmpty {
                CustomVideoPlayer(videoName: videoName, isRotated: true)
                    .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [Color.gray.opacity(0.7), Color.gray.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            ScrollView {
                VStack(spacing: 12) {
                    Text(city.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.4), radius: 2)
                    
                    if let weather = city.weatherData {
                        HStack(spacing: 15) {
                            Image(systemName: weather.symbolName)
                                .imageScale(.large)
                                .foregroundColor(.orange)
                                .font(.system(size: 40))
                                .shadow(color: Color.black.opacity(0.4), radius: 2)
                            
                            Text(weather.temperature)
                                .font(.system(size: 60))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.4), radius: 2)
                        }
                        Text(weather.description.capitalized)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white.opacity(0.95))
                            .shadow(color: Color.black.opacity(0.4), radius: 2)
                        
                        Group {
                            HStack(spacing: 10) {
                                WeatherDetailCard(
                                    title: "Ощущается",
                                    iconName: "thermometer",
                                    iconColor: .orange.opacity(0.8),
                                    value: "\(Int(weather.feels_like.rounded()))",
                                    unit: "°"
                                )
                                
                                WeatherDetailCard(
                                    title: "Влажность",
                                    iconName: "drop",
                                    iconColor: .blue.opacity(0.8),
                                    value: "\(weather.humidity)",
                                    unit: "%"
                                )
                            }
                            .padding(.top, 40)
                            
                            HStack(spacing: 10) {
                                WeatherDetailCard(
                                    title: "Давление",
                                    iconName: "barometer",
                                    iconColor: .gray,
                                    value: "\(hPaToMmHg(hPa: weather.pressure))",
                                    unit: "мм "
                                )
                                .glassEffect(.clear)
                                
                                WeatherDetailCard(
                                    title: "Ветер \(windDirection(for: weather.windDeg))",
                                    iconName: "wind",
                                    iconColor: .green,
                                    value: String(format: "%.1f", weather.windSpeed),
                                    unit: "м/с"
                                )
                                .glassEffect(.clear)
                            }
                            
                            HStack {
                                WeatherDetailCard(
                                    title: "Восход",
                                    iconName: "sunrise.fill",
                                    iconColor: .yellow,
                                    value: timeString(from: weather.sunrise), 
                                    unit: ""
                                )
                                .glassEffect(.clear)
                                
                                WeatherDetailCard(
                                    title: "Закат",
                                    iconName: "sunset.fill",
                                    iconColor: .orange,
                                    value: timeString(from: weather.sunset),
                                    unit: ""
                                )
                                .glassEffect(.clear)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        if let hourlyForecasts = city.hourlyForecasts, !hourlyForecasts.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Прогноз на 5 дней (3 часа)")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(hourlyForecasts) { forecast in
                                            // 4.2. Мы добавим сюда HourlyForecastCard
                                            HourlyForecastCard(forecast: forecast)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 20)
                                }
                                .padding(.top, 5)
                            }
                        }
                        
                    } else {
                        Text("Погодные данные временно недоступны.")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    let sampleWeather = CityWeather(
        temperature: "22°",
        symbolName: "sun.max.fill",
        description: "Ясно",
        feels_like: 21.0,
        temp_min: 18.0,
        temp_max: 25.0,
        pressure: 1012.0,
        humidity: 72,
        sunrise: 1700790000,
        sunset: 1700826000,
        windSpeed: 3.5,
        windDeg: 180
    )
    let sampleCity = City(
        id: UUID(),
        name: "Москва",
        latitude: 55.7558,
        longitude: 37.6173,
        isCurrentLocation: false,
        weatherData: sampleWeather
    )
    CityDetailView(city: sampleCity, videoName: VideoNameMapper.getVideoName(for: sampleWeather.symbolName))
}
