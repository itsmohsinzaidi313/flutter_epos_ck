import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/item.dart';

class ItemsCart {
  List<Item> _items;
  ItemsCart({required List<Item> items}) : _items = items;
  List<Item> get items => _items;

  void add(Item item) => _items.add(item);

  void increase(int index) {
    if (_items[index] is OnSpotDeal) {
      _items[index] = OnSpotDeal.modify(_items[index] as OnSpotDeal,
          quantity: _items[index].quantity + 1);
    } else if (_items[index] is FixedDeal) {
      _items[index] = FixedDeal.modify(_items[index] as FixedDeal,
          quantity: _items[index].quantity + 1);
    } else if (_items[index] is FoodItem) {
      _items[index] = FoodItem.modify(_items[index] as FoodItem,
          quantity: _items[index].quantity + 1);
    }
  }

  void reduce(int index) {
    if (_items[index] is OnSpotDeal) {
      _items[index] = OnSpotDeal.modify(_items[index] as OnSpotDeal,
          quantity: _items[index].quantity - 1);
    } else if (_items[index] is FixedDeal) {
      _items[index] = FixedDeal.modify(_items[index] as FixedDeal,
          quantity: _items[index].quantity - 1);
    } else if (_items[index] is FoodItem) {
      _items[index] = FoodItem.modify(_items[index] as FoodItem,
          quantity: _items[index].quantity - 1);
    }
  }

  void addComment(int index, String value) {
    if (_items[index] is OnSpotDeal) {
      _items[index] =
          OnSpotDeal.modify(_items[index] as OnSpotDeal, comment: value);
    } else if (_items[index] is FixedDeal) {
      _items[index] =
          FixedDeal.modify(_items[index] as FixedDeal, comment: value);
    } else if (_items[index] is FoodItem) {
      _items[index] =
          FoodItem.modify(_items[index] as FoodItem, comment: value);
    }
  }

  void remove(int index) => _items.removeAt(index);

  void clear() => _items.clear();

  void clean() {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].quantity <= 0) {
        _items.removeAt(i);
      }
    }
  }

  void increaseQuantity(Item item) {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].id == item.id && _items[i].comment.isEmpty) {
        if (_items[i] is OnSpotDeal) {
          _items[i] = OnSpotDeal.modify(_items[i] as OnSpotDeal,
              quantity: _items[i].quantity + 1);
        } else if (_items[i] is FixedDeal) {
          _items[i] = FixedDeal.modify(_items[i] as FixedDeal,
              quantity: _items[i].quantity + 1);
        } else if (_items[i] is FoodItem) {
          _items[i] =
              FoodItem.modify(_items[i], quantity: _items[i].quantity + 1);
        }

        break;
      }
    }
  }

  void addItem(Item item) {
    if (item is FoodItem) {
      _items.add(FoodItem.modify(item));
    } else if (item is FixedDeal) {
      _items.add(FixedDeal.fromDeal(item));
    }
  }

  void reduceCartItem(String? itemId, {bool removeZeroQuantity = true}) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == '$itemId') {
        if (_items[i].quantity > 0) {
          if (_items[i] is OnSpotDeal) {
            _items[i] = OnSpotDeal.modify(_items[i] as OnSpotDeal,
                quantity: _items[i].quantity - 1);
          } else if (_items[i] is FixedDeal) {
            _items[i] = FixedDeal.modify(_items[i] as FixedDeal,
                quantity: _items[i].quantity - 1);
          } else if (_items[i] is FoodItem) {
            _items[i] =
                FoodItem.modify(_items[i], quantity: _items[i].quantity - 1);
          }
        }
        if (_items[i].quantity < 1 && removeZeroQuantity) {
          removeCartItem(itemId);
        }
        break;
      }
    }
  }

  void removeCartItem(String? itemId) =>
      _items.removeAt(_items.indexWhere((element) => element.id == itemId));

  void addItemComment(int itemId, String comment) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == itemId.toString()) {
        if (_items[i] is OnSpotDeal) {
          _items[i] =
              OnSpotDeal.modify(_items[i] as OnSpotDeal, comment: comment);
        } else if (_items[i] is FixedDeal) {
          _items[i] =
              FixedDeal.modify(_items[i] as FixedDeal, comment: comment);
        } else if (_items[i] is FoodItem) {
          _items[i] = FoodItem.modify(_items[i], comment: comment);
        }
        break;
      }
    }
  }
}
