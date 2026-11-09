/// Сортування книг за двома критеріями з перемикачем напряму.
library;

import 'book_parser.dart';

/// Повертає нову відсортовану копію [books] за ключем [key].
///
/// За однакових значень ключа книги впорядковуються за назвою, щоб
/// результат не залежав від стабільності сортування.
List<Book> _sortedBy(
  List<Book> books,
  int Function(Book book) key, {
  required bool ascending,
}) {
  final result = [...books];
  result.sort((a, b) {
    final byKey = key(a).compareTo(key(b));
    final order = byKey != 0 ? byKey : a.title.compareTo(b.title);
    return ascending ? order : -order;
  });
  return result;
}

/// Сортує [books] за роком видання.
///
/// За замовчуванням від найстаріших; з `ascending: false` навпаки.
List<Book> sortedByYear(List<Book> books, {bool ascending = true}) =>
    _sortedBy(books, (book) => book.year, ascending: ascending);

/// Сортує [books] за кількістю сторінок.
///
/// За замовчуванням від найкоротших; з `ascending: false` навпаки.
List<Book> sortedByPages(List<Book> books, {bool ascending = true}) =>
    _sortedBy(books, (book) => book.pages, ascending: ascending);
