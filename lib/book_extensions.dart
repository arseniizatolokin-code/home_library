/// Методи розширення для предметної області «домашня бібліотека».
library;

/// Мінімальна кількість слів у повному імені автора.
const _fullNameParts = 2;

final _spaces = RegExp(r'\s+');

/// Допоміжні методи для імен авторів.
extension AuthorName on String {
  /// Скорочує повне ім'я до вигляду «І. Прізвище».
  ///
  /// Рядок з одного слова повертається без змін.
  String get shortAuthor {
    final parts = trim().split(_spaces);
    if (parts.length < _fullNameParts) return this;
    return '${parts.first[0]}. ${parts.sublist(1).join(' ')}';
  }
}
