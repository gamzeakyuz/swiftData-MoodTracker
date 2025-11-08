//
//  StatusView.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 5.11.2025.
//

import SwiftUI
import SwiftData
import Charts


struct EmotionCount: Identifiable, Equatable {
    let emotion: Emotion
    let count: Int
    var id: Emotion { emotion }
}

struct StatusView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \EmotionEntry.timestamp, order: .reverse) private var allEntries: [EmotionEntry]
    
    @State private var selectedDateFilter: DateFilter = .last30Days
    
    private var filteredEntries: [EmotionEntry] {
        if let startDate = selectedDateFilter.startDate {
            return allEntries.filter { $0.timestamp >= startDate }
        } else {
            return allEntries
        }
    }
    
    private var emotionCount: [EmotionCount] {
        let counts = Dictionary(grouping: filteredEntries) {  $0.emotion }
            .mapValues { $0.count }
        
        return counts.map { emotion, count in
            EmotionCount(emotion: emotion, count: count)
        }.sorted { $0.count > $1.count }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3),Color.purple.opacity(0.3),Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    if allEntries.isEmpty {
                        
                        ContentUnavailableView("İstatik Yok",
                                               systemImage: "chart.bar.xaxis",
                                               description: Text("Grafikleri görmek için önce bir kaç duygu girişi eklemelisiniz."))
                        .padding(.top, 50)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.horizontal)
                        
                    } else {
                        
                        VStack(spacing: 30) {
                            
                            Picker("Zaman Aralığı", selection: $selectedDateFilter) {
                                ForEach(DateFilter.allCases) { filter in
                                    Text(filter.rawValue).tag(filter)
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: selectedDateFilter) { _, _ in
                                HapticManager.instance.impact(style: .light)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .padding(.horizontal)

                            ChartContainer(title: "Duygu Dağılımı") {
                                EmotionDistributionChart(counts: emotionCount)
                            }
                             
                            ChartContainer(title: "Yoğunluk Trendi") {
                                IntensityTrendChart(entries: filteredEntries)
                            }
                            
                            #if DEBUG
                            Button(role: .destructive) {
                                deleteAllEntries()
                            } label: {
                                Label("Tüm Verileri Sil", systemImage: "trash.fill")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            .padding(.top,20)
                            #endif
                            
                        }
                        .padding(.vertical)
                        .padding(.bottom, 100)
                    }
                }
                
            }
            .navigationTitle("İstatikler")
            .background(Color(.systemGroupedBackground))
        }
    }
    private func deleteAllEntries(){
        do {
            try modelContext.delete(model: EmotionEntry.self)
            HapticManager.instance.notification(type: .success)
        } catch{
            print("Verileri silerken hata oluştu: \(error.localizedDescription)")
            HapticManager.instance.notification(type: .error)
        }
    }
}

struct ChartContainer<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.primary)
                .padding(.horizontal)
            
            content
        }
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct EmotionDistributionChart: View {
    let counts: [EmotionCount]
    
    var body: some View {
        if counts.isEmpty {
            Text("Bu zaman aralığında veri yok.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
        } else {
            Chart(counts) { item in
                BarMark(
                    x: .value("Miktar", item.count),
                    y: .value("Duygu", item.emotion.label)
                )
                .cornerRadius(5)
                .foregroundStyle(item.emotion.color.gradient)
                .annotation(position: .trailing, alignment: .leading) {
                    Text("\(item.count)")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                    AxisGridLine().foregroundStyle(.clear)
                    AxisTick().foregroundStyle(.clear)
                }
            }
            .chartXAxis(.hidden)
            .animation(.easeInOut(duration: 0.5), value: counts)
            .frame(height: CGFloat(counts.count) * 40.0 + 40.0)
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
}

struct IntensityTrendChart: View {
    let entries: [EmotionEntry]
    
    private var averageIntensity: Double {
        if entries.isEmpty { return 0 }
        let totalIntensity = entries.reduce(0.0) { $0 + Double($1.intensity) }
        return totalIntensity / Double(entries.count)
    }
    
    var body: some View {
        if entries.isEmpty {
            Text("Bu zaman aralığında veri yok.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 250, alignment: .center)
        } else {
            Chart(entries) { entry in
                RuleMark(y: .value("Ortalama", averageIntensity))
                    .foregroundStyle(Color.accentColor.opacity(0.8))
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [5, 5]))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Ort: \(averageIntensity, specifier: "%.1f")")
                            .font(.caption.bold())
                            .foregroundStyle(Color.accentColor)
                            .padding(4)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                AreaMark(
                    x: .value("Tarih", entry.timestamp, unit: .day),
                    y: .value("Yoğunluk", entry.intensity)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.accentColor.opacity(0.6), .clear]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(
                    x: .value("Tarih", entry.timestamp, unit: .day),
                    y: .value("Yoğunluk", entry.intensity)
                )
                .foregroundStyle(Color.accentColor)
                .interpolationMethod(.catmullRom)
                
                PointMark(
                    x: .value("Tarih", entry.timestamp, unit: .day),
                    y: .value("Yoğunluk", entry.intensity)
                )
                .foregroundStyle(Color.accentColor)
                .annotation(position: .top) {
                    Text("\(entry.intensity)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .opacity(entries.count < 15 ? 1 : 0)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: entries)
            .chartYScale(domain: 0.5...5.5)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                }
            }
            .chartYAxis {
                AxisMarks(values: [1, 2, 3, 4, 5]) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .frame(height: 250)
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
}

#Preview("StatusView") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: EmotionEntry.self, configurations: config)
    
    let now = Date.now
    for i in 0..<20 {
        let timestamp = Calendar.current.date(byAdding: .day, value: -i, to: now)!
        let randomEmotion = Emotion.allCases.randomElement()!
        let randomIntensity = Int.random(in: 1...5)
        let entry = EmotionEntry(timestamp: timestamp, emotion: randomEmotion, intensity: randomIntensity, notes: "Bu bir örnek not.")
        container.mainContext.insert(entry)
    }

    return StatusView()
        .modelContainer(container)
}
