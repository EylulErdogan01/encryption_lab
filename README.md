# Encryption Lab 🔐

Şifreleme algoritmalarını basitçe anlatan ve denemeyi sağlayan bir uygulama.
Sürüm sürüm geliştiriliyor; hedef, Flutter ile Android (Google Play) uygulaması.

## Durum

| Sürüm | İçerik | Durum |
|-------|--------|-------|
| v0.1 | Sezar şifrelemesi (terminal) | ✅ Tamamlandı |
| v0.2 | Türkçe alfabe desteği | Planlandı |
| v1.0 | Flutter arayüzü, Android | Planlandı |
| sonra | Vigenère ve diğer algoritmalar | Planlandı |

## Sezar şifrelemesi nasıl çalışır?

Her harf alfabede sabit bir sayı (anahtar) kadar kaydırılır.

```
Anahtar 3:  A B C ... X Y Z
            ↓ ↓ ↓     ↓ ↓ ↓
            D E F ... A B C

MERHABA  →  PHUKDED
```

- Şifreleme: `yeni = (eski + anahtar) mod 26`
- Çözme: `eski = (yeni − anahtar) mod 26`

Harf olmayan karakterler (boşluk, rakam, noktalama) değişmez.

## Proje yapısı

```
bin/
  encryption_lab.dart        # Terminal menüsü (programın giriş noktası)
lib/
  encryption_lab.dart        # Kütüphanenin dışa açılan kısmı
  src/ciphers/caesar.dart    # Sezar algoritması (arayüzden bağımsız)
  src/input.dart             # Giriş kontrolü
test/
  caesar_test.dart           # Algoritma testleri
  input_test.dart            # Giriş kontrolü testleri
```

Algoritmalar arayüzden bağımsız saf Dart kodudur. Böylece aynı kod hem
terminal sürümünde hem Flutter uygulamasında kullanılır.

## Çalıştırma

[Dart SDK](https://dart.dev/get-dart) veya [Flutter](https://docs.flutter.dev/get-started/install) kurulu olmalı.

```bash
dart pub get                       # bağımlılıkları indir
dart run                           # uygulamayı başlat
dart test                          # testleri çalıştır
```

Örnek kullanım:

```
=== Encryption Lab v0.1 ===
Sezar şifrelemesi

1) Şifrele
2) Şifre çöz
0) Çıkış
Seçiminiz: 1
Metin: Merhaba Dunya
Anahtar (tam sayı): 3
Sonuç: Phukded Gxqbd
```
