/// Групування книг за категорійною ознакою та агрегати для груп.
library;

import 'book_parser.dart';

/// Агрегати для однієї групи книг: кількість і середній обсяг.
typedef GenreStats = ({int count, double averagePages});

/// Групує [books] за жанром.
///
/// Ключ мапи — жанр, значення — книги цього жанру в початковому порядку.
Map<String, List<Book>> groupByGenre(List<Book> books) {
  final groups = <String, List<Book>>{};
  for (final book in books) {
    groups.putIfAbsent(book.genre, () => []).add(book);
  }
  return groups;
}

/// Обчислює кількість книг і середню кількість сторінок для кожної групи.
///
/// Порожні групи пропускаються, щоб уникнути ділення на нуль.
Map<String, GenreStats> statsByGenre(Map<String, List<Book>> groups) => {
  for (final MapEntry(:key, :value) in groups.entries)
    if (value.isNotEmpty)
      key: (
        count: value.length,
        averagePages:
            value.map((book) => book.pages).fold(0, (sum, p) => sum + p) /
            value.length,
      ),
};
