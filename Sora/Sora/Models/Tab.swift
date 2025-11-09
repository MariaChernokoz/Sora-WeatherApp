//
//  Tab.swift
//  Sora
//
//  Created by Chernokoz on 09.11.2025.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case weather
    case map
    case cities
    
    var iconName: String {
        switch self {
        case .weather: return "cloud.sun.fill"
        case .map: return "map.fill"
        case .cities: return "list.bullet"
        }
    }
    
    var title: String {
        switch self {
        case .weather: return "Weather"
        case .map: return "Map"
        case .cities: return "Cities"
        }
    }
}

