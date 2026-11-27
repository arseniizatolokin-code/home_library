/// Асинхронне сховище сутностей предметної області.
library;

import 'repository.dart';

/// Затримка за замовчуванням, якою імітується звернення до джерела даних.
const defaultDelay = Duration(milliseconds: 300);

/// Інтервал між елементами потоку за замовчуванням.
const defaultInterval = Duration(milliseconds: 100);

/// Виняток: сутність з потрібним ідентифікатором не знайдено.
class NotFoundException implements Exception {
  /// Створює виняток для ідентифікатора [id].
  const NotFoundException(this.id);

  /// Ідентифікатор, якого немає в сховищі.
  final String id;

  @override
  String toString() => 'NotFoundException: немає запису "$id"';
}

/// Асинхронне сховище сутностей, які вміють повідомляти власний ідентифікатор.
///
/// Кожна операція повертає [Future] і виконується із затримкою [delay],
/// яка імітує звернення до файлу чи мережі.
class AsyncRepository<T extends Identifiable> {
  /// Створює порожнє сховище із затримкою операцій [delay].
  AsyncRepository({this.delay = defaultDelay});

  /// Тривалість однієї операції.
  final Duration delay;

  final Map<String, T> _items = {};

  /// Кількість елементів у сховищі просто зараз (без очікування).
  int get length => _items.length;

  /// Повертає сутність за ідентифікатором [id] або `null`.
  Future<T?> load(String id) async {
    await Future<void>.delayed(delay);
    return _items[id];
  }

  /// Повертає сутність за ідентифікатором [id] або кидає
  /// [NotFoundException], якщо її немає.
  Future<T> require(String id) async {
    final item = await load(id);
    if (item == null) {
      throw NotFoundException(id);
    }
    return item;
  }

  /// Зберігає [item]; елемент з таким самим `id` замінюється.
  Future<void> save(T item) async {
    await Future<void>.delayed(delay);
    _items[item.id] = item;
  }

  /// Видаляє сутність з ідентифікатором [id].
  ///
  /// Повертає `true`, якщо сутність була у сховищі.
  Future<bool> delete(String id) async {
    await Future<void>.delayed(delay);
    return _items.remove(id) != null;
  }

  /// Видаляє всі сутності.
  Future<void> clear() async {
    await Future<void>.delayed(delay);
    _items.clear();
  }

  /// Видає сутності по одній з інтервалом [interval] між ними.
  Stream<T> watchAll({Duration interval = defaultInterval}) async* {
    for (final item in _items.values.toList()) {
      await Future<void>.delayed(interval);
      yield item;
    }
  }
}
