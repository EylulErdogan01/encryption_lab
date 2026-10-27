import 'package:encryption_lab/encryption_lab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Kullanıcının seçebileceği iki işlem.
enum CipherMode { encrypt, decrypt }

/// Sezar şifrelemesi ekranı.
///
/// Kullanıcı yazdıkça sonuç anında güncellenir; ayrıca bir "Hesapla"
/// butonuna gerek yoktur.
class CaesarScreen extends StatefulWidget {
  const CaesarScreen({super.key});

  @override
  State<CaesarScreen> createState() => _CaesarScreenState();
}

class _CaesarScreenState extends State<CaesarScreen> {
  // Metin kutularının içeriğini tutan kontrolcüler.
  final _textController = TextEditingController();
  final _keyController = TextEditingController(text: '3');

  CipherMode _mode = CipherMode.encrypt;

  @override
  void dispose() {
    // Ekran kapanınca kontrolcüleri temizle (bellek sızıntısını önler).
    _textController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  /// Anahtar kutusundaki sayı. Geçersizse null.
  int? get _key => parseKey(_keyController.text);

  /// Ekranda gösterilecek sonuç. Anahtar geçersizse boş.
  String get _result {
    final key = _key;
    if (key == null) return '';
    final cipher = CaesarCipher(key);
    final text = _textController.text;
    return _mode == CipherMode.encrypt
        ? cipher.encrypt(text)
        : cipher.decrypt(text);
  }

  /// - ve + butonları için: anahtarı [delta] kadar değiştirir.
  void _changeKey(int delta) {
    final next = (_key ?? 0) + delta;
    setState(() => _keyController.text = '$next');
  }

  Future<void> _copyResult() async {
    await Clipboard.setData(ClipboardData(text: _result));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sonuç kopyalandı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = _key;
    final result = _result;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Encryption Lab')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _InfoCard(),
              const SizedBox(height: 16),

              // 1) İşlem seçimi
              SegmentedButton<CipherMode>(
                segments: const [
                  ButtonSegment(
                    value: CipherMode.encrypt,
                    label: Text('Şifrele'),
                    icon: Icon(Icons.lock),
                  ),
                  ButtonSegment(
                    value: CipherMode.decrypt,
                    label: Text('Çöz'),
                    icon: Icon(Icons.lock_open),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) =>
                    setState(() => _mode = selection.first),
              ),
              const SizedBox(height: 16),

              // 2) Metin
              TextField(
                key: const Key('textField'),
                controller: _textController,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: _mode == CipherMode.encrypt
                      ? 'Şifrelenecek metin'
                      : 'Şifreli metin',
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // 3) Anahtar: -  [ 3 ]  +
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Anahtarı azalt',
                    onPressed: () => _changeKey(-1),
                    icon: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      key: const Key('keyField'),
                      controller: _keyController,
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Anahtar',
                        border: const OutlineInputBorder(),
                        errorText:
                            key == null ? 'Bir tam sayı girin (ör. 3, -5)' : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'Anahtarı artır',
                    onPressed: () => _changeKey(1),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

              if (key != null && !CaesarCipher(key).changesText) ...[
                const SizedBox(height: 8),
                Text(
                  '$key anahtarı metni değiştirmez '
                  '(0 veya ${CaesarCipher.alphabetLength} sayısının katı).',
                  style: TextStyle(color: colors.error),
                ),
              ],

              // 4) Harflerin nereye gittiğini gösteren tablo
              if (key != null) ...[
                const SizedBox(height: 16),
                _AlphabetMap(cipher: CaesarCipher(key), mode: _mode),
              ],
              const SizedBox(height: 16),

              // 5) Sonuç
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Sonuç',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Kopyala',
                            onPressed: result.isEmpty ? null : _copyResult,
                            icon: const Icon(Icons.copy),
                          ),
                        ],
                      ),
                      SelectableText(
                        result.isEmpty ? '—' : result,
                        key: const Key('result'),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ekranın üstündeki kısa açıklama.
class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sezar şifrelemesi', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'Her harf alfabede anahtar kadar kaydırılır. Anahtar 3 ise '
              'A → D, B → E olur; Z ise başa dönerek C olur. Şifreyi çözmek '
              'için harfler aynı anahtarla geri kaydırılır.\n\n'
              'Harf olmayan karakterler (boşluk, rakam, noktalama) değişmez. '
              'Şimdilik İngilizce alfabe (A–Z) kullanılıyor.',
            ),
          ],
        ),
      ),
    );
  }
}

/// A'dan Z'ye her harfin neye dönüştüğünü gösteren kaydırılabilir şerit.
class _AlphabetMap extends StatelessWidget {
  const _AlphabetMap({required this.cipher, required this.mode});

  final CaesarCipher cipher;
  final CipherMode mode;

  static const _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final mapped = mode == CipherMode.encrypt
        ? cipher.encrypt(_letters)
        : cipher.decrypt(_letters);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < _letters.length; i++)
            Container(
              width: 32,
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(_letters[i]),
                  Icon(Icons.arrow_downward, size: 14, color: colors.outline),
                  Text(
                    mapped[i],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
