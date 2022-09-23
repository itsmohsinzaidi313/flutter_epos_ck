import 'package:equatable/equatable.dart';
import 'package:pos_app/models/item.dart';

class FoodItem extends Item with EquatableMixin {
  FoodItem({
    String rowId = '',
    String id = '',
    String code = '',
    String categoryId = '',
    String name = '',
    double price = 0,
    double taxAmount = 0,
    double quantity = 0,
    String image = '',
    String comment = '',
    bool selected = false,
  }) : super(
            rowId: rowId,
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image,
            comment: comment,
            selected: selected);

  FoodItem.modify(Item item,
      {String? rowId,
      String? id,
      String? code,
      String? categoryId,
      String? name,
      double? price,
      double? taxAmount,
      double? quantity,
      String? image,
      String? comment,
      bool? selected,
      bool? isAdditional})
      : super(
            rowId: rowId ?? item.rowId,
            id: id ?? item.id,
            code: code ?? item.code,
            categoryId: categoryId ?? item.categoryId,
            name: name ?? item.name,
            price: price ?? item.price,
            taxAmount: taxAmount ?? item.taxAmount,
            quantity: quantity ?? item.quantity,
            image: image ?? item.image,
            comment: comment ?? item.comment,
            selected: selected ?? item.selected,
            isAdditional: isAdditional ?? item.isAdditional);

  FoodItem.fromMap(Map<String, dynamic> map)
      : super(
          rowId: map[Item.rowIdKey],
          id: map[Item.idKey],
          code: map[Item.codeKey],
          categoryId: map[Item.categoryIdKey],
          name: map[Item.nameKey],
          price: map[Item.priceKey],
          taxAmount: map[Item.taxAmountKey],
          quantity: map[Item.quantityKey],
          image: '',
          selected: map[Item.selectedKey],
          comment: map[Item.commentKey],
        );

  Map<String, dynamic> toMap() => {
        Item.rowIdKey: rowId,
        Item.idKey: id,
        Item.codeKey: code,
        Item.categoryIdKey: categoryId,
        Item.nameKey: name,
        Item.priceKey: price,
        Item.taxAmountKey: taxAmount,
        Item.quantityKey: quantity,
        Item.imageKey: image,
        Item.selectedKey: selected,
        Item.commentKey: comment,
      };

  @override
  List<Object?> get props => [id];
}

class FixedDeal extends Item with EquatableMixin {
  static String itemsKey = 'Items';
  final List<Item>? dealItems;

  const FixedDeal(
      {String rowId = '',
      String id = '',
      String code = '',
      String categoryId = '',
      String name = '',
      double price = 0,
      double taxAmount = 0,
      double quantity = 0,
      String image = '',
      String comment = '',
      bool selected = false,
      this.dealItems})
      : super(
          rowId: rowId,
          id: id,
          code: code,
          categoryId: categoryId,
          name: name,
          price: price,
          taxAmount: taxAmount,
          quantity: quantity,
          image: image,
          comment: comment,
          selected: selected,
        );

  FixedDeal.modify(FixedDeal deal,
      {String? rowId,
      String? id,
      String? code,
      String? categoryId,
      String? name,
      double? price,
      double? taxAmount,
      double? quantity,
      String? image,
      String? comment,
      bool? selected,
      bool? isAdditional})
      : dealItems = deal.dealItems ?? <FixedDeal>[],
        super(
          rowId: rowId ?? deal.rowId,
          id: id ?? deal.id,
          code: code ?? deal.code,
          categoryId: categoryId ?? deal.categoryId,
          name: name ?? deal.name,
          price: price ?? deal.price,
          taxAmount: taxAmount ?? deal.taxAmount,
          quantity: quantity ?? deal.quantity,
          image: image ?? deal.image,
          comment: comment ?? deal.comment,
          selected: selected ?? deal.selected,
          isAdditional: isAdditional ?? deal.isAdditional,
        );

  FixedDeal.fromMap(Map<String, dynamic> map)
      : this.dealItems = (map[itemsKey] as List<dynamic>)
            .map((e) => FoodItem.fromMap(e))
            .toList(),
        super(
            rowId: map[Item.rowIdKey],
            id: map[Item.idKey],
            code: map[Item.codeKey],
            categoryId: map[Item.categoryIdKey],
            name: map[Item.nameKey],
            price: map[Item.priceKey],
            taxAmount: map[Item.taxAmountKey],
            quantity: map[Item.quantityKey],
            image: '',
            selected: map[Item.selectedKey],
            comment: map[Item.commentKey]);

