import 'dart:math';

import 'package:encryption_lab/encryption_lab.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

/// Kenarları hafifçe parlayan, üstünde `[ ETİKET ]` yazan terminal paneli.
class NeonPanel extends StatelessWidget {
  const NeonPanel({
    super.key,
    required this.label,
    required this.child,
    this.color = Hacker.green,
    this.trailing,
  });

  final String label;
  final Widget child;
  final Color color;

  /// Etiketin sağına konacak isteğe bağlı parça (ör. kopyala butonu).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: Hacker.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 18),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 32,
            child: Row(
              children: [
                Text(
                  '[ $label ]',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

/// Yazı değiştiğinde harfleri önce rastgele karakterlerle gösterip
/// soldan sağa doğru gerçek hâline "çözen" yazı.
class ScrambleText extends StatefulWidget {
  const ScrambleText(this.text, {super.key, this.style});

  /// Animasyon bitince görünecek asıl yazı.
  final String text;
  final TextStyle? style;

  @override
  State<ScrambleText> createState() => _ScrambleTextState();
}

class _ScrambleTextState extends State<ScrambleText>
    with SingleTickerProviderStateMixin {
  static const _glyphs = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#@\$%&*<>/';
  final _random = Random();

  // value: 1 -> açılışta animasyon yok, yazı doğrudan görünür.
  late final AnimationController _controller =
      AnimationController(vsync: this, value: 1);

  @override
  void didUpdateWidget(covariant ScrambleText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      final ms = (150 + widget.text.length * 15).clamp(150, 700);
      _controller.duration = Duration(milliseconds: ms);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Emoji gibi çok parçalı karakterler bölünmesin diye runes kullanıyoruz.
        final chars = widget.text.runes.map(String.fromCharCode).toList();
        final revealed = (_controller.value * chars.length).floor();
        final buffer = StringBuffer();
        for (var i = 0; i < chars.length; i++) {
          final c = chars[i];
          if (i < revealed || c.trim().isEmpty) {
            buffer.write(c);
          } else {
            buffer.write(_glyphs[_random.nextInt(_glyphs.length)]);
          }
        }
        return Text(
          buffer.toString(),
          style: widget.style,
          semanticsLabel: widget.text,
        );
      },
    );
  }
}

/// `◀  03  ▶` şeklinde anahtar seçici. Değer 0 ile 25 arasında döner.
class KeyDial extends StatelessWidget {
  const KeyDial({
    super.key,
    required this.value,
    required this.onChanged,
    required this.idPrefix,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<int> onChanged;

  /// Testlerin butonları bulabilmesi için: 'lab' -> Key('lab-key-up').
  final String idPrefix;
  final bool enabled;

  int _wrap(int v) => v % CaesarCipher.alphabetLength;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = IconButton.styleFrom(
      foregroundColor: Hacker.green,
      disabledForegroundColor: Hacker.border,
      side: BorderSide(color: Hacker.green.withValues(alpha: 0.5)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          key: Key('$idPrefix-key-down'),
          tooltip: 'Anahtarı azalt',
          style: buttonStyle,
          iconSize: 32,
          onPressed: enabled ? () => onChanged(_wrap(value - 1)) : null,
          icon: const Icon(Icons.chevron_left),
        ),
        const SizedBox(width: 24),
        Column(
          children: [
            const Text(
              'ANAHTAR',
              style: TextStyle(
                color: Hacker.dim,
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
            Text(
              value.toString().padLeft(2, '0'),
              key: Key('$idPrefix-key-value'),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Hacker.green,
                shadows: [
                  Shadow(
                    color: Hacker.green.withValues(alpha: 0.6),
                    blurRadius: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        IconButton(
          key: Key('$idPrefix-key-up'),
          tooltip: 'Anahtarı artır',
          style: buttonStyle,
          iconSize: 32,
          onPressed: enabled ? () => onChanged(_wrap(value + 1)) : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

/// Başlıktaki yanıp sönen terminal imleci: █
class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Text('█', style: TextStyle(color: Hacker.green)),
    );
  }
}
