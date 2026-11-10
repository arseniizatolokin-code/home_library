/// Розбір рядків домашньої бібліотеки у записи.
library;

import 'book_text.dart';

/// Роздільник полів у вхідному рядку.
const fieldSeparator = ';';

/// Очікувана кількість полів у рядку.
const expectedFieldCount = 6;

/// Книга домашньої бібліотеки.
///
/// [readDate] дорівнює `null`, якщо книгу ще не прочитано.
typedef Book = ({
  String author,
  String title,
  int year,
  int pages,
  String genre,
  DateTime? readDate,
});

/// Результат розбору рядка: або [book], або опис помилки [error].
typedef ParseResult = ({Book? book, String? error});

/// Розбирає дату [text] формату `РРРР-ММ-ДД`.
///
/// Повертає `null`, якщо формат неправильний або такої дати не існує.
/// [DateTime.tryParse] сам цього не гарантує: для `2025-13-45` він
/// повертає зсунуту дату, тому результат звіряється з вихідним текстом.
DateTime? parseStrictDate(String text) {
  if (!isIsoDateFormat(text)) return null;
  final date = DateTime.tryParse(text);
  if (date == null) return null;
  return isoDate(date) == text ? date : null;
}

/// Розбирає рядок [line] у запис [Book].
///
/// Якщо рядок не відповідає формату, повертає результат з `book == null`
/// та описом проблеми в `error`. Виняток не генерується.
ParseResult parseLine(String line) {
  final fields = line.split(fieldSeparator).map((f) => f.trim()).toList();
  if (fields.length != expectedFieldCount) {
    return (
      book: null,
      error: 'очікувалось полів: $expectedFieldCount, є: ${fields.length}',
    );
  }

  final [author, title, yearText, pagesText, genre, dateText] = fields;
  if (author.isEmpty || title.isEmpty) {
    return (book: null, error: 'порожній автор або назва');
  }

  final year = int.tryParse(yearText);
  if (year == null) {
    return (book: null, error: 'рік не є числом: "$yearText"');
  }

  final pages = int.tryParse(pagesText);
  if (pages == null) {
    return (book: null, error: 'кількість сторінок не є числом: "$pagesText"');
  }

  final readDate = dateText.isEmpty ? null : parseStrictDate(dateText);
  if (dateText.isNotEmpty && readDate == null) {
    return (book: null, error: 'некоректна дата: "$dateText"');
  }

  return (
    book: (
      author: author,
      title: title,
      year: year,
      pages: pages,
      genre: genre,
      readDate: readDate,
    ),
    error: null,
  );
}
