//
//  EntryDetailView.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 6.11.2025.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    
    let entry: EmotionEntry
    
    var body: some View {
        ZStack {
            
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            RadialGradient(gradient: Gradient(colors: [entry.emotion.color.opacity(0.3), Color.clear]),
                           center: .top,
                           startRadius: 10,
                           endRadius: 400)
            .ignoresSafeArea()
            
            ScrollView {
                
                
                VStack(spacing: 24) {
                    
                    VStack(spacing: 8) {
                        
                        Text(entry.emotion.emoji)
                            .font(.system(size: 90))
                            //.frame(width: 100, height: 100)
                            //.background(entry.emotion.color)
                            //.clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                        
                        Text(entry.emotion.label)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(entry.emotion.color)
                        
                    }
                    .padding(.top, 20)
                    
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Aklından Geçenler")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(entry.notes)
                            .font(.body)
                            .lineSpacing(5)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                    .padding(.horizontal)
                    
                    
                    
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        DetailRow(icon: "calendar",
                                  label: "Tarih",
                                  value: entry.timestamp.formatted(date: .long, time: .omitted))
                        
                        DetailRow(icon: "clock.fill",
                                  label: "Saat",
                                  value: entry.timestamp.formatted(date: .omitted, time: .shortened))
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Label("Yoğunluk", systemImage: "star.leadinghalf.filled")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 4) {
                                
                                ForEach(1...5, id: \.self) { index in
                                    
                                    Image(systemName: index <= entry.intensity ? "star.fill" : "star")
                                        .font(.title3)
                                        .foregroundStyle(entry.emotion.color)
                                    
                                }
                                
                            }
                            .padding(.leading, 3)
                            
                        }
                        
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                }
            }
            .navigationTitle(entry.timestamp.formatted(date: .abbreviated, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailRow: View {
    
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(label, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.leading, 3)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: EmotionEntry.self, configurations: config)
    
    let sample = EmotionEntry(timestamp: .now,
                              emotion: .happiness,
                              intensity: 4,
                              notes: "Bugün çok iyi hissediyorum! Güne güzel bir kahve ile başladım.")
    container.mainContext.insert(sample)
    
    return NavigationStack {
        EntryDetailView(entry: sample)
    }
    .modelContainer(container)
}
