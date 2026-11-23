/// Ієрархія видань книги: запечатаний клас і три підтипи.
library;

/// Скільки хвилин займає одна сторінка паперового видання.
const paperMinutesPerPage = 2;

/// Скільки хвилин займає одна сторінка електронного видання.
const ebookMinutesPerPage = 3;

/// Хвилин в одній годині.
const minutesInHour = 60;

/// Об'єкт, який уміє описати себе коротким рядком.
abstract class Describable {
  /// Створює описуваний об'єкт.
  const Describable();

  /// Короткий опис; кожен підтип реалізує його по-своєму.
  String describe();
}

/// Видання, у якому книга зберігається.
///
/// Клас запечатаний: усі підтипи оголошено в цьому файлі, тому
/// компілятор знає їх повний перелік і перевіряє `switch` на вичерпність.
sealed class Edition extends Describable {
  /// Створює видання.
  const Edition();
}

/// Домішка для цифрових видань: уміє оцінити тривалість завантаження.
///
/// Обмеження `on Describable` робить дві речі: дозволяє підмішувати домішку
/// лише до підтипів [Describable] і відкриває доступ до їхніх членів,
/// наприклад до [Describable.describe].
///
/// Обмеження поставлено на [Describable], а не на запечатаний [Edition]:
/// домішка з `on Edition` сама стає підтипом [Edition], і `switch` за
/// [Edition] вимагав би окремої гілки для неї.
mixin Downloadable on Describable {
  /// Розмір файлу в мегабайтах.
  double get sizeMb;

  /// Скільки секунд триватиме завантаження зі швидкістю [mbPerSecond].
  int downloadSeconds({required double mbPerSecond}) =>
      (sizeMb / mbPerSecond).ceil();

  /// Підпис для списку завантажень; користується [describe] надкласу.
  String get downloadLabel => 'Завантажити: ${describe()}';
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
final class EbookEdition extends Edition with Downloadable {
  /// Створює електронне видання розміром [sizeMb] мегабайтів.
  const EbookEdition({required this.sizeMb});

  /// Розмір файлу в мегабайтах.
  @override
  final double sizeMb;

  @override
  String describe() => 'електронне, $sizeMb МБ';
}

/// Аудіокнига.
final class AudioEdition extends Edition with Downloadable {
  /// Створює аудіокнигу тривалістю [minutes] хвилин і розміром [sizeMb].
  const AudioEdition({required this.minutes, required this.sizeMb});

  /// Тривалість запису в хвилинах.
  final int minutes;

  /// Розмір файлу в мегабайтах.
  @override
  final double sizeMb;

  @override
  String describe() =>
      'аудіокнига, ${minutes ~/ minutesInHour} год '
      '${minutes % minutesInHour} хв';
}

/// Демонстраційні видання для кількох книг за назвою.
const editionsByTitle = <String, Edition>{
  'Кобзар': PaperEdition(weightGrams: 450),
  'Лісова пісня': EbookEdition(sizeMb: 1.2),
  'Тигролови': AudioEdition(minutes: 780, sizeMb: 540),
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
