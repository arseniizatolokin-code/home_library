/// Арифметика дат для записів бібліотеки.
library;

import 'book_parser.dart';

/// Прочитана книга з датою прочитання та кількістю днів від неї до «сьогодні».
typedef ReadAge = ({Book book, DateTime readDate, int days});

/// Кількість повних календарних днів від [from] до [to].
///
/// Дати наводяться до UTC-опівночі, щоб перехід на літній час
/// не зменшував різницю на день.
int daysBetween(DateTime from, DateTime to) {
  final start = DateTime.utc(from.year, from.month, from.day);
  final end = DateTime.utc(to.year, to.month, to.day);
  return end.difference(start).inDays;
}

/// Повертає вік прочитаних книг із [books] у днях станом на [today].
///
/// Непрочитані книги пропускаються.
List<ReadAge> readAges(List<Book> books, {required DateTime today}) => [
  for (final book in books)
    if (book.readDate case final readDate?)
      (book: book, readDate: readDate, days: daysBetween(readDate, today)),
];
