import SwiftUI

struct CityDetailView: View {
    let city: City
    let videoName: String?
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    if let videoName, !videoName.isEmpty {
                        CustomVideoPlayer(videoName: videoName, isRotated: false)
                            .frame(maxWidth: .infinity, minHeight: 0, maxHeight: 350)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .white, location: 0.0),
                                        .init(color: .blue, location: 0.4),
                                        .init(color: .clear, location: 0.95)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(radius: 8)
                            .ignoresSafeArea(edges: .top)
                    } else {
                        LinearGradient(
                            colors: [Color.gray.opacity(0.7), Color.gray.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(maxWidth: .infinity, maxHeight: 370)
                        .ignoresSafeArea()
                    }
                    
                    VStack(spacing: 12) {
                        Text(city.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        
                        if let weather = city.weatherData {
                            HStack(spacing: 15) {
                                Image(systemName: weather.symbolName)
                                    .imageScale(.large)
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 40))
                                
                                Text(weather.temperature)
                                    .font(.system(size: 60))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                            }
                            Text(weather.description.capitalized)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.85))
                        } else {
                            Text("Погодные данные временно недоступны.")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                }
                .frame(height: 350)
                
                Spacer()
            }
        }
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
    CityDetailView(city: sampleCity, videoName: VideoNameMapper.getVideoName(for: sampleWeather.symbolName))
}
