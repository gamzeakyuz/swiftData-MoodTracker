//
//  HapticManager.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 6.11.2025.
//

import Foundation
import UIKit

final class HapticManager {
    
    static let instance = HapticManager()
    
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}
