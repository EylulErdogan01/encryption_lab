import 'package:encryption_lab/encryption_lab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';
import 'widgets.dart';

/// LAB ekranı: serbestçe şifreleme ve şifre çözme.
class CaesarScreen extends StatefulWidget {
  const CaesarScreen({super.key});

  @override
  State<CaesarScreen> createState() => _CaesarScreenState();
}

class _CaesarScreenState extends State<CaesarScreen> {
  final _input = TextEditingController();
  int _key = 3;
  bool _encrypt = true;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  CaesarCipher get _cipher => CaesarCipher(_key);

  String get _result =>
      _encrypt ? _cipher.encrypt(_input.text) : _cipher.decrypt(_input.text);

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _result));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('> çıktı panoya kopyalandı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '// Sezar şifrelemesi: her harf anahtar kadar kaydırılır.',
            style: TextStyle(color: Hacker.dim, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _ModeToggle(
            encrypt: _encrypt,
            onChanged: (value) => setState(() => _encrypt = value),
          ),
          const SizedBox(height: 16),

          // GİRİŞ
          NeonPanel(
            label: 'GİRİŞ',
            child: TextField(
              key: const Key('lab-input'),
              controller: _input,
              minLines: 2,
              maxLines: 5,
              cursorColor: Hacker.green,
              style: const TextStyle(color: Hacker.text, fontSize: 16),
              decoration: InputDecoration(
                prefixText: '> ',
                prefixStyle: const TextStyle(color: Hacker.green),
                hintText: _encrypt
                    ? 'gizli mesajını yaz...'
                    : 'şifreli mesajı yapıştır...',
                hintStyle: const TextStyle(color: Hacker.dim),
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 16),

          // ANAHTAR
          NeonPanel(
            label: 'ANAHTAR',
            color: Hacker.cyan,
            child: Column(
              children: [
                KeyDial(
                  idPrefix: 'lab',
                  value: _key,
                  onChanged: (value) => setState(() => _key = value),
                ),
                Slider(
                  value: _key.toDouble(),
                  min: 0,
                  max: 25,
                  divisions: 25,
                  onChanged: (value) => setState(() => _key = value.round()),
                ),
                if (!_cipher.changesText)
                  const Text(
                    '! 0 anahtarı metni değiştirmez',
                    style: TextStyle(color: Hacker.amber, fontSize: 12),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _AlphabetStrip(
            cipher: _cipher,
            encrypt: _encrypt,
            usedLetters: _input.text.toUpperCase(),
          ),
          const SizedBox(height: 16),

          // ÇIKTI
          NeonPanel(
            label: 'ÇIKTI',
            trailing: IconButton(
              tooltip: 'Kopyala',
              visualDensity: VisualDensity.compact,
              color: Hacker.green,
              onPressed: result.isEmpty ? null : _copy,
              icon: const Icon(Icons.copy, size: 18),
            ),
            child: ScrambleText(
              result.isEmpty ? '...' : result,
              key: const Key('lab-output'),
              style: TextStyle(
                fontSize: 20,
                color: result.isEmpty ? Hacker.dim : Hacker.green,
                shadows: [
                  Shadow(
                    color: Hacker.green.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [ ŞİFRELE ] [ ÇÖZ ] seçimi.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.encrypt, required this.onChanged});

  final bool encrypt;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ModeButton(
            key: const Key('mode-encrypt'),
            label: 'ŞİFRELE',
            icon: Icons.lock,
            selected: encrypt,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ModeButton(
            key: const Key('mode-decrypt'),
            label: 'ÇÖZ',
            icon: Icons.lock_open,
            selected: !encrypt,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Hacker.green : Hacker.dim;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: selected ? Hacker.green : Hacker.border),
    );

    return Material(
      color: selected
          ? Hacker.green.withValues(alpha: 0.15)
          : Colors.transparent,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A'dan Z'ye her harfin neye dönüştüğünü gösteren şerit.
/// Metinde geçen harfler parlar.
class _AlphabetStrip extends StatelessWidget {
  const _AlphabetStrip({
    required this.cipher,
    required this.encrypt,
    required this.usedLetters,
  });

  final CaesarCipher cipher;
  final bool encrypt;
  final String usedLetters;

  static const _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  @override
  Widget build(BuildContext context) {
    final mapped =
        encrypt ? cipher.encrypt(_letters) : cipher.decrypt(_letters);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < _letters.length; i++)
            _LetterTile(
              from: _letters[i],
              to: mapped[i],
              active: usedLetters.contains(_letters[i]),
            ),
        ],
      ),
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({
    required this.from,
    required this.to,
    required this.active,
  });

  final String from;
  final String to;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 34,
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: active ? Hacker.green.withValues(alpha: 0.12) : Hacker.panel,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: active ? Hacker.green : Hacker.border,
        ),
      ),
      child: Column(
        children: [
          Text(
            from,
            style: TextStyle(color: active ? Hacker.text : Hacker.dim),
          ),
          Icon(
            Icons.arrow_downward,
            size: 12,
            color: active ? Hacker.green : Hacker.border,
          ),
          Text(
            to,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? Hacker.green : Hacker.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
