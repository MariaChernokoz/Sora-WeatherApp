//
//  WeatherView.swift
//  Sora
//
//  Created by Chernokoz on 07.11.2025.
//

import SwiftUI

struct WeatherView: View {
    
    @EnvironmentObject var viewModel: CityViewModel
    @State private var selectedCityID: City.ID?
    
    var body: some View {
        ZStack {
            if let currentCity = viewModel.cities.first(where: { $0.id == selectedCityID }),
               let videoName = VideoNameMapper.getVideoName(for: currentCity.weatherData?.symbolName ?? "") {
                
                CustomVideoPlayer(videoName: videoName, isRotated: true)
                    .ignoresSafeArea(.all)
                
            } else if viewModel.cities.isEmpty {
                VideoBackgroundView(videoName: "totoro_rain_1 2", isRotated: true)
                    .ignoresSafeArea(.all)
                
            } else {
                Color.gray.ignoresSafeArea(.all)
            }

            TabView(selection: $selectedCityID) {
                if !viewModel.cities.isEmpty {

                    ForEach(viewModel.cities) { city in
                        CityDetailView(city: city, videoName: "")
                            .tag(city.id as City.ID?)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .onAppear {
            if selectedCityID == nil, let firstCity = viewModel.cities.first {
                selectedCityID = firstCity.id
            }
        }
    }
}

#Preview {
    WeatherView()
}
