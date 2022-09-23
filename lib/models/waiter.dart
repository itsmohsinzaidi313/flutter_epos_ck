class Waiter {
  static const IdKey = 'Id';
  static const NameKey = 'Name';

  final String id;
  final String name;
  final bool selected;

  const Waiter({
    this.id = '',
    this.name = '',
    this.selected = false,
  });

  Waiter.modify(Waiter waiter, {String? id, String? name, bool? selected})
      : id = id ?? waiter.id,
        name = name ?? waiter.name,
        selected = selected ?? waiter.selected;

  Waiter.fromMap(Map<String, dynamic> map)
      : id = map[IdKey],
        name = map[NameKey],
        selected = false;
}
