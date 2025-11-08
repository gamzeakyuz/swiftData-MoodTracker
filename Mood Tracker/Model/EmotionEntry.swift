//
//  EmotionEntry.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 5.11.2025.
//

import Foundation
import SwiftData

@Model
final class EmotionEntry {
    
    @Attribute(.unique) var id: UUID
    var timestamp: Date // ne zaman hissedildi
    // Persist enum via its raw value for broad compatibility
    private var emotionRaw: String
    var intensity: Int /// duygu yoğunluğu 1-5 arası
    var notes: String // neden böyle hissediyor
    
    init(timestamp: Date, emotion: Emotion, intensity: Int, notes: String) {
        self.id = UUID()
        self.timestamp = timestamp
        self.emotionRaw = emotion.rawValue
        self.intensity = intensity
        self.notes = notes
    }
    
    var emotion: Emotion {
        get { Emotion(rawValue: emotionRaw) ?? .happiness }
        set { emotionRaw = newValue.rawValue }
    }
    
    static var defaultSort: SortDescriptor<EmotionEntry> {
        SortDescriptor(\.timestamp, order: .reverse)
    }
    
}
