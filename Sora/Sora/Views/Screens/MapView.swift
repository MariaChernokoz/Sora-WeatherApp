//
//  MapView.swift
//  Sora
//
//  Created by Chernokoz on 07.11.2025.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        ZStack {
            // Временный градиентный фон
            LinearGradient(
                colors: [Color.black.opacity(0.9), Color.black.opacity(0.7), Color.black.opacity(0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Карта осадков")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Здесь будет карта с осадками")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(40)
                .glassEffect(.clear)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    MapView()
}
