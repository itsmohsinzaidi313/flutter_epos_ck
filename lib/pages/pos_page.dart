import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:draggable_floating_button/draggable_floating_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/models/menu.dart';
import 'package:pos_app/pages/backend/pos_backend.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pos_app/pages/widgets/app_widgets.dart';
import 'package:provider/provider.dart';

class PosPage extends StatelessWidget {
  final _autoCompleteController = TextEditingController(text: '');
  final TextStyle titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  final TextStyle textStyle = TextStyle(
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, double.maxFinite),
        child: CustomAppBar(
          appBarTitle: 'Choose you items',
          searchBar: autoCompleteSearchBar(context),
          radioButtons: SizedBox(),
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
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
                                  color: Colors.grey[500],
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
                              child: Consumer<POSMenu>(
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Items'.toUpperCase(),
                                style: GoogleFonts.staatliches(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 5.0,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(top: 5),
                                // decoration: BoxDecoration(border: Border.all(width: 2)),
                                child: GridView.count(
                                  crossAxisCount: 4,
                                  children: _getItemsWidgets(
                                    context,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: Config.getDeviceHeight(context),
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                              right: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                              top: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                            ),
                          ),
                          child: _getCartWidget(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DraggableFloatingActionButton(
            backgroundColor: Colors.red,
            elevation: 5,
            tooltip: 'Submit Order',
            appContext: context,
            appBar: AppTheme.appBarNormal(
              context: context,
              appBarTitle: 'Menu',
              appBarElevation: 0.0,
              appBarBgColor: AppTheme.appBarColor,
            ),
            offset: Offset(
              Config.getDeviceWidth(context) * 0.91,
              Config.getDeviceHeight(context) * 0.72,
            ),
            child: Icon(
              Icons.done_rounded,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () =>
                POSBackend.instance.postOrder(context.read<Order>()),
          ),
        ],
      ),
    );
  }

  List<Widget> getCategoryWidgets(BuildContext context) =>
      context
          .watch<POSMenu>()
          .listCategories
          .map((category) => Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: category.selected ? Colors.redAccent[200] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      context.read<POSMenu>().setSelectedCategory(category);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.yellow.shade700,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 13,
                            child: CircleAvatar(
                              backgroundColor: category.selected
                                  ? Colors.grey.shade700
                                  : Colors.white,
                              radius: 9,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          color: category.selected
                              ? Colors.redAccent[200]
                              : Colors.white,
                          child: Text(
                            category.name.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntuCondensed(
                              color: category.selected
                                  ? Colors.white
                                  : Colors.red.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              wordSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList() ??
      [AppTheme.progIndicator];

  List<Widget> _getItemsWidgets(BuildContext context) =>
      context
          .watch<POSMenu>()
          .listItems
          .map(
            (item) => ItemButton(
              item: item,
              onTap: () async {
                if (item.code == Item.openFoodCode.toString()) {
                  var openItem = await openFoodDialog(context, item.categoryId);
                  if (openItem != null) {
                    context.read<Order>().addCartItem(openItem);
                  }
                } else if (item is OnSpotDeal) {
                  final list =
                      context.read<POSMenu>().listCategories.where((element) {
                    bool match = false;
                    for (var i in item.dealItems) {
                      if (i.choice == 0.0) {
                        i.selected = true;
                      } else {
                        i.selected = false;
                      }
                      i.quantity = 0;
                      if (i.categoryId == element.id) {
                        element.choiceLimit = i.choice;
                        match = true;
                      }
                    }
                    return match;
                  }).toList();
                  final deal = await showOnSpotDealDialog(
                      categories: list, context: context, onSpotDeal: item);
                  if (deal != null && deal.quantity > 0) {
                    context.read<Order>().addCartItem(deal);
                  }
                } else {
                  context.read<Order>().addCartItem(item);
                }
                return true;
              },
            ),
          )
          .toList() ??
      [AppTheme.progIndicator];

  Widget _getCartWidget(BuildContext context) {
    return cartWidget(
      context: context,
      subTotal: context.watch<Order>().subTotal,
      taxAmount: context.watch<Order>().totalTax,
      totalAmount: context.watch<Order>().totalTaxAmount,
      items: context.watch<Order>().items,
      onReduceItem: context.read<Order>().reduceCartItem,
      onAddItem: context.read<Order>().addCartItem,
      onQuantityChanged: context.read<Order>().setItemQuantity,
      onRemoveItem: context.read<Order>().removeItem,
      onItemCommentPressed: (item) async {
        String comments = await openItemCommentDialog(context, item.name);
        context.read<Order>().addItemComment(item, comments);
      },
    );
  }

  Widget autoCompleteSearchBar(BuildContext context) {
    return TypeAheadField(
      hideOnEmpty: true,
      textFieldConfiguration: TextFieldConfiguration(
        controller: _autoCompleteController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Search by item name here',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
            ),
            onPressed: () => _autoCompleteController.text = '',
          ),
        ),
      ),
      suggestionsCallback: (phrase) async {
        return itemsSearch(phrase);
      },
      itemBuilder: (context, itemData) {
        return ListTile(
          title: Text(itemData.name),
          subtitle: Text(
            'PKR: ${itemData.price}/=\nCode: ${itemData.id}',
          ),
        );
      },
      onSuggestionSelected: (suggestion) =>
          context.read<Order>().addCartItem(suggestion),
      noItemsFoundBuilder: (context) => ListTile(
        title: Text('No Item Found!'),
      ),
    );
  }
}

Future<List<Item>> itemsSearch(String phrase) async {
  if (phrase == '') return <Item>[];
  return MenuRepo.repo.searchItems(phrase);
}
