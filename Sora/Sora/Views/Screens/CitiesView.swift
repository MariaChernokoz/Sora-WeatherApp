//
//  CitiesView.swift
//  Sora
//
//  Created by Chernokoz on 09.11.2025.
//

import SwiftUI

struct CitiesView: View {
    @StateObject var viewModel = CitiesViewModel()
    //(cities: ["Moscow", "New York", "London", "Tokyo", "Berlin"])
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                TextField("Введите название города...", text: $viewModel.cityInput)
                    .padding(16)
                    .glassEffect(.clear)
                    .onSubmit {
                        viewModel.addNewCity()
                    }
                    .scrollDismissesKeyboard(.immediately)
                
                if viewModel.isLoading {
                    ProgressView("Ищем город...")
                }
                
                List {
                    ForEach(viewModel.cities) { city in
                        HStack {
                            Text(city.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Широта: \(city.latitude, specifier: "%.4f")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Долгота: \(city.longitude, specifier: "%.4f")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                
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

#Preview {
    CitiesView()
}
