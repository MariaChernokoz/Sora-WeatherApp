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
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.black.opacity(0.9), Color.black.opacity(0.7), Color.black.opacity(0.9)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    
                    searchSection
                    
                    cityList
                        .padding(.top, 4)
                    
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
    }
    
    // MARK: - Components

    private var searchSection: some View {
        HStack {
            ZStack(alignment: .leading) {
                if viewModel.cityInput.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.6))
                        Text("Поиск города...")
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(16)
                }
                TextField("", text: $viewModel.cityInput)
                    .padding(.leading, 12)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(16)
                    .padding(.horizontal)
                    .onSubmit {
                        viewModel.addNewCity()
                    }
                    .scrollDismissesKeyboard(.immediately)
            }
            if viewModel.isLoading {
                ProgressView("Ищем город...")
                    .padding(.trailing, 8)
            }
        }
        .glassEffect(.clear)
        .padding(.horizontal)
    }
    
    private var cityList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.cities) { city in
                    NavigationLink(destination: CityDetailView(city: city, videoName: VideoNameMapper.getVideoName(for: city.weatherData?.symbolName))) {
                        ZStack {
                            backgroundVideo(for: city.weatherData?.symbolName, сityName: city.name)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        if city.isCurrentLocation {
                                            Image(systemName: "location.fill")
                                                .foregroundColor(.blue)
                                                .font(.caption)
                                        }
                                        
                                        Text(city.name)
                                            .font(.headline)
                                            .foregroundColor(.white.opacity(0.9))
                                            .padding(.vertical, 16)
                                    }
                                    
                                    if let weather = city.weatherData {
                                        Text(weather.description)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                .padding(.leading, 10)
                                
                                Spacer()
                                
                                if let weather = city.weatherData {
                                    HStack {
                                        Image(systemName: weather.symbolName)
                                            .imageScale(.large)
                                            .foregroundColor(.orange)
                                        
                                        Text(weather.temperature)
                                            .font(.largeTitle)
                                            .foregroundColor(.white.opacity(0.9))
                                            .frame(width: 66, alignment: .trailing)
                                            .monospacedDigit()
                                    }
                                } else {
                                    Text("Загружаю погоду...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal,15)
                                        .frame(width: 150, alignment: .trailing)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 2)
        }
    }
    
    private func backgroundVideo(for symbolName: String?, сityName: String) -> some View {
        let videoName = VideoNameMapper.getVideoName(for: symbolName)
        if let name = videoName {
            return AnyView(CustomVideoPlayer(videoName: name, isRotated: false))
        } else {
            return AnyView(
                LinearGradient(
                    colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
}

#Preview {
    CityView()
}
