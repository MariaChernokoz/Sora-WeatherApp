//
//  MainView.swift
//  Sora
//
//  Created by Chernokoz on 09.11.2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .weather
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WeatherView()
                .tag(Tab.weather)
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.fill")
                }
            
            MapView()
                .tag(Tab.map)
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            
            CityView()
                .tag(Tab.cities)
                .tabItem {
                    Label("Cities", systemImage: "list.bullet")
                }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(.white)
    }
}

#Preview {
    MainView()
}
