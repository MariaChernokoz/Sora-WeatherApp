//
//  CitiesView.swift
//  Sora
//
//  Created by Chernokoz on 09.11.2025.
//

import SwiftUI

struct CityView: View {
    
    @EnvironmentObject var viewModel: CityViewModel
    //@State private var activeCity: City?
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.black.opacity(0.6), Color.black.opacity(0.3), Color.black.opacity(0.5)],
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
        VStack(alignment: .leading, spacing: 0) {
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
            
            if !viewModel.searchCompleter.completions.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(viewModel.searchCompleter.completions) { completion in
                        Button {
                            viewModel.selectCity(completion: completion)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(completion.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(completion.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider().background(Color.white.opacity(0.1))
                    }
                }
                .background(Color.black.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 4)
            }
        }
        .padding(.horizontal)
    }
    
    private var cityList: some View {
        List {
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
                            .padding(.horizontal, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        //.padding(.horizontal, 4)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 1)
                        .padding(.bottom, 8)
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: viewModel.deleteCities)
            }
        //.frame(maxWidth: .infinity, alignment: .center)
        .listStyle(.plain)
        .padding(.top, 8)
        //.padding(.leading, 20)
        .scrollIndicators(.hidden)
        //.ignoresSafeArea(.all, edges: .bottom)
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
