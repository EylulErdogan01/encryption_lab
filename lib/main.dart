import 'package:flutter/material.dart';

import 'src/ui/caesar_screen.dart';

/// Uygulamanın başladığı yer.
void main() => runApp(const EncryptionLabApp());

/// Uygulamanın kendisi: renkleri, başlığı ve açılış ekranını belirler.
class EncryptionLabApp extends StatelessWidget {
  const EncryptionLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encryption Lab',
      debugShowCheckedModeBanner: false,
      // Telefon açık temadaysa açık, koyu temadaysa koyu renkler kullanılır.
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const CaesarScreen(),
    );
  }
}
