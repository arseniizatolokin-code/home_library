/// Стан читання книги: перелічення з членами та зіставлення зі зразком.
library;

import 'book_dates.dart';
import 'book_parser.dart';

/// Скільки днів від дати прочитання книга вважається «нещодавно прочитаною».
const recentDays = 180;

/// Стан читання книги.
///
/// Перелічення має поле, константний конструктор і метод, тому кожне
/// значення несе власний підпис, а логіка вибору підпису не розкидана
/// по програмі.
enum ReadingStatus {
  /// Книгу ще не прочитано.
  unread('не прочитано'),

  /// Книгу прочитано не раніше ніж [recentDays] днів тому.
  recent('прочитано нещодавно'),

  /// Книгу прочитано давно.
  old('прочитано давно');

  /// Створює стан з підписом [title].
  const ReadingStatus(this.title);

  /// Підпис для звіту.
  final String title;

  /// Чи книгу вже прочитано.
  bool get isFinished => this != unread;
}

/// Визначає стан читання [book] станом на [today].
///
/// Друга гілка використовує охоронець `when`: зразок `final date`
/// збігається з будь-якою непорожньою датою, а умова після `when`
/// відсіює давно прочитані книги.
ReadingStatus statusOf(Book book, {required DateTime today}) =>
    switch (book.readDate) {
      null => ReadingStatus.unread,
      final date when daysBetween(date, today) <= recentDays =>
        ReadingStatus.recent,
      _ => ReadingStatus.old,
    };

/// Рахує книги з [books] за станом читання станом на [today].
///
/// Повертає запис: кількість прочитаних і кількість непрочитаних книг.
({int finished, int unfinished}) countFinished(
  List<Book> books, {
  required DateTime today,
}) {
  final finished = books
      .where((book) => statusOf(book, today: today).isFinished)
      .length;
  return (finished: finished, unfinished: books.length - finished);
}
