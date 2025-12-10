import SwiftUI

struct CityDetailView: View {
    let city: City
    let videoName: String?
    
    var body: some View {
        ZStack {
            if let videoName, !videoName.isEmpty {
                CustomVideoPlayer(videoName: videoName, isRotated: true)
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
                        
                        if let hourlyForecasts = city.hourlyForecasts, !hourlyForecasts.isEmpty {
                            VStack(alignment: .leading, spacing: 5) {
                                    
                                Text("ПОЧАСОВОЙ ПРОГНОЗ НА СЕГОДНЯ")
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Divider()
                                    .overlay(Color.white.opacity(0.3))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(hourlyForecasts) { forecast in
                                            HourlyForecastCard(
                                                forecast: forecast,
                                                timezoneOffset: weather.timezoneOffset
                                            )
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        
                        if let dailyForecasts = city.dailyForecasts, !dailyForecasts.isEmpty {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.title2)
                                        .foregroundColor(.white.opacity(0.9))
                                        .frame(width: 30)
                                    
                                    Text("ПРОГНОЗ НА 4 ДНЯ")
                                        .font(.system(size: 16))
                                        .fontWeight(.medium)
                                        .foregroundColor(.white.opacity(0.9))
                                }

                                
                                ForEach(dailyForecasts) { forecast in
                                    DailyForecastRow(forecast: forecast)
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        
                        WeatherDetailsGrid(weather: weather)
                        
                    } else {
                        Text("Погодные данные временно недоступны.")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)
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
        windDeg: 180,
        timezoneOffset: 3
    )
    let sampleCity = City(
        name: "Москва",
        latitude: 55.7558,
        longitude: 37.6173,
        isCurrentLocation: false,
        weatherData: sampleWeather
    )
    CityDetailView(city: sampleCity, videoName: VideoNameMapper.getVideoName(for: sampleWeather.symbolName))
}
