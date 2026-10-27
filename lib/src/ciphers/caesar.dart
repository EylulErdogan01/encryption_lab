/// Sezar şifrelemesi (Caesar cipher).
///
/// Her harf, İngilizce alfabede (A-Z, 26 harf) [key] kadar ileri kaydırılır.
///
///   Şifreleme: yeni = (eski + anahtar) mod 26
///   Çözme:     eski = (yeni - anahtar) mod 26
///
/// Kurallar:
/// - Büyük harf büyük, küçük harf küçük kalır.
/// - A-Z dışındaki her karakter (boşluk, rakam, noktalama, ç/ğ/ş gibi
///   Türkçe harfler, emoji) olduğu gibi bırakılır.
/// - Anahtar herhangi bir tam sayı olabilir; negatif anahtar geri kaydırır,
///   büyük anahtarlar mod 26 ile küçültülür (29 ile 3 aynı sonucu verir).
class CaesarCipher {
  /// Kullanılan alfabedeki harf sayısı.
  static const int alphabetLength = 26;

  static const int _upperA = 0x41; // 'A'
  static const int _upperZ = 0x5A; // 'Z'
  static const int _lowerA = 0x61; // 'a'
  static const int _lowerZ = 0x7A; // 'z'

  /// Kullanıcının girdiği ham anahtar.
  final int key;

  const CaesarCipher(this.key);

  /// Anahtarın 0..25 aralığına indirgenmiş hâli.
  ///
  /// Dart'ta `%` operatörü sonucu her zaman pozitif verir: -3 % 26 == 23.
  int get normalizedKey => key % alphabetLength;

  /// Anahtar 0 veya 26'nın katıysa şifreleme metni değiştirmez.
  bool get changesText => normalizedKey != 0;

  /// [plainText] metnini şifreler.
  String encrypt(String plainText) => _shift(plainText, key);

  /// [cipherText] metnini çözer.
  ///
  /// Çözmek, aynı anahtarla ters yöne kaydırmaktır.
  String decrypt(String cipherText) => _shift(cipherText, -key);

  static String _shift(String text, int amount) {
    final shift = amount % alphabetLength;
    final buffer = StringBuffer();

    // codeUnits üzerinde gezmek güvenlidir: A-Z dışındaki birimlere
    // (emoji'nin parçaları dahil) dokunmadığımız için hiçbiri bozulmaz.
    for (final unit in text.codeUnits) {
      if (unit >= _upperA && unit <= _upperZ) {
        buffer.writeCharCode(_rotate(unit, _upperA, shift));
      } else if (unit >= _lowerA && unit <= _lowerZ) {
        buffer.writeCharCode(_rotate(unit, _lowerA, shift));
      } else {
        buffer.writeCharCode(unit);
      }
    }
    return buffer.toString();
  }

  /// Harfi 0-25 arası bir sayıya çevirir, kaydırır ve geri harfe çevirir.
  static int _rotate(int unit, int base, int shift) =>
      (unit - base + shift) % alphabetLength + base;
}
