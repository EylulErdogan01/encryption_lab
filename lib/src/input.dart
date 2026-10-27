/// Kullanıcı girişlerini kontrol eden yardımcı fonksiyonlar.
///
/// Arayüzden bağımsızdır: hem terminal menüsü hem ileride Flutter ekranı
/// bu fonksiyonları kullanır.
library;

/// Anahtar girişini tam sayıya çevirir.
///
/// Geçersizse (boş, harf içeren, ondalıklı vb.) `null` döndürür.
/// Baştaki ve sondaki boşluklar yok sayılır: `' 3 '` -> `3`.
int? parseKey(String? input) {
  if (input == null) return null;
  return int.tryParse(input.trim());
}

/// Metin boş mu ya da yalnızca boşluklardan mı oluşuyor?
bool isBlank(String? input) => input == null || input.trim().isEmpty;
