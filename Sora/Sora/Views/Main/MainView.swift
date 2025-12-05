//
//  MainView.swift
//  Sora
//
//  Created by Chernokoz on 09.11.2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var cityViewModel: CityViewModel
    
    @State private var selectedTab: Tab = .weather
    
    init() {
        let viewModel = CityViewModel(context: ModelContext(try! SwiftData.ModelContainer(for: CityEntity.self)))
        _cityViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WeatherView()
                .tag(Tab.weather)
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.fill")
                }
            
            CityView()
                .tag(Tab.cities)
                .tabItem {
                    Label("Cities", systemImage: "list.bullet")
                }
        }
        .toolbarBackground(.hidden, for: .tabBar)
        .environmentObject(cityViewModel)
        .tabViewStyle(.sidebarAdaptable)
        .tint(.white)
    }
}

#Preview {
    MainView()
}
