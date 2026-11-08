/// Перевірка значень записів на допустимі діапазони.
library;

import 'book_parser.dart';

/// Найраніший допустимий рік видання (початок друкарства в Європі).
const minPublicationYear = 1450;

/// Мінімальна допустима кількість сторінок.
const minPageCount = 1;

/// Максимальна допустима кількість сторінок.
const maxPageCount = 5000;

/// Перевіряє [book] і повертає перелік виявлених порушень.
///
/// Порожній список означає, що запис коректний. Поточна дата [today]
/// передається ззовні, щоб функція не залежала від годинника.
List<String> validateBook(
  Book book, {
  required DateTime today,
  int minYear = minPublicationYear,
  int minPages = minPageCount,
  int maxPages = maxPageCount,
}) {
  final readDate = book.readDate;
  return [
    if (book.year < minYear || book.year > today.year)
      'рік ${book.year} поза діапазоном $minYear–${today.year}',
    if (book.pages < minPages || book.pages > maxPages)
      'сторінок ${book.pages} поза діапазоном $minPages–$maxPages',
    if (readDate != null && readDate.isAfter(today))
      'дата прочитання у майбутньому',
    if (readDate != null && readDate.year < book.year)
      'книгу прочитано раніше за рік видання',
  ];
}
