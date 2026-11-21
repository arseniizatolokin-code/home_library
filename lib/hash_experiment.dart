// Навмисне порушення правила: файл існує лише для експерименту.
// ignore_for_file: hash_and_equals

/// Експеримент: що буде, якщо перевизначити `==`, але не `hashCode`.
library;

/// Спрощена книга, у якої перевизначено `==`, але немає `hashCode`.
///
/// Використовується лише для демонстрації в звіті: у `Set` такі об'єкти
/// поводяться неправильно.
class BookEqOnly {
  /// Створює книгу із заданою назвою та роком.
  BookEqOnly(this.title, this.year);

  /// Назва книги.
  final String title;

  /// Рік видання.
  final int year;

  @override
  bool operator ==(Object other) =>
      other is BookEqOnly && title == other.title && year == other.year;
}
