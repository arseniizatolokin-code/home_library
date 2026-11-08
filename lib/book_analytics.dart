/// Конвеєри обробки колекції книг: фільтрація, перетворення, згортання.
library;

import 'book_parser.dart';

/// Повертає прочитані книги, тобто ті, що мають дату прочитання.
List<Book> readBooks(List<Book> books) =>
    books.where((book) => book.readDate != null).toList();

/// Повертає назви книг жанру [genre].
List<String> titlesByGenre(List<Book> books, String genre) => books
    .where((book) => book.genre == genre)
    .map((book) => book.title)
    .toList();

/// Підсумовує кількість сторінок у прочитаних книгах.
int totalPagesRead(List<Book> books) =>
    readBooks(books)
        .map((book) => book.pages)
        .fold(0, (sum, pages) => sum + pages);
