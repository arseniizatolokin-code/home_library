/// Ієрархія видань книги: запечатаний клас і три підтипи.
library;

/// Скільки хвилин займає одна сторінка паперового видання.
const paperMinutesPerPage = 2;

/// Скільки хвилин займає одна сторінка електронного видання.
const ebookMinutesPerPage = 3;

/// Хвилин в одній годині.
const minutesInHour = 60;

/// Видання, у якому книга зберігається.
///
/// Клас запечатаний: усі підтипи оголошено в цьому файлі, тому
/// компілятор знає їх повний перелік і перевіряє `switch` на вичерпність.
sealed class Edition {
  /// Створює видання.
  const Edition();

  /// Короткий опис видання; кожен підтип реалізує його по-своєму.
  String describe();
}

/// Паперове видання.
final class PaperEdition extends Edition {
  /// Створює паперове видання вагою [weightGrams] грамів.
  const PaperEdition({required this.weightGrams});

  /// Вага книги в грамах.
  final int weightGrams;

  @override
  String describe() => 'паперове, $weightGrams г';
}

/// Електронне видання.
final class EbookEdition extends Edition {
  /// Створює електронне видання розміром [sizeMb] мегабайтів.
  const EbookEdition({required this.sizeMb});

  /// Розмір файлу в мегабайтах.
  final double sizeMb;

  @override
  String describe() => 'електронне, $sizeMb МБ';
}

/// Аудіокнига.
final class AudioEdition extends Edition {
  /// Створює аудіокнигу тривалістю [minutes] хвилин.
  const AudioEdition({required this.minutes});

  /// Тривалість запису в хвилинах.
  final int minutes;

  @override
  String describe() =>
      'аудіокнига, ${minutes ~/ minutesInHour} год '
      '${minutes % minutesInHour} хв';
}

/// Демонстраційні видання для кількох книг за назвою.
const editionsByTitle = <String, Edition>{
  'Кобзар': PaperEdition(weightGrams: 450),
  'Лісова пісня': EbookEdition(sizeMb: 1.2),
  'Тигролови': AudioEdition(minutes: 780),
};

/// Скільки хвилин потрібно, щоб опанувати книгу у виданні [edition].
///
/// Для друкованого та електронного видань час залежить від кількості
/// сторінок [pages], для аудіокниги дорівнює її тривалості. У `switch`
/// немає гілки `default`: компілятор перевіряє, що розглянуто всі підтипи.
int minutesToFinish(Edition edition, {required int pages}) => switch (edition) {
  PaperEdition() => pages * paperMinutesPerPage,
  EbookEdition() => pages * ebookMinutesPerPage,
  AudioEdition(:final minutes) => minutes,
};
