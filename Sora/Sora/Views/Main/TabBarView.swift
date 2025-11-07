//
//  TabBarView.swift
//  Sora
//
//  Created by Chernokoz on 07.11.2025.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Tab
    @Namespace private var animationNamespace
    
    var body: some View {
        GlassEffectContainer(spacing: 20.0) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabBarButton(
                        tab: tab,
                        selectedTab: $selectedTab,
                        animationNamespace: animationNamespace
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 80)
        .padding(.horizontal, 20)
    }
}

struct TabBarButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    let animationNamespace: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if selectedTab == tab {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .matchedGeometryEffect(id: "selected_tab", in: animationNamespace)
                            .frame(width: 50, height: 50)
                    }
                    
                    Image(systemName: tab.iconName)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
                        .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
            }
            .frame(height: 60)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Модель для вкладок
enum Tab: CaseIterable {
    case home
    case weather
    case map
    case settings
    
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .weather: return "cloud.sun.fill"
        case .map: return "map.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Главная"
        case .weather: return "Погода"
        case .map: return "Карта"
        case .settings: return "Настройки"
        }
    }
}

#Preview {
//    TabBarView()
//        .background(Color(.systemGray4))
    ZStack {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack {
            Spacer()
            TabBarView(selectedTab: .constant(.home))
        }
    }
}
