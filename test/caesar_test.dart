import 'package:encryption_lab/encryption_lab.dart';
import 'package:test/test.dart';

void main() {
  group('Sezar - şifreleme', () {
    test('MERHABA, anahtar 3 -> PHUKDED', () {
      expect(const CaesarCipher(3).encrypt('MERHABA'), 'PHUKDED');
    });

    test('alfabenin sonunda başa döner (XYZ -> ABC)', () {
      expect(const CaesarCipher(3).encrypt('XYZ'), 'ABC');
    });

    test('küçük/büyük harf korunur', () {
      expect(const CaesarCipher(3).encrypt('Hello, World!'), 'Khoor, Zruog!');
    });

    test('rakam, boşluk ve noktalama değişmez', () {
      expect(const CaesarCipher(5).encrypt('2026 - ok?'), '2026 - tp?');
    });

    test('A-Z dışındaki harfler (Türkçe karakterler) değişmez', () {
      expect(const CaesarCipher(1).encrypt('Çay şöyle'), 'Çbz şözmf');
    });

    test('emoji bozulmaz', () {
      expect(const CaesarCipher(1).encrypt('abc 🔐'), 'bcd 🔐');
    });

    test('boş metin boş kalır', () {
      expect(const CaesarCipher(7).encrypt(''), '');
    });

    test('ROT13 örneği', () {
      expect(const CaesarCipher(13).encrypt('Hello'), 'Uryyb');
    });
  });

  group('Sezar - şifre çözme', () {
    test('PHUKDED, anahtar 3 -> MERHABA', () {
      expect(const CaesarCipher(3).decrypt('PHUKDED'), 'MERHABA');
    });

    test('ABC, anahtar 3 -> XYZ', () {
      expect(const CaesarCipher(3).decrypt('ABC'), 'XYZ');
    });

    test('şifrele + çöz = orijinal metin (-100..100 arası tüm anahtarlar)', () {
      const text = 'The quick brown fox jumps over the lazy dog! 123 Çğış';
      for (var key = -100; key <= 100; key++) {
        final cipher = CaesarCipher(key);
        expect(cipher.decrypt(cipher.encrypt(text)), text, reason: 'key=$key');
      }
    });
  });

  group('Sezar - anahtar', () {
    test('29 ile 3 aynı sonucu verir', () {
      expect(const CaesarCipher(29).encrypt('Abc'),
          const CaesarCipher(3).encrypt('Abc'));
    });

    test('negatif anahtar geri kaydırır (-3 ile şifrelemek = 3 ile çözmek)', () {
      expect(const CaesarCipher(-3).encrypt('MERHABA'),
          const CaesarCipher(3).decrypt('MERHABA'));
    });

    test('çok büyük anahtar çalışır', () {
      // 1 000 000 % 26 == 14
      expect(const CaesarCipher(1000000).encrypt('abc'), 'opq');
    });

    test('normalizedKey her zaman 0..25 aralığındadır', () {
      expect(const CaesarCipher(3).normalizedKey, 3);
      expect(const CaesarCipher(29).normalizedKey, 3);
      expect(const CaesarCipher(-3).normalizedKey, 23);
      expect(const CaesarCipher(-26).normalizedKey, 0);
    });

    test('0 ve 26 nın katları metni değiştirmez', () {
      for (final key in [0, 26, 52, -26]) {
        final cipher = CaesarCipher(key);
        expect(cipher.changesText, isFalse, reason: 'key=$key');
        expect(cipher.encrypt('Merhaba'), 'Merhaba', reason: 'key=$key');
      }
      expect(const CaesarCipher(1).changesText, isTrue);
    });
  });
}
