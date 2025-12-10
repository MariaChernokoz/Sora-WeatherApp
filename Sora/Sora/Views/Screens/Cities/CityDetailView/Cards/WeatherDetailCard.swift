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
    let description: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Image(systemName: iconName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(iconColor)
                
                Text(value)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(unit)
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

//#Preview {
//    WeatherDetailCard()
//}
