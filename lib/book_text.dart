/// Перевірка формату та маскування текстових значень.
library;

/// Дата `РРРР-ММ-ДД`; групи названо, щоб не покладатися на номери.
final _isoDate = RegExp(r'^(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})$');

/// Повертає `true`, якщо [text] має формат `РРРР-ММ-ДД`.
///
/// Перевіряється лише форма запису, а не існування такої дати.
bool isIsoDateFormat(String text) => _isoDate.hasMatch(text);

/// Записує [date] у форматі `РРРР-ММ-ДД`.
String isoDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

/// Ховає місяць і день у даті [text], залишаючи лише рік.
///
/// Рядок, який не є датою формату `РРРР-ММ-ДД`, повертається без змін.
String maskDate(String text) => text.replaceAllMapped(_isoDate, (match) {
  // replaceAllMapped оголошує тип Match, але для RegExp повертає
  // RegExpMatch, який єдиний має namedGroup.
  final year = (match as RegExpMatch).namedGroup('year');
  return '$year-**-**';
});
