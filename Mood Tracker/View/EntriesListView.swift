//
//  EntriesListView.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 5.11.2025.
//

import SwiftUI
import SwiftData

struct EntriesListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \EmotionEntry.timestamp, order: .reverse) private var entries: [EmotionEntry]
    
    @State private var isShowingAddEntryView = false
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                if entries.isEmpty {
                    emptyView
                } else {
                    listView
                }
                
            }
            .navigationTitle("Hislerim")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddEntryView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $isShowingAddEntryView) {
                AddEntryView()
                    
            }
        }
       
    }
    
    @ViewBuilder
    private var listView: some View {
        
        List {
            
            ForEach(groupedEntries.keys.sorted(by: >), id: \.self){ date in
                
                Section(header: Text(fomatDateHeader(date))) {
                    
                    if let entriesForDate = groupedEntries[date] {
                        
                        ForEach(entriesForDate) { entry in
                            
                            NavigationLink {
                                EntryDetailView(entry: entry)
                            } label: {
                                HStack(spacing: 15) {
                                    
                                    Text(entry.emotion.emoji)
                                        .font(.largeTitle)
                                        .padding(10)
                                        .background(entry.emotion.color.opacity(0.2))
                                        .clipShape(Circle())
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        
                                        Text(entry.emotion.label)
                                            .font(.headline)
                                            .foregroundStyle(entry.emotion.color)
                                        
                                        Text(entry.notes)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(entry.timestamp.formatted(date: .omitted, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.vertical, 8)
                            }
                            
                        }
                        .onDelete { indexSet in
                            deleteEntry(at: indexSet, from: entriesForDate)
                        }
                    }
                    
                }
                
            }
            
        }
        .listStyle(.insetGrouped)
        
    }
    @ViewBuilder
    private var emptyView: some View {
        
        ContentUnavailableView (
            "Henüz Giriş Yok",
            systemImage: "square.and.pencil",
            description: Text("Yeni bir duygu girişi eklemek için sağ üstteki (+) simgesine tıklayınız.")
        )
        
    }
    
    private var groupedEntries: [Date: [EmotionEntry]] {
        Dictionary(grouping: entries) { entry in
            Calendar.current.startOfDay(for: entry.timestamp)
        }
    }
    private func fomatDateHeader(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Bugün"
        }
        if Calendar.current.isDateInYesterday(date) {
            return "Dün"
        }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
    private  func deleteEntry(at offsets: IndexSet, from entriesForDate: [EmotionEntry]) {
        
        let entriesToDelete = offsets.map { entriesForDate[$0] }
        
        for entry in entriesToDelete {
            modelContext.delete(entry)
        }
        
        if !entriesToDelete.isEmpty {
            HapticManager.instance.notification(type: .success)
        }
        
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: EmotionEntry.self, configurations: config)
    
    let sampleEntry1 = EmotionEntry(timestamp: .now, emotion: .happiness, intensity: 4, notes: "Bugün harika bir haber aldım!")
    let sampleEntry2 = EmotionEntry(timestamp: Calendar.current.date(byAdding: .day, value: -1, to: .now)!, emotion: .anxiety, intensity: 2, notes: "Yarınki sunum için biraz endişeliyim. Çok çalıştım ama yine de heyecan var.")
    let sampleEntry3 = EmotionEntry(timestamp: Calendar.current.date(byAdding: .day, value: -2, to: .now)!, emotion: .calm, intensity: 5, notes: "Güzel bir yürüyüş yaptım.")
    
    container.mainContext.insert(sampleEntry1)
    container.mainContext.insert(sampleEntry2)
    container.mainContext.insert(sampleEntry3)
    
    return EntriesListView()
        .modelContainer(container)
}