  FixedDeal.fromDeal(FixedDeal deal)
      : dealItems = deal.dealItems,
        super(
            rowId: deal.rowId,
            id: deal.id,
            categoryId: deal.categoryId,
            code: deal.code,
            name: deal.name,
            price: deal.price,
            quantity: deal.quantity,
            comment: deal.comment,
            image: deal.image,
            selected: deal.selected,
            taxAmount: deal.taxAmount);

  @override
  Map<String, dynamic> toMap() => {
        Item.rowIdKey: rowId,
        Item.idKey: id,
        Item.codeKey: code,
        Item.categoryIdKey: categoryId,
        Item.nameKey: name,
        Item.taxAmountKey: taxAmount,
        Item.priceKey: price,
        Item.quantityKey: quantity,
        Item.commentKey: comment,
        Item.selectedKey: selected,
        itemsKey: dealItems!.map((e) => e.toMap()).toList(),
      };

  @override
  List<Object?> get props => [id];
}

class OnSpotDeal extends Item with EquatableMixin {
  static const String dealItemsKey = 'DealItems', dealStepsKey = 'DealSteps';
  final List<OnSpotDealItem> dealItems;
  final List<DealStep> dealSteps;
  const OnSpotDeal({
    String rowId = '',
    String id = '',
    String code = '',
    String categoryId = '',
    String name = '',
    double price = 0,
    double taxAmount = 0,
    double quantity = 0,
    String image = '',
    bool selected = false,
    String comment = '',
    bool isAdditional = false,
    this.dealItems = const [],
    this.dealSteps = const [],
  }) : super(
          rowId: rowId,
          id: id,
          code: code,
          categoryId: categoryId,
          name: name,
          price: price,
          taxAmount: taxAmount,
          quantity: quantity,
          image: image,
          selected: selected,
          comment: comment,
          isAdditional: isAdditional,
        );

  OnSpotDeal.fromMap(Map<String, dynamic> map)
      : this.dealItems = (map[dealItemsKey] as List<dynamic>)
            .map((e) => OnSpotDealItem.fromMap(e))
            .toList(),
        this.dealSteps = (map[dealStepsKey] as List<dynamic>)
            .map((e) => DealStep.fromMap(e))
            .toList(),
        super(
          rowId: map[Item.rowIdKey],
          id: map[Item.idKey],
          code: map[Item.codeKey],
          categoryId: map[Item.categoryIdKey],
          name: map[Item.nameKey],
          price: map[Item.priceKey],
          taxAmount: map[Item.taxAmountKey],
          quantity: map[Item.quantityKey],
          selected: map[Item.selectedKey],
          comment: '',
          image: '',
        );

  OnSpotDeal.fromOnSpotDeal(OnSpotDeal deal)
      : this.dealItems = deal.dealItems,
        this.dealSteps = deal.dealSteps,
        super(
            rowId: deal.rowId,
            id: deal.id,
            code: deal.code,
            categoryId: deal.categoryId,
            name: deal.name,
            price: deal.price,
            quantity: deal.quantity,
            comment: deal.comment,
            image: deal.image,
            selected: deal.selected,
            taxAmount: deal.taxAmount);

  OnSpotDeal.modify(OnSpotDeal deal,
      {String? rowId,
      String? id,
      String? code,
      String? categoryId,
      String? name,
      double? price,
      double? taxAmount,
      double? quantity,
      String? image,
      String? comment,
      bool? selected,
      bool? isAdditional,
      List<OnSpotDealItem>? items,
      List<DealStep>? steps})
      : this.dealItems = items ?? deal.dealItems,
        this.dealSteps = steps ?? deal.dealSteps,
        super(
          rowId: rowId ?? deal.rowId,
          id: id ?? deal.id,
          code: code ?? deal.code,
          categoryId: categoryId ?? deal.categoryId,
          name: name ?? deal.name,
          price: price ?? deal.price,
          quantity: quantity ?? deal.quantity,
          comment: comment ?? deal.comment,
          image: image ?? deal.image,
          selected: selected ?? deal.selected,
          taxAmount: taxAmount ?? deal.taxAmount,
          isAdditional: isAdditional ?? deal.isAdditional,
        );

