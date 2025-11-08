//
//  Emotion.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 5.11.2025.
//

import Foundation
import SwiftUI

enum Emotion: String, Codable, CaseIterable, Identifiable {
    
    case happiness, sadness, anger, fear, surprise, love
    case calm, anxiety, excitement, boredom

    var id: Self { self }

    var emoji: String {
        switch self {
        case .happiness: return "😄"
        case .sadness: return "😢"
        case .anger: return "😡"
        case .fear: return "😨"
        case .surprise: return "😲"
        case .love: return "❤️"
        case .calm: return "😌"
        case .anxiety: return "😰"
        case .excitement: return "🤩"
        case .boredom: return "🥱"
        }
    }

    var color: Color {
        switch self {
        case .happiness: return .yellow
        case .sadness: return .blue
        case .anger: return .red
        case .fear: return .gray
        case .surprise: return Color.teal
        case .love: return .pink
        case .calm: return Color.cyan.opacity(0.8)
        case .anxiety: return Color.indigo
        case .excitement: return .purple
        case .boredom: return Color.gray.opacity(0.6)
        }
    }

    var label: String {
        switch self {
        case .happiness: return "Mutlu"
        case .sadness: return "Hüzünlü"
        case .anger: return "Öfkeli"
        case .fear: return "Korku"
        case .surprise: return "Şaşırmış"
        case .love: return "Sevgi Dolu"
        case .calm: return "Sakin"
        case .anxiety: return "Endişeli"
        case .excitement: return "Heyecanlı"
        case .boredom: return "Sıkılmış"
        }
    }
}
