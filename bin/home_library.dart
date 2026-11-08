import 'package:home_library/book_analytics.dart';
import 'package:home_library/book_parser.dart';
import 'package:home_library/book_validator.dart';
import 'package:home_library/sample_data.dart';

void main() {
  final today = DateTime.now();
  final results = rawBooks.map(parseLine).toList();

  print('--- Розбір ---');
  for (final (index, result) in results.indexed) {
    final error = result.error;
    if (error != null) {
      print('Рядок ${index + 1}: ПОМИЛКА, $error');
    }
  }
  final books = results.map((result) => result.book).nonNulls.toList();
  print('Розібрано: ${books.length} з ${results.length}');

  print('--- Перевірка діапазонів ---');
  final checked = books
      .map((book) => (book: book, violations: validateBook(book, today: today)))
      .toList();
  for (final (:book, :violations) in checked.where(
    (item) => item.violations.isNotEmpty,
  )) {
    print('«${book.title}»: ${violations.join('; ')}');
  }
  final validBooks = checked
      .where((item) => item.violations.isEmpty)
      .map((item) => item.book)
      .toList();
  print('Коректних записів: ${validBooks.length}');

  print('--- Конвеєри ---');
  print('Прочитано: ${readBooks(validBooks).length} з ${validBooks.length}');
  print('Поезія: ${titlesByGenre(validBooks, 'поезія').join(', ')}');
  print('Сторінок прочитано: ${totalPagesRead(validBooks)}');
}
