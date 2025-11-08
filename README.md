# Hislerim: SwiftUI & SwiftData Duygu Günlüğü

![Swift](https://img.shields.io/badge/Swift-5.10-orange?style=for-the-badge)
![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue?style=for-the-badge)
![SwiftData](https://img.shields.io/badge/SwiftData-Framework-green?style=for-the-badge)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-purple?style=for-the-badge)

## 📖 Hakkında

**Hislerim**, kullanıcıların günlük duygusal durumlarını, bu duyguların yoğunluğunu ve gün içindeki düşüncelerini kaydetmeleri için tasarlanmış modern, minimalist ve tamamen SwiftUI ile geliştirilmiş bir iOS duygu günlüğü uygulamasıdır.

Bu proje, **SwiftData**'nın gücünü, **Swift Charts** ile modern veri görselleştirmeyi ve **SwiftUI** ile dinamik, etkileşimli arayüzler oluşturmayı gösteren bir portfolyo uygulamasıdır.

## ✨ Temel Özellikler

* **Duygu Kaydı:** Geniş bir emoji ve renk paletinden (Mutlu, Hüzünlü, Sakin, Endişeli vb.) duygu seçimi.
* **Yoğunluk ve Notlar:** Her giriş için 1-5 arası duygu yoğunluğu (modern bir slider ile) ve detaylı not ekleme.
* **Akıllı Liste:** Ana ekranda (`EntriesListView`) tüm girişleri **"Bugün", "Dün"** ve diğer günler olarak otomatik gruplama.
* **Düzenleme ve Silme (CRUD):**
    * `NavigationLink` ile (değer tabanlı navigasyon) mevcut girişleri görüntüleme ve düzenleme.
    * Kaydırarak silme (`onDelete`) fonksiyonu.
* **📊 İstatistikler Sayfası (`StatsView`):**
    * **Swift Charts** kullanılarak oluşturulmuş dinamik grafikler.
    * "Son 7 Gün", "Son 30 Gün" ve "Tüm Zamanlar" için veri filtreleme.
    * **Duygu Dağılımı:** En sık hissedilen duyguları gösteren yatay bir `BarChart`.
    * **Yoğunluk Trendi:** Zaman içindeki duygu yoğunluğu değişimini gösteren bir `LineChart` ve `AreaChart`.
* **Modern Arayüz:**
    * `TabView` ile Günlük ve İstatistikler arasında kolay geçiş.
    * `ContentUnavailableView` (iOS 17+) ile temiz "boş liste" görünümü.
* **Haptics:** Kullanıcı deneyimini zenginleştirmek için duygu seçimi, kaydetme ve silme işlemlerinde dokunsal geri bildirimler.

## 🚀 Kullanılan Teknolojiler

* **SwiftUI:** Tüm kullanıcı arayüzü ve uygulama yaşam döngüsü için.
* **SwiftData:** Verilerin yerel olarak kalıcı hale getirilmesi için (eski CoreData'nın yerini alan modern framework).
* **Swift Charts (iOS 16+):** İstatistikler sayfasındaki tüm veri görselleştirmeleri için.
* **Değer Tabanlı Navigasyon:** `NavigationStack` ve `.navigationDestination(for:)` kullanarak modern ve esnek bir navigasyon akışı.
* **MVVM Mimarisi:** Görünümleri (`View`) ve iş mantığını (`Model`) ayırmak için (ViewModel olarak `View`'in kendisi kullanılmıştır).

## 📱 Ekran Görüntüleri

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-08 at 14 46 23" src="https://github.com/user-attachments/assets/beb91de0-c74b-438f-88e4-d6faead7d978" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-08 at 14 46 30" src="https://github.com/user-attachments/assets/eb54e8e6-41e1-48c5-9ff8-72a9d00c2e5f" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-08 at 14 48 07" src="https://github.com/user-attachments/assets/217ac76a-5f87-40aa-a084-a661163f8392" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-08 at 14 48 11" src="https://github.com/user-attachments/assets/bcdf3bff-418d-4221-a562-e4f0567a0eac" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-08 at 14 48 21" src="https://github.com/user-attachments/assets/b9eda16e-3f13-4076-8ef5-1b3c575b2bb8" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2025-11-08 at 14 48 29" src="https://github.com/user-attachments/assets/b80239c6-690e-452d-8364-16a893f7682f" />


