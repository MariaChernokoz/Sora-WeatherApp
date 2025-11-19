//
//  CitiesView.swift
//  Sora
//
//  Created by Chernokoz on 09.11.2025.
//

import SwiftUI

struct CityView: View {
    
    @StateObject var viewModel = CityViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                
                searchSection
                
                cityList
                
                Spacer()
                
                if let error = viewModel.error {
                    Text("Ошибка: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Components

    private var searchSection: some View {
        HStack {
            TextField("Название города...", text: $viewModel.cityInput)
                .padding(16)
                .glassEffect(.clear)
                .padding(.horizontal)
                .onSubmit {
                    viewModel.addNewCity()
                }
                .scrollDismissesKeyboard(.immediately)
            
            if viewModel.isLoading {
                ProgressView("Ищем город...")
                    .padding(.trailing, 8)
            }
        }
    }
    
    private var cityList: some View {
        List {
            ForEach(viewModel.cities) { city in
                HStack {
                    if city.isCurrentLocation {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.headline)
                        
                        if let weather = city.weatherData {
                            Text(weather.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    if let weather = city.weatherData {
                        HStack(spacing: 15) {
                            
                            Image(systemName: weather.symbolName)
                                .imageScale(.large)
                                .foregroundColor(.orange)
                            
                            Text(weather.temperature)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    } else {
                        Text("—")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding(.horizontal,15)
                    }
                }
            }
            .onDelete { indexSet in
                viewModel.deleteCities(at: indexSet)
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    CityView()
}
