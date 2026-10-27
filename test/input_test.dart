import 'package:encryption_lab/encryption_lab.dart';
import 'package:test/test.dart';

void main() {
  group('parseKey', () {
    test('geçerli sayılar', () {
      expect(parseKey('3'), 3);
      expect(parseKey('-5'), -5);
      expect(parseKey('0'), 0);
      expect(parseKey('1000000'), 1000000);
    });

    test('baştaki ve sondaki boşluklar yok sayılır', () {
      expect(parseKey(' 3 '), 3);
      expect(parseKey('3\t'), 3);
    });

    test('geçersiz girişler null döner', () {
      for (final input in ['', '   ', 'abc', '3.5', '3a', 'üç', '1 2']) {
        expect(parseKey(input), isNull, reason: 'giriş: "$input"');
      }
      expect(parseKey(null), isNull);
    });
  });

  group('isBlank', () {
    test('boş ve yalnızca boşluk içeren metinler', () {
      expect(isBlank(null), isTrue);
      expect(isBlank(''), isTrue);
      expect(isBlank('   '), isTrue);
    });

    test('dolu metinler', () {
      expect(isBlank('a'), isFalse);
      expect(isBlank('  merhaba  '), isFalse);
    });
  });
}