  @override
  Map<String, dynamic> toMap() => {
        Item.rowIdKey: rowId,
        Item.idKey: id,
        Item.codeKey: code,
        Item.categoryIdKey: categoryId,
        Item.nameKey: name,
        Item.taxAmountKey: taxAmount,
        Item.priceKey: price,
        Item.quantityKey: quantity,
        Item.commentKey: comment,
        Item.selectedKey: selected,
        dealItemsKey: dealItems.map((e) => e.toMap()).toList(),
      };
  String get _signature {
    String _ = '';
    _ += id;
    _ += dealItems.length.toString();
    for (var item in dealItems) {
      _ += item.id;
    }
    return _;
  }

  @override
  List<Object?> get props {
    String _ = '';
    _ += id;
    _ += dealItems.length.toString();
    for (var item in dealItems) {
      _ += item.id;
    }
    return rowId == '' ? [_] : [rowId];
  }
}

class OnSpotDealItem extends Item with EquatableMixin {
  static const String _ChoiceKey = 'Choice';
  static const String _DealStepIdKey = 'DealStepId';

  final double? choice;
  final String? dealStepId;

  OnSpotDealItem(
      {String rowId = '0',
      String id = '0',
      String code = '0',
      String categoryId = '0',
      String name = '',
      double price = 0,
      double taxAmount = 0,
      double quantity = 0,
      this.choice = 0,
      this.dealStepId = '0',
      String image = '',
      bool selected = false})
      : super(
            rowId: rowId,
            id: id,
            code: code,
            categoryId: categoryId,
            name: name,
            price: price,
            taxAmount: taxAmount,
            quantity: quantity,
            image: image,
            selected: selected);

  OnSpotDealItem.fromMap(Map<String, dynamic> map)
      : choice = map[_ChoiceKey],
        dealStepId = map[_DealStepIdKey],
        super(
          rowId: map[Item.rowIdKey],
          id: map[Item.idKey],
          code: map[Item.codeKey],
          categoryId: map[Item.categoryIdKey],
          name: map[Item.nameKey],
          price: map[Item.priceKey],
          taxAmount: map[Item.taxAmountKey],
          quantity: map[Item.quantityKey],
          selected: map[Item.selectedKey],
          image: '',
        );

  OnSpotDealItem.modify(OnSpotDealItem item,
      {String? rowId,
      String? id,
      String? code,
      String? categoryId,
      String? name,
      double? price,
      double? taxAmount,
      double? quantity,
      String? image,
      String? comment,
      double? choice,
      String? dealStepId,
      bool? selected,
      bool? isAdditional})
      : this.choice = choice ?? item.choice,
        this.dealStepId = dealStepId ?? item.dealStepId,
        super(
            rowId: rowId ?? item.rowId,
            id: id ?? item.id,
            code: code ?? item.code,
            categoryId: categoryId ?? item.categoryId,
            name: name ?? item.name,
            price: price ?? item.price,
            taxAmount: taxAmount ?? item.taxAmount,
            quantity: quantity ?? item.quantity,
            image: image ?? item.image,
            comment: comment ?? item.comment,
            selected: selected ?? item.selected,
            isAdditional: isAdditional ?? item.isAdditional);

  @override
  Map<String, dynamic> toMap() => {
        Item.rowIdKey: rowId,
        Item.idKey: id,
        Item.codeKey: code,
        Item.categoryIdKey: categoryId,
        Item.nameKey: name,
        Item.priceKey: price,
        Item.quantityKey: quantity,
        Item.commentKey: comment,
        _ChoiceKey: choice,
        Item.selectedKey: selected,
      };

  @override
  List<Object?> get props => [id, code, quantity];
}

class DealStep {
  static const String _IdKey = 'Id', _NameKey = 'Name', _LimitKey = 'Limit';
  final String? id;
  final String? name;
  final String? limit;
  DealStep({
    this.id,
    this.name,
    this.limit,
  });
  DealStep.fromMap(Map<String, dynamic> map)
      : id = map[_IdKey],
        name = map[_NameKey],
        limit = map[_LimitKey];
}
