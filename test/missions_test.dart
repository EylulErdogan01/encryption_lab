import 'package:encryption_lab/encryption_lab.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('en az bir görev var', () {
    expect(missions, isNotEmpty);
  });

  for (final mission in missions) {
    group('Görev "${mission.title}"', () {
      test('şifreli mesaj, açık mesajdan farklı', () {
        expect(mission.cipherText, isNot(mission.plainText));
      });

      test('sadece doğru anahtar (0..25 içinde) çözer', () {
        final solvers = [
          for (var guess = 0; guess < 26; guess++)
            if (mission.isSolvedBy(guess)) guess,
        ];
        expect(solvers, [mission.key % 26]);
      });

      test('26 fazlası da aynı anahtardır', () {
        expect(mission.isSolvedBy(mission.key + 26), isTrue);
      });
    });
  }

  test('ilk görev: HELLO WORLD, anahtar 3 -> KHOOR ZRUOG', () {
    expect(missions.first.cipherText, 'KHOOR ZRUOG');
  });
}
