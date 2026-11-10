import 'package:home_library/book_analytics.dart';
import 'package:home_library/book_closures.dart';
import 'package:home_library/book_dates.dart';
import 'package:home_library/book_grouping.dart';
import 'package:home_library/book_parser.dart';
import 'package:home_library/book_report.dart';
import 'package:home_library/book_sorting.dart';
import 'package:home_library/book_text.dart';
import 'package:home_library/book_validator.dart';
import 'package:home_library/sample_data.dart';

/// Скільки книг показувати у списках після сортування.
const topCount = 3;

/// Порогове значення сторінок для «товстих» книг.
const thickBookPages = 300;

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

  print('--- Групування за жанром ---');
  final groups = groupByGenre(validBooks);
  for (final MapEntry(:key, :value) in statsByGenre(groups).entries) {
    final average = value.averagePages.toStringAsFixed(1);
    print('$key: ${value.count} шт., у середньому $average стор.');
  }

  print('--- Сортування ---');
  final oldest = sortedByYear(validBooks)
      .take(topCount)
      .map((book) => '${book.title} (${book.year})');
  print('Найстаріші: ${oldest.join(', ')}');
  final thickest = sortedByPages(
    validBooks,
    ascending: false,
  ).take(topCount).map((book) => '${book.title} (${book.pages})');
  print('Найоб’ємніші: ${thickest.join(', ')}');

  print('--- Звіт ---');
  print(buildReport(validBooks, topCount: topCount));
  print(
    buildReport(validBooks, topCount: 2, ascending: true, separator: ' — '),
  );

  print('--- Замикання ---');
  final nextNumber = createCounter();
  for (final book in validBooks.where(longerThan(thickBookPages))) {
    print('${nextNumber()}. ${book.title}, ${book.pages} с.');
  }

  print('--- Дати ---');
  final ages = readAges(validBooks, today: today);
  for (final item in ages.take(topCount)) {
    final masked = maskDate(isoDate(item.readDate));
    print('«${item.book.title}»: прочитано $masked');
  }
  final byAge = [...ages]..sort((a, b) => b.days.compareTo(a.days));
  final longestAgo = byAge.firstOrNull;
  if (longestAgo != null) {
    print(
      'Найдавніше прочитано: «${longestAgo.book.title}», '
      '${longestAgo.days} дн. тому',
    );
  }
  final latest = byAge.lastOrNull;
  if (latest != null) {
    print(
      'Найсвіжіше прочитано: «${latest.book.title}», '
      '${latest.days} дн. тому',
    );
  }
}
