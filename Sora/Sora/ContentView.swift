//
//  ContentView.swift
//  Sora
//
//  Created by Chernokoz on 06.11.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
    }
}

struct WeatherDetailView: View {
    let icon: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title2)
            Text(value)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    ContentView()
}
