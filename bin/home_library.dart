import 'package:home_library/book_analytics.dart';
import 'package:home_library/book_closures.dart';
import 'package:home_library/book_dates.dart';
import 'package:home_library/book_extensions.dart';
import 'package:home_library/book_grouping.dart';
import 'package:home_library/book_parser.dart';
import 'package:home_library/book_report.dart';
import 'package:home_library/book_sorting.dart';
import 'package:home_library/book_text.dart';
import 'package:home_library/book_validator.dart';
import 'package:home_library/edition.dart';
import 'package:home_library/hash_experiment.dart';
import 'package:home_library/repository.dart';
import 'package:home_library/sample_data.dart';

/// Скільки книг показувати у списках після сортування.
const topCount = 3;

/// Порогове значення сторінок для «товстих» книг.
const thickBookPages = 300;

/// Швидкість завантаження в мегабайтах за секунду.
const downloadSpeedMbPerSecond = 2.0;

/// Кількість однакових об'єктів в експерименті без hashCode.
const copies = 100;

/// Жанр, назви книг якого виводяться окремим рядком.
const poetryGenre = 'поезія';

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
  print('Поезія: ${titlesByGenre(validBooks, poetryGenre).join(', ')}');
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

  print('--- Класи ---');
  const manual = Book(
    author: 'Автор',
    title: 'Назва',
    year: 2000,
    pages: 100,
    genre: 'жанр',
  );
  print(manual);
  final first = Book.cached(rawBooks.first);
  final second = Book.cached(rawBooks.first);
  print('${first.label}; той самий об’єкт: ${identical(first, second)}');

  print('--- Рівність ---');
  final a = Book.fromCsv(rawBooks.first);
  final b = Book.fromCsv(rawBooks.first);
  print('Рівні за ==: ${a == b}; той самий об’єкт: ${identical(a, b)}');
  print('Set із двох рівних книг: ${{a, b}.length}');
  print('contains з hashCode: ${{a}.contains(b)}');
  final noHash = {for (var i = 0; i < copies; i++) BookEqOnly('Кобзар', 1840)};
  print('Set зі $copies рівних об’єктів без hashCode: ${noHash.length}');
  final probe = BookEqOnly('Кобзар', 1840);
  print('contains без hashCode: ${noHash.contains(probe)}');

  print('--- Видання ---');
  for (final book in validBooks) {
    final edition = editionsByTitle[book.title];
    if (edition == null) continue;
    final minutes = minutesToFinish(edition, pages: book.pages);
    print('«${book.title}»: ${edition.describe()}; $minutes хв');
  }

  print('--- Домішка ---');
  for (final edition in editionsByTitle.values) {
    if (edition case final Downloadable download) {
      final seconds = download.downloadSeconds(
        mbPerSecond: downloadSpeedMbPerSecond,
      );
      print('${download.downloadLabel}: $seconds с');
    }
  }

  print('--- Розширення ---');
  final authors = validBooks
      .take(topCount)
      .map((book) => book.author.shortAuthor);
  print(authors.join(', '));

  print('--- Сховище ---');
  final repository = Repository<Book>();
  validBooks.forEach(repository.add);
  print('У сховищі: ${repository.length}');
  final found = repository.findById(validBooks.first.id);
  print('Знайдено: ${found?.label ?? 'немає'}');
  final thick = repository.where((book) => book.pages > thickBookPages);
  print('Книг понад $thickBookPages сторінок: ${thick.length}');
}
