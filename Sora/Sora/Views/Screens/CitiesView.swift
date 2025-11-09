//
//  CitiesView.swift
//  Sora
//
//  Created by Chernokoz on 09.11.2025.
//

import SwiftUI

struct CitiesView: View {
    @State var cityInput: String = ""
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                TextField("Введите название города...", text: $cityInput)
                    .padding(16)
                    .glassEffect(.clear)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Список городов")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Здесь будет список ваших городов")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Добавить город")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .glassEffect()
                    }
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
    CitiesView()
}
