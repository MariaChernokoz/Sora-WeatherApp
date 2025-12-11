//
// WeatherWidget.swift
// WeatherWidget
//
// Created by Chernokoz on 11.12.2025.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct Provider: TimelineProvider {
    private let appGroupName = "group.maria.SoraWeather"
    private let userDefaultsKey = "lastKnownLocation"
    
    private func getLastKnownCoordinates() -> CLLocationCoordinate2D? {
        let sharedUserDefaults = UserDefaults(suiteName: appGroupName)
        
        guard let locationData = sharedUserDefaults?.dictionary(forKey: userDefaultsKey) as? [String: Double] else {
            return nil
        }
        
        guard let lat = locationData["latitude"],
              let lon = locationData["longitude"]
        else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), city: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), city: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let coordinates = getLastKnownCoordinates()
            var cityData: City? = nil
            
            if let coords = coordinates {
                let weatherService = WeatherService()
                var cityName: String = "Current Location"
                
                do {
                    cityName = try await weatherService.fetchCityName(for: coords)
                    
                    let weather = try await weatherService.fetchWeather(for: coords)
                    
                    cityData = City(
                        name: cityName,
                        latitude: coords.latitude,
                        longitude: coords.longitude,
                        isCurrentLocation: true,
                        weatherData: weather
                    )
                } catch {
                    
                }
            } else {
                
            }
            
            let currentDate = Date()
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            
            let entry = SimpleEntry(date: currentDate, city: cityData)
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let city: City?
}

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            if let city = entry.city, let weather = city.weatherData {
                
                VStack(alignment: .leading) {
                    Text(city.name)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(weather.description.capitalized)
                        .font(.system(size: 12, weight: .light))
                    
                    HStack {
                        Image(systemName: weather.symbolName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        
                        Text(weather.temperature)
                            .font(.system(size: 25, weight: .bold))
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                }
            } else {
                VStack {
                    Text("Sora Weather")
                        .font(.headline)
                    Text("Waiting for location...")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            }
        }
        .widgetBackground {
            Image("widgetBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
        }
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Current Weather")
        .description("Shows the weather summary for your current location.")
    }
}

extension View {
    
    @ViewBuilder
    func widgetBackground<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(for: .widget) {
                content()
            }
        } else {
            self.background(content())
        }
    }
}
