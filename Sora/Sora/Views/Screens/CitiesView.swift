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
            }
            .padding()
        }
    }
}

#Preview {
    CitiesView()
}
