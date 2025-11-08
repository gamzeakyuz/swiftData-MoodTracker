//
//  AddEntryView.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 5.11.2025.
//

import SwiftUI
import SwiftData

struct AddEntryView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var selectedEmotion: Emotion = .happiness
    @State private var timestamp: Date = .now
    @State private var intensity: Double = 3.0
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Nasıl Hissediyorsun")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(Emotion.allCases, id: \.self) { emotion in
                                    emotionButton(for: emotion)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Duygu Yoğunluğunuz?")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .center) {
                            Slider(value: $intensity, in: 1...5, step: 1)
                            // Yeni 'color' değerlerini otomatik alacak
                                .tint(selectedEmotion.color)
                                .padding(.horizontal)
                            
                            Text("Yoğunluk: \(Int(intensity)) / 5")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Neden Böyle Hissediyorsun?")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        TextEditor(text: $notes)
                            .frame(minHeight: 120, maxHeight: 200)
                            .overlay(alignment: .topLeading) {
                                if notes.isEmpty {
                                    Text("Akılından neler geçiyor? Bugün seni etkileyen neydi?")
                                        .foregroundStyle(.gray.opacity(0.6))
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                        .allowsTightening(false)
                                }
                            }
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tarih ve Saat")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        DatePicker("Zaman", selection: $timestamp, in: ...Date.now)
                            .datePickerStyle(.graphical)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
                    
                    Spacer().frame(height: 50)
                }
                .padding(.top)
            }
            .navigationTitle("Yeni Kayıt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        saveEntry()
                        dismiss()
                    }
                    .disabled(notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? false : false)
                    .font(.title2)
                    .foregroundStyle(selectedEmotion.color)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                
            }
            .background(Color(.systemBackground))
        }
    }
    
    @ViewBuilder
    private func emotionButton(for emotion: Emotion) -> some View {
        Button {
            selectedEmotion = emotion
        } label: {
            VStack {
                Text(emotion.emoji)
                    .font(.title)
                    .foregroundStyle(selectedEmotion == emotion ? .white : emotion.color)
                    .frame(width: 50, height: 50)
                    .background(selectedEmotion == emotion ? emotion.color : Color(.systemGray6))
                    .clipShape(Circle())
                
                Text(emotion.label)
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain)
    }
    
    private func saveEntry() {
        
        let newEntry = EmotionEntry(timestamp: timestamp, emotion: selectedEmotion, intensity: Int(intensity), notes: notes)
        modelContext.insert(newEntry)
        
        do {
            try modelContext.save()
            print("Anı kaydeldi")
            dismiss()
        } catch {
            print("Veri kaydedilemedi: \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: EmotionEntry.self, configurations: config)

    AddEntryView()
        .modelContainer(container)
}
