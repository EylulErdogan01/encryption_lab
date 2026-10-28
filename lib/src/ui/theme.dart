import 'package:flutter/material.dart';

/// Uygulamanın "hacker terminali" renkleri ve teması.
///
/// Tüm renkler burada; bir rengi değiştirmek istersen sadece bu dosyaya
/// dokunman yeterli.
class Hacker {
  Hacker._();

  static const bg = Color(0xFF05080D); // arka plan: neredeyse siyah
  static const panel = Color(0xFF0B1219); // panellerin içi
  static const border = Color(0xFF1C2A36); // sönük kenarlıklar
  static const green = Color(0xFF39FF88); // ana neon yeşil
  static const cyan = Color(0xFF3CD6FF); // ikinci vurgu rengi
  static const amber = Color(0xFFFFC23C); // ele geçirilen mesajlar
  static const red = Color(0xFFFF4D6D); // hata/uyarı
  static const dim = Color(0xFF6B7F8E); // açıklama yazıları
  static const text = Color(0xFFD6E2EA); // normal yazı

  /// Terminal yazı tipi (assets/fonts içinde).
  static const mono = 'JetBrainsMono';

  static ThemeData theme() {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: mono,
      colorScheme: const ColorScheme.dark(
        primary: green,
        onPrimary: bg,
        secondary: cyan,
        onSecondary: bg,
        surface: panel,
        onSurface: text,
        error: red,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: panel,
        indicatorColor: green.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? green : dim,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: mono,
            fontSize: 12,
            letterSpacing: 1.5,
            color: states.contains(WidgetState.selected) ? green : dim,
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: cyan,
        inactiveTrackColor: border,
        thumbColor: cyan,
        overlayColor: cyan.withValues(alpha: 0.15),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: panel,
        contentTextStyle: TextStyle(color: green, fontFamily: mono),
      ),
    );
  }
}
