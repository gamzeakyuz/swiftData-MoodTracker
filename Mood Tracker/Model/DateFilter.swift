//
//  DateFilter.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 6.11.2025.
//

import Foundation


enum DateFilter: String, CaseIterable, Identifiable {
    
    case last7Days = "Son 7 Gün"
    case last30Days = "Son 30 Gün"
    case allTime = "Tüm Zamanlar"
    
    var id: Self { self }
    
    var startDate: Date? {
        let now = Date()
        let calendar = Calendar.current
        switch self {
        case .last7Days:
            return calendar.date(byAdding: .day, value: -7, to: now)
        case .last30Days:
            return calendar.date(byAdding: .day, value: -30, to: now)
        case .allTime:
            return nil
        }
    }
}
