import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/shared/widgets/app_widgets.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';

final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(32.0));
Future<OnSpotDeal> showOnSpotDealDialog(
        {BuildContext context,
        List<Category> categories,
        OnSpotDeal onSpotDeal}) async =>
    await showDialog<OnSpotDeal>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
        child: Container(
          width: Config.getDeviceWidth(context) * 0.8,
          height: Config.getDeviceHeight(context) * 0.8,
          child: OnSpotDealPage(
            categories: categories,
            deal: onSpotDeal,
          ),
        ),
      ),
    );

class OnSpotDealPage extends StatefulWidget {
  final List<Category> categories;
  final OnSpotDeal deal;
  OnSpotDealPage({this.deal, this.categories});
  @override
  _OnSpotDealPageState createState() => _OnSpotDealPageState();
}

class _OnSpotDealPageState extends State<OnSpotDealPage> {
  Category selectedCategory;
  List<OnSpotDealItem> chosenItems;
  int chosenCategoryItemCount(String categoryId) => chosenItems.length > 0
      ? chosenItems
          .where((element) => element.categoryId == categoryId)
          .toList()
          .length
      : 0;

  int categoryChoiceLimit(String categoryId) => widget.deal.dealItems
      .where((element) => element.categoryId == categoryId)
      .first
      .choice
      .toInt();

  List<OnSpotDealItem> chosenCategoryItems(String categoryId) =>
      chosenItems.length > 0
          ? chosenItems
              .where((element) => element.categoryId == categoryId)
              .toList()
          : [];

  double chosenCategoryItemsQuantity(String categoryId) {
    double quantity = 0;
    for (var item in chosenItems) {
      if (item.categoryId == categoryId) quantity += item.quantity;
    }
    return quantity;
  }

  List<OnSpotDealItem> categoryItems(String categoryId) => widget.deal.dealItems
      .where((element) => element.categoryId == categoryId)
      .toList();

  OnSpotDealItem chosenItem(String itemId, OnSpotDealItem dealItem) =>
      chosenItems.firstWhere((element) => element.id == itemId,
          orElse: () => OnSpotDealItem.fromItem(dealItem));

  List<OnSpotDealItem> fixedItems() {
    List<OnSpotDealItem> list = [];
    for (var item in widget.deal.dealItems) {
      if (item.choice == 0) {
        list.add(OnSpotDealItem.fromItem(item));
      }
    }
    return list;
  }

  @override
  void initState() {
    for (var item in widget.categories) {
      item.selected = false;
    }
    widget.categories.first.selected = true;
    selectedCategory = widget.categories.first;
    chosenItems = [];
    chosenItems.addAll(fixedItems());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // borderRadius: _borderRadius,
      floatingActionButton: FloatingActionButton(
        heroTag: '0',
        child: Icon(Icons.check),
        onPressed: () {
          createDeal(chosenItems);
        },
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Categories'.toUpperCase(),
                            style: GoogleFonts.staatliches(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5.0,
                            ),
                          ),
                        ),
                        Container(
                          height: Config.getDeviceHeight(context) * 0.12,
                          padding: EdgeInsets.only(top: 5),
                          // decoration: BoxDecoration(border: Border.all(width: 2)),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: widget.categories
                                .map(
                                  (e) => categoryButton(
                                      context: context,
                                      category: e,
                                      onTap: () => setState(
                                            () {
                                              for (var cat
                                                  in widget.categories) {
                                                cat.selected = false;
                                              }
                                              e.selected = true;
                                              selectedCategory = e;
                                              selectedCategory.choiceLimit =
                                                  widget.deal.dealItems
                                                      .firstWhere((element) =>
                                                          element.categoryId ==
                                                          e.id)
                                                      .choice;
                                            },
                                          ),
                                      text:
                                          ' (${chosenCategoryItemCount(e.id)}|${categoryChoiceLimit(e.id)})'),
                                )
                                .toList(),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Items'.toUpperCase(),
                            style: GoogleFonts.staatliches(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 5.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 5),
                            child: GridView.count(
                              crossAxisCount: 5,
                              children: widget.deal.dealItems
                                  .where((element) =>
                                      element.categoryId == selectedCategory.id)
                                  .map(
                                    (e) => itemButton2(
                                      item: e,
                                      selected: chosenItem(e.id, e).selected,
                                      subtitle:
                                          '(${chosenItem(e.id, e).quantity.toInt()}|${categoryChoiceLimit(e.categoryId)})',
                                      showSubtitle: true,
                                      isSelectable: true,
                                      onTap: () {
                                        if (e.choice != 0) {
                                          setState(
                                            () => _addItem(
                                              selectedCategory,
                                              chosenItem(e.id, e),
                                            ),
                                          );
                                        } else {
                                          AppTheme.snackbar(
                                            context,
                                            'This is a Fixed item. It cannot be removed.',
                                            duration: 1,
                                          );
                                        }
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addItem(Category category, OnSpotDealItem dealItem) {
    double quantity = 0, limit = 0;
    bool itemExists = false;

    final list = categoryItems(category.id);
    final list2 = chosenCategoryItems(category.id);

    limit = list.first.choice;
    for (var item in list2) {
      quantity += item.quantity;
      if (item.id == dealItem.id) itemExists = true;
    }

    if (quantity < limit) {
      if (list2.isEmpty) {
        dealItem.selected = true;
        dealItem.quantity = 1;
        chosenItems.add(dealItem);
      } else {
        if (itemExists) {
          dealItem.quantity++;
        } else {
          dealItem.selected = true;
          dealItem.quantity = 1;
          chosenItems.add(dealItem);
        }
      }
    } else {
      chosenItems.remove(chosenItem(dealItem.id, dealItem));
      dealItem.selected = false;
      dealItem.quantity = 0;
    }
  }

  void createDeal(List<OnSpotDealItem> chosenItems) {
    double limit = 0;
    double totalQuantity = 0;
    for (var category in widget.categories) {
      limit += categoryChoiceLimit(category.id);
      totalQuantity += chosenCategoryItemsQuantity(category.id);
    }
    if (limit != totalQuantity) {
      AppTheme.snackbar(context, 'Deal was not complete therefore is cancled.');
      final deal = OnSpotDeal.fromOnSpotDeal(widget.deal);
      deal.quantity = 0;
      Navigator.of(context).pop(deal);
    } else {
      Navigator.of(context).pop(OnSpotDeal.newDeal(widget.deal, chosenItems));
    }
  }
}
