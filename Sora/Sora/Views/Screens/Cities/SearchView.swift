//
//  SearchView.swift
//  Sora
//
//  Created by Chernokoz on 07.12.2025.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: CityViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var localCityInput: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black.opacity(0.6), Color.black.opacity(0.3), Color.black.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                searchActiveField
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                List {
                    ForEach(viewModel.searchCompleter.completions) { completion in
                        VStack(alignment: .leading) {
                            Text(completion.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(completion.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            viewModel.selectCity(completion: completion)
                            dismiss()
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            
        }
    }
    
    private var searchActiveField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.6))
            
            TextField("Поиск города...", text: $localCityInput)
                .foregroundColor(.white.opacity(0.9))
                .onChange(of: localCityInput) { newValue in
                    viewModel.searchCompleter.queryFragment = newValue
                    viewModel.cityInput = newValue
                }
                .onSubmit {
                    if let firstCompletion = viewModel.searchCompleter.completions.first {
                        viewModel.selectCity(completion: firstCompletion)
                        dismiss()
                    }
                }
            
            if !localCityInput.isEmpty {
                Button {
                    localCityInput = ""
                    viewModel.searchCompleter.queryFragment = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(16)
        .glassEffect(.clear)
        .padding(.horizontal, 16)
    }
}

#Preview {
    SearchView()
}
