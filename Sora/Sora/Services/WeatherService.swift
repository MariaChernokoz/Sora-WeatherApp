//
//  WeatherService.swift
//  Sora
//
//  Created by Chernokoz on 08.11.2025.
//

import Foundation
import CoreLocation

final class WeatherService {
    private lazy var apiKey: String = self.getAPIKey()
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let decoder = JSONDecoder()

    private func getAPIKey() -> String {
        
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "OpenWeatherMapAPIKey") as? String else {
            
            fatalError("API Key not found in Secrets.plist. Key 'OpenWeatherMapAPIKey' required.")
        }
        
        return value
    }
    
    func fetchWeather(for coordinate: CLLocationCoordinate2D) async throws -> CityWeather {
        
        let urlString = "\(baseUrl)?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)&units=metric&lang=ru"
        
        guard let url = URL(string: urlString) else {
            throw WeatherServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherServiceError.networkError(NSError(domain: "Network", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "HTTP Status Error"]))
        }
        
        do {
            let owmResponse = try decoder.decode(OWMResponse.self, from: data)
            
            guard let weather = owmResponse.weather.first else {
                throw WeatherServiceError.noWeatherData
            }
            
            let temperature = String(format: "%.0f°", owmResponse.main.temp)
            
            let symbolName = self.getSFName(for: weather.icon)
            
            let description = weather.description.capitalized
            
            return CityWeather(
                temperature: temperature,
                symbolName: symbolName,
                description: description
            )
            
        } catch {
            throw WeatherServiceError.decodingError(error)
        }
    }
    
    private func getSFName(for iconCode: String) -> String {
        switch iconCode {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.rain.fill"
        case "10n": return "cloud.heavyrain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "cloud.snow.fill"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "questionmark.circle.fill"
        }
    }
}

// MARK: Service Errors
enum WeatherServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noWeatherData
    case apiKeyNotFound
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Некорректный URL для запроса."
        case .networkError(let error): return "Ошибка сети: \(error.localizedDescription)"
        case .decodingError(let error): return "Ошибка декодирования данных: \(error.localizedDescription)"
        case .noWeatherData: return "Данные о погоде не найдены в ответе."
        case .apiKeyNotFound: return "Ключ API не найден в Secrets.plist."
        }
    }
}
