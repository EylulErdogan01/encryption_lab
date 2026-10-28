import 'package:flutter/material.dart';

import 'src/ui/home_shell.dart';
import 'src/ui/theme.dart';

/// Uygulamanın başladığı yer.
void main() => runApp(const EncryptionLabApp());

/// Uygulamanın kendisi: temayı ve açılış ekranını belirler.
class EncryptionLabApp extends StatelessWidget {
  const EncryptionLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encryption Lab',
      debugShowCheckedModeBanner: false,
      theme: Hacker.theme(),
      home: const HomeShell(),
    );
  }
}
