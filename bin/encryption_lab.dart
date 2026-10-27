import 'dart:io';

import 'package:encryption_lab/encryption_lab.dart';

void main() {
  print('=== Encryption Lab v0.1 ===');
  print('Sezar şifrelemesi');

  while (true) {
    print('');
    print('1) Şifrele');
    print('2) Şifre çöz');
    print('0) Çıkış');
    stdout.write('Seçiminiz: ');
    final choice = stdin.readLineSync()?.trim();

    // Ctrl+D / Ctrl+Z ile giriş kapanırsa (null) programı düzgünce bitir.
    if (choice == null || choice == '0') {
      print('Görüşmek üzere!');
      break;
    }

    if (choice != '1' && choice != '2') {
      print('Geçersiz seçim, lütfen 1, 2 veya 0 girin.');
      continue;
    }

    final text = askText();
    final key = askKey();
    final cipher = CaesarCipher(key);

    if (!cipher.changesText) {
      print('Uyarı: $key anahtarı metni değiştirmez '
          '(0 veya ${CaesarCipher.alphabetLength} sayısının katı).');
    }

    final result = choice == '1' ? cipher.encrypt(text) : cipher.decrypt(text);

    print('Sonuç: $result');
  }
}

/// Boş olmayan bir metin girilene kadar sorar.
String askText() {
  while (true) {
    stdout.write('Metin: ');
    final input = stdin.readLineSync();
    if (input == null) exit(0);
    if (!isBlank(input)) return input;
    print('Metin boş olamaz, lütfen bir şey yazın.');
  }
}

/// Geçerli bir tam sayı girilene kadar anahtarı sorar.
int askKey() {
  while (true) {
    stdout.write('Anahtar (tam sayı): ');
    final input = stdin.readLineSync();
    if (input == null) exit(0);
    final key = parseKey(input);
    if (key != null) return key;
    print('Geçersiz anahtar. Örnek: 3, 13 veya -5');
  }
}
