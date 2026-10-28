import 'ciphers/caesar.dart';

/// Oyundaki bir görev: anahtarı bilinmeyen, ele geçirilmiş bir mesaj.
///
/// Şifreli metin elle yazılmaz; [plainText] ve [key] ile her seferinde
/// hesaplanır. Böylece yanlış yazılmış bir görev olamaz.
class Mission {
  const Mission({
    required this.title,
    required this.briefing,
    required this.plainText,
    required this.key,
    required this.hint,
  });

  final String title;
  final String briefing;
  final String plainText;

  /// Oyuncunun bulması gereken gizli anahtar.
  final int key;
  final String hint;

  /// Oyuncuya gösterilen şifreli mesaj.
  String get cipherText => CaesarCipher(key).encrypt(plainText);

  /// [guess] anahtarıyla çözülmeye çalışılınca ortaya çıkan metin.
  String decryptWith(int guess) => CaesarCipher(guess).decrypt(cipherText);

  /// Tahmin doğru mu? (29 ile 3 aynı olduğu için mod 26 eşitliği yeterli.)
  bool isSolvedBy(int guess) => decryptWith(guess) == plainText;
}

/// Kolaydan zora sıralı görevler.
const missions = <Mission>[
  Mission(
    title: 'Isınma',
    briefing: 'İlk mesajı yakaladık. Basit bir kaydırma kullanılmış.',
    plainText: 'HELLO WORLD',
    key: 3,
    hint: 'Anahtar 1 ile 5 arasında.',
  ),
  Mission(
    title: 'Gece Operasyonu',
    briefing: 'Bir saldırı planlanıyor. Mesajı çöz, zamanı öğren.',
    plainText: 'ATTACK AT DAWN',
    key: 7,
    hint: "Anahtar 10'dan küçük.",
  ),
  Mission(
    title: 'Yarım Tur',
    briefing: 'Gizli bir arşivin yerini anlatan bir mesaj bu.',
    plainText: 'GIZLI ARSIV BULUNDU',
    key: 13,
    hint: 'Bu anahtar alfabenin tam yarısı.',
  ),
  Mission(
    title: 'Kör Nokta',
    briefing: 'Bu sefer elimizde hiçbir bilgi yok.',
    plainText: 'SIFRE KIRILDI',
    key: 19,
    hint: 'İpucu yok. Ama sadece 26 ihtimal var...',
  ),
  Mission(
    title: 'Son Kale',
    briefing: 'Son sistem. Kırarsan ağın tamamı senin.',
    plainText: 'BRUTE FORCE KAZANIR',
    key: 24,
    hint: "Geriye doğru dene: 0'dan aşağı inince 25'e geçersin.",
  ),
];
