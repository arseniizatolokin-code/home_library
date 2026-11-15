/// Розбір рядків домашньої бібліотеки у книги.
library;

import 'book.dart';

export 'book.dart';

/// Результат розбору рядка: або [book], або опис помилки [error].
typedef ParseResult = ({Book? book, String? error});

/// Розбирає рядок [line] у [Book] без винятку для викликача.
///
/// Якщо рядок не відповідає формату, повертає результат з `book == null`
/// та описом проблеми в `error`.
ParseResult parseLine(String line) {
  try {
    return (book: Book.fromCsv(line), error: null);
  } on FormatException catch (e) {
    return (book: null, error: e.message);
  }
}
