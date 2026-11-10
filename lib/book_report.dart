/// Текстовий звіт про книги.
library;

import 'book_parser.dart';
import 'book_sorting.dart';

/// Формує текстовий звіт про [topCount] книг за кількістю сторінок.
///
/// З `ascending: false` (за замовчуванням) спершу найоб'ємніші.
/// Поля рядка з'єднуються рядком [separator].
String buildReport(
  List<Book> books, {
  int topCount = 5,
  bool ascending = false,
  String separator = ' | ',
}) {
  final buffer = StringBuffer()..write('Звіт: ${books.length} книг');
  final selected = sortedByPages(books, ascending: ascending).take(topCount);
  for (final (index, book) in selected.indexed) {
    final fields = [
      '${index + 1}',
      book.title,
      book.author,
      '${book.pages} с.',
    ];
    buffer
      ..write('\n')
      ..write(fields.join(separator));
  }
  return buffer.toString();
}
