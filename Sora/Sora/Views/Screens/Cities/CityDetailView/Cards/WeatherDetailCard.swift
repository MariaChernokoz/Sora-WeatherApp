//
//  WeatherDetailCard.swift
//  Sora
//
//  Created by Chernokoz on 26.11.2025.
//

import SwiftUI

struct WeatherDetailCard: View {
    let title: String
    let iconName: String
    let iconColor: Color
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Image(systemName: iconName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(iconColor)
                    .padding(.leading, 20)
                
                Text(value)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(unit)
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.trailing, 8)
            }
        }
        .frame(width: 180, height: 120)
        .background(Color.black.opacity(0.28))
        .glassEffect(.regular)
        .shadow(color: Color.black.opacity(0.2), radius: 8)
        .cornerRadius(60)
    }
}

//#Preview {
//    WeatherDetailCard()
//}
