/// Незмінна сутність «книга» домашньої бібліотеки.
library;

import 'book_text.dart';

/// Роздільник полів у вхідному рядку.
const fieldSeparator = ';';

/// Очікувана кількість полів у рядку.
const expectedFieldCount = 6;

/// Значення полів, розібрані з рядка, до створення об'єкта.
typedef _Fields = ({
  String author,
  String title,
  int year,
  int pages,
  String genre,
  DateTime? readDate,
});

/// Книга домашньої бібліотеки.
///
/// Об'єкт незмінний: усі поля `final`.
class Book {
  /// Створює книгу із готових значень.
  const Book({
    required this.author,
    required this.title,
    required this.year,
    required this.pages,
    required this.genre,
    this.readDate,
  });

  /// Розбирає рядок формату `автор;назва;рік;сторінки;жанр;дата`.
  ///
  /// Порожня дата означає, що книгу ще не прочитано.
  /// Кидає [FormatException], якщо рядок не відповідає формату.
  Book.fromCsv(String line) : this._fromFields(_parse(line));

  Book._fromFields(_Fields fields)
    : author = fields.author,
      title = fields.title,
      year = fields.year,
      pages = fields.pages,
      genre = fields.genre,
      readDate = fields.readDate;

  /// Повертає вже створену книгу для того самого рядка [line].
  ///
  /// Для нового рядка розбирає його через [Book.fromCsv] і запам'ятовує.
  /// Повторні виклики з тим самим рядком повертають той самий об'єкт.
  factory Book.cached(String line) =>
      _cache.putIfAbsent(line, () => Book.fromCsv(line));

  static final _cache = <String, Book>{};

  /// Автор книги.
  final String author;

  /// Назва книги.
  final String title;

  /// Рік видання.
  final int year;

  /// Кількість сторінок.
  final int pages;

  /// Жанр.
  final String genre;

  /// Дата прочитання; `null`, якщо книгу ще не прочитано.
  final DateTime? readDate;

  /// Чи прочитано книгу.
  bool get isRead => readDate != null;

  /// Короткий підпис: назва та рік видання.
  String get label => '$title ($year)';

  static _Fields _parse(String line) {
    final fields = line.split(fieldSeparator).map((f) => f.trim()).toList();
    if (fields.length != expectedFieldCount) {
      throw FormatException(
        'очікувалось полів: $expectedFieldCount, є: ${fields.length}',
        line,
      );
    }

    final [author, title, yearText, pagesText, genre, dateText] = fields;
    if (author.isEmpty || title.isEmpty) {
      throw FormatException('порожній автор або назва', line);
    }

    final year = int.tryParse(yearText);
    if (year == null) {
      throw FormatException('рік не є числом: "$yearText"', line);
    }

    final pages = int.tryParse(pagesText);
    if (pages == null) {
      throw FormatException(
        'кількість сторінок не є числом: "$pagesText"',
        line,
      );
    }

    final readDate = dateText.isEmpty ? null : parseStrictDate(dateText);
    if (dateText.isNotEmpty && readDate == null) {
      throw FormatException('некоректна дата: "$dateText"', line);
    }

    return (
      author: author,
      title: title,
      year: year,
      pages: pages,
      genre: genre,
      readDate: readDate,
    );
  }

  @override
  String toString() => 'Book($author, «$title», $year)';
}
