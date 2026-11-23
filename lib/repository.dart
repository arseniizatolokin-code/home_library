/// Узагальнене сховище сутностей з ідентифікатором.
library;

/// Сутність, яка вміє повідомляти власний ідентифікатор.
abstract interface class Identifiable {
  /// Унікальний ідентифікатор сутності.
  String get id;
}

/// Сховище сутностей, які вміють повідомляти власний ідентифікатор.
///
/// Обмеження `T extends Identifiable` гарантує, що в кожного елемента є
/// `id`, тому сховище може користуватися ним без приведення типів.
class Repository<T extends Identifiable> {
  final Map<String, T> _items = {};

  /// Кількість елементів у сховищі.
  int get length => _items.length;

  /// Додає [item]; елемент із таким самим `id` замінюється.
  void add(T item) => _items[item.id] = item;

  /// Повертає елемент з ідентифікатором [id] або `null`.
  T? findById(String id) => _items[id];

  /// Повертає елементи, для яких [test] повертає `true`.
  Iterable<T> where(bool Function(T item) test) => _items.values.where(test);
}
