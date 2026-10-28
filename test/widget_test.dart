import 'package:encryption_lab/main.dart';
import 'package:encryption_lab/src/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Not: Başlıktaki imleç sürekli yanıp söndüğü için pumpAndSettle()
// hiç bitmez. Onun yerine pump() ile ekranı belli bir süre ilerletiyoruz.

/// Bir ScrambleText'in animasyon bitince göstereceği yazı.
String outputOf(WidgetTester tester, String key) =>
    tester.widget<ScrambleText>(find.byKey(Key(key))).text;

/// Anahtar kadranında görünen sayı.
String keyValueOf(WidgetTester tester, String prefix) =>
    tester.widget<Text>(find.byKey(Key('$prefix-key-value'))).data!;

void main() {
  group('LAB', () {
    testWidgets('yazılan metni anahtar 3 ile şifreler', (tester) async {
      await tester.pumpWidget(const EncryptionLabApp());

      await tester.enterText(find.byKey(const Key('lab-input')), 'Hello');
      await tester.pump();

      expect(outputOf(tester, 'lab-output'), 'Khoor');
    });

    testWidgets('ÇÖZ seçilince şifreyi çözer', (tester) async {
      await tester.pumpWidget(const EncryptionLabApp());

      await tester.tap(find.byKey(const Key('mode-decrypt')));
      await tester.enterText(find.byKey(const Key('lab-input')), 'Khoor');
      await tester.pump();

      expect(outputOf(tester, 'lab-output'), 'Hello');
    });

    testWidgets('oklar anahtarı değiştirir, 0 dan geri gidince 25 olur',
        (tester) async {
      await tester.pumpWidget(const EncryptionLabApp());
      await tester.enterText(find.byKey(const Key('lab-input')), 'a');

      await tester.tap(find.byKey(const Key('lab-key-up')));
      await tester.pump();
      expect(keyValueOf(tester, 'lab'), '04');
      expect(outputOf(tester, 'lab-output'), 'e');

      for (var i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const Key('lab-key-down')));
        await tester.pump();
      }
      expect(keyValueOf(tester, 'lab'), '25');
      expect(outputOf(tester, 'lab-output'), 'z');
    });
  });

  group('GÖREVLER', () {
    testWidgets('doğru anahtar bulununca erişim sağlanır', (tester) async {
      await tester.pumpWidget(const EncryptionLabApp());

      await tester.tap(find.byKey(const Key('tab-missions')));
      await tester.pump();
      expect(find.text('ERİŞİM SAĞLANDI'), findsNothing);

      // 1. görevin anahtarı 3: üç kez artır.
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('mission-key-up')));
        await tester.pump();
      }

      expect(outputOf(tester, 'mission-output'), 'HELLO WORLD');
      expect(find.text('ERİŞİM SAĞLANDI'), findsOneWidget);
      expect(find.text('Anahtar 3, 3 denemede bulundu.'), findsOneWidget);
    });

    testWidgets('sonraki göreve geçince sayaçlar sıfırlanır', (tester) async {
      await tester.pumpWidget(const EncryptionLabApp());
      await tester.tap(find.byKey(const Key('tab-missions')));
      await tester.pump();

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('mission-key-up')));
        await tester.pump();
      }
      await tester.ensureVisible(find.byKey(const Key('mission-next')));
      await tester.tap(find.byKey(const Key('mission-next')));
      await tester.pump();

      expect(find.textContaining('GÖREV 2/'), findsOneWidget);
      expect(keyValueOf(tester, 'mission'), '00');
      expect(find.text('DENEME: 0'), findsOneWidget);
    });
  });
}
