import 'package:home_library/book_parser.dart';
import 'package:home_library/sample_data.dart';

void main() {
  final results = rawBooks.map(parseLine).toList();

  for (final (index, result) in results.indexed) {
    final book = result.book;
    final lineNumber = index + 1;
    if (book == null) {
      print('Рядок $lineNumber: ПОМИЛКА, ${result.error}');
    } else {
      print('Рядок $lineNumber: ${book.author}, «${book.title}», ${book.year}');
    }
  }

  final parsedCount = results.where((result) => result.book != null).length;
  print('Розібрано: $parsedCount з ${results.length}');
}
