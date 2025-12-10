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
    private let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast"
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
            
            let windSpeed = owmResponse.wind?.speed ?? 0.0
            let windDeg = owmResponse.wind?.deg ?? 0.0
            
            let sunrise = owmResponse.sys?.sunrise
            let sunset = owmResponse.sys?.sunset
            
            let timezoneOffset = owmResponse.timezone
            
            return CityWeather(
                temperature: temperature,
                symbolName: symbolName,
                description: description,
                feels_like: owmResponse.main.feels_like,
                temp_min: owmResponse.main.temp_min,
                temp_max: owmResponse.main.temp_max,
                pressure: owmResponse.main.pressure,
                humidity: owmResponse.main.humidity,
                sunrise: sunrise,
                sunset: sunset,
                windSpeed: windSpeed,
                windDeg: windDeg,
                timezoneOffset: timezoneOffset
            )
            
        } catch {
            throw WeatherServiceError.decodingError(error)
        }
    }

    func fetchForecast(for coordinate: CLLocationCoordinate2D) async throws -> [HourlyForecast] {

        let urlString = "\(forecastUrl)?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)&units=metric&lang=ru"

        guard let url = URL(string: urlString) else {
            throw WeatherServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherServiceError.networkError(NSError(domain: "Network", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "HTTP Status Error"]))
        }

        do {
            let owmForecastResponse = try decoder.decode(ForecastOWMResponse.self, from: data)
                 
            let hourlyForecasts = owmForecastResponse.list.map { item in
                let rawTemp = item.main.temp
                let timeInterval = item.dt
                
                let tempString = self.formatTemperature(rawTemp)
                let timeString = ""
                
                let iconName = self.getSFName(for: item.weather.first?.icon ?? "01d")
                let description = item.weather.first?.description.capitalized ?? ""
                
                return HourlyForecast(
                    date: Date(timeIntervalSince1970: timeInterval),
                    rawTemperature: rawTemp,
                    time: timeString,
                    temperature: tempString,
                    symbolName: iconName,
                    description: description
                )
            }
            
//            //logs
//            print("--- [Forecast Ready for UI] ---")
//            if let firstFormattedItem = hourlyForecasts.first {
//                print("Первая форматированная точка: \(firstFormattedItem.time), \(firstFormattedItem.temperature), Icon: \(firstFormattedItem.symbolName)")
//            }
//            print("-------------------------------")
            
            return hourlyForecasts

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
    
    private func formatTime(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func formatTemperature(_ temp: Double) -> String {
        return String(format: "%.0f°", temp)
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
