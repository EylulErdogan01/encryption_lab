# Yol Haritası

Encryption Lab adım adım geliştiriliyor. Her sürüm küçük, tek başına çalışan
ve test edilmiş bir adım. Sıra: önce cilala, sonra yeni algoritmalar ekle,
en son Play Store'a çık.

## ✅ Tamamlananlar

| Sürüm | İçerik |
|-------|--------|
| v0.1 | Sezar şifrelemesi, terminal menüsü, hatalı giriş kontrolü |
| v0.2 | Flutter arayüzü, GitHub Actions ile otomatik APK |
| v0.3 | Hacker teması, GÖREVLER oyunu (5 görev), 43 test |

---

## 1. Aşama: Cilalama (v0.3.x)

Yeni özellik yok; var olanı daha iyi göstermek.

- [ ] **Release sayfası:** GitHub'da indirilebilir APK'lı "v0.3.0" sürümü
- [ ] **ÇIKTI paneli yukarı:** Sonuç, giriş kutusunun hemen altında görünsün; telefonda kaydırmaya gerek kalmasın
- [ ] **Uygulama simgesi:** Varsayılan Flutter simgesi yerine temaya uygun simge
- [ ] **Web demosu:** GitHub Pages'te "Tarayıcıda dene" bağlantısı; README'ye eklenecek

**Öğreneceklerin:** Git etiketleri (tag), GitHub Releases, GitHub Pages

## 2. Aşama: Türkçe alfabe (v0.4)

- [ ] Alfabeyi koddan ayır: İngilizce (26 harf) ve Türkçe (29 harf) seçilebilsin
- [ ] LAB'da alfabe seçici
- [ ] Türkçe'ye özel durumlar: `i/İ` ve `ı/I` büyük-küçük harf dönüşümleri
- [ ] Türkçe mesajlı yeni görevler
- [ ] Testler: iki alfabe için şifrele + çöz = orijinal metin

**Öğreneceklerin:** Kodu genelleştirmek (aynı algoritma, farklı veri), Unicode

## 3. Aşama: Vigenère şifrelemesi (v0.5)

- [ ] Vigenère algoritması ve testleri (anahtar bir kelime: `LIMON`)
- [ ] LAB'da algoritma seçici: Sezar / Vigenère
- [ ] Her harfin hangi anahtar harfiyle kaydırıldığını gösteren görselleştirme
- [ ] Yeni görev serisi: anahtar kelimeyi bul
- [ ] "Neden daha güçlü?" açıklaması: 26 ihtimal → 26⁵ = 11,8 milyon ihtimal

**Öğreneceklerin:** Döngü içinde değişen anahtar, olasılık hesabı

## 4. Aşama: Öğrenme ve oyun (v0.6)

- [ ] **İlerleme kaydı:** Uygulama kapanınca tamamlanan görevler unutulmasın
- [ ] **Frekans analizi aracı:** Harflerin ne sıklıkta geçtiğini gösteren grafik; Sezar'ı tahmin etmeden kırmak
- [ ] **"Nasıl çalışır?" modu:** Şifrelemeyi harf harf, adım adım oynatan animasyon
- [ ] Daha fazla görev ve zorluk seviyeleri

**Öğreneceklerin:** Veri saklama (`shared_preferences`), grafik çizimi, kriptanaliz

## 5. Aşama: Google Play (v1.0)

Hazırlık (kod):
- [ ] İmza anahtarı (keystore): **asla depoya girmez**, GitHub Secrets'ta durur
- [ ] Actions'ın imzalı AAB dosyası üretmesi
- [ ] Gizlilik politikası sayfası (uygulama veri toplamıyor)
- [ ] Mağaza metinleri ve ekran görüntüleri

Hesap ve yayın:
- [ ] Play Console hesabı: 25 $, kimlik doğrulaması, Android telefonla cihaz doğrulaması
- [ ] Kapalı test: **12 test kullanıcısı, 14 gün kesintisiz**
- [ ] Üretime başvuru ve yayın 🎉

## Sonra (fikirler)

- Diğer klasik şifreler: Atbash, Rail Fence, Yer Değiştirme (Substitution)
- Modern kavramlar: XOR, hash (SHA-256), AES'in mantığı
- iOS / App Store sürümü
- İngilizce dil desteği
