import 'package:encryption_lab/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Sonuç kutusunda yazan metni okur.
String resultText(WidgetTester tester) =>
    tester.widget<SelectableText>(find.byKey(const Key('result'))).data!;

void main() {
  testWidgets('açılışta anahtar 3 ve boş sonuç', (tester) async {
    await tester.pumpWidget(const EncryptionLabApp());

    expect(find.text('3'), findsWidgets);
    expect(resultText(tester), '—');
  });

  testWidgets('yazılan metni anında şifreler', (tester) async {
    await tester.pumpWidget(const EncryptionLabApp());

    await tester.enterText(find.byKey(const Key('textField')), 'Hello');
    await tester.pump();

    expect(resultText(tester), 'Khoor');
  });

  testWidgets('Çöz seçilince şifreyi çözer', (tester) async {
    await tester.pumpWidget(const EncryptionLabApp());

    await tester.tap(find.text('Çöz'));
    await tester.enterText(find.byKey(const Key('textField')), 'Khoor');
    await tester.pump();

    expect(resultText(tester), 'Hello');
  });

  testWidgets('+ butonu anahtarı bir artırır', (tester) async {
    await tester.pumpWidget(const EncryptionLabApp());

    await tester.enterText(find.byKey(const Key('textField')), 'a');
    await tester.tap(find.byTooltip('Anahtarı artır'));
    await tester.pump();

    expect(resultText(tester), 'e'); // a + 4 = e
  });

  testWidgets('geçersiz anahtarda uyarı gösterir', (tester) async {
    await tester.pumpWidget(const EncryptionLabApp());

    await tester.enterText(find.byKey(const Key('keyField')), 'abc');
    await tester.pump();

    expect(find.text('Bir tam sayı girin (ör. 3, -5)'), findsOneWidget);
    expect(resultText(tester), '—');
  });
}
