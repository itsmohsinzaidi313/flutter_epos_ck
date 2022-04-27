import 'dart:async';

import 'package:draggable_floating_button/draggable_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pos_app/bloc/items_menu_bloc/items_menu_bloc.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/pages/menu_page/menu_page.dart';
import 'package:pos_app/pages/menu_page/menu_page_arguments.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pos_app/shared/widgets/app_widgets.dart';

part 'item_search_widget.dart';
part 'menu_item_widget.dart';
part 'items_cart_widget.dart';
part 'cart_item_tile.dart';
part 'Items_menu_page_functions.dart';

class ItemsMenuPage extends StatefulWidget {
  static const String path = 'items_menu_page';

  @override
  State<ItemsMenuPage> createState() => _ItemsMenuPageState();
}

class _ItemsMenuPageState extends State<ItemsMenuPage>
    with SingleTickerProviderStateMixin {
  List<Tab> tabs = [];
  List<Widget> tabViews = [];
  final _autoCompleteController = TextEditingController(text: '');
  TabController _tabController;

  @override
  void dispose() {
    if (_tabController != null) _tabController.dispose();
    super.dispose();
  }

  Future<void> _onMenuItemPressed(List<Category> listCategories, Item e) async {
    if (e.code == Item.OPENFOOD_CODE.toString()) {
      openFoodDialog(context, e.categoryId).then((openItem) {
        if (openItem != null) {
          passEvent(context, AddOpenItem(openItem: openItem));
        }
      });
    } else if (e is OnSpotDeal) {
      final list = listCategories.where((element) {
        bool match = false;
        for (var i in e.dealItems) {
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
          categories: list, context: context, onSpotDeal: e);
      if (deal != null && deal.quantity > 0) {
        passEvent(
          context,
          AddOnSpotDeal(
            deal: deal,
          ),
        );
      }
    } else {
      passEvent(
        context,
        AddItem(
          code: e.code,
          itemId: int.parse(e.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    passEvent(context, ItemsMenuBuild());
    return BlocListener<ItemsMenuBloc, ItemsMenuState>(
      listener: (context, state) async {
        if (state is ErrorState) {
          AppTheme.snackbar(context, state.message);
        } else if (state is LoadedState && state.orderCompleted) {
          AppTheme.snackbar(context, state.message);
          Navigator.of(context).pushNamedAndRemoveUntil(
            MenuPage.path,
            (route) => false,
            arguments: MenuPageArgs(user: Config.user),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _ItemsSearchBar(
            autoCompleteController: _autoCompleteController,
            suggestionsCallback: (String phrase) async {
              if (phrase == '') return <Item>[];
              return MenuRepo.repo.searchItems(phrase);
            },
            onSuggestionSelected: (value) => passEvent(
              context,
              AddItem(
                code: (value as Item).code,
                itemId: int.parse((value as Item).id),
              ),
            ),
          ),
          actions: [
            BlocBuilder<ItemsMenuBloc, ItemsMenuState>(
              builder: (context, state) => Container(
                width: Config.getDeviceWidth(context) * 0.2,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Next'), Icon(Icons.arrow_forward)],
                  ),
                  onPressed: () => passEvent(context, PostOrder()),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: BlocBuilder<ItemsMenuBloc, ItemsMenuState>(
                      builder: (context, state) {
                        if (state is InitialState) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is LoadedState) {
                          if (tabs.isEmpty) {
                            tabs = state.menu.listCategories
                                .map((e) => Tab(text: e.name))
                                .toList();
                          }
                          if (tabViews.isEmpty) {
                            for (final Category category
                                in state.menu.listCategories) {
                              final List<Item> items = state.menu.listItems
                                  .where(
                                      (item) => item.categoryId == category.id)
                                  .toList();
                              tabViews.add(
                                GridView.count(
                                  crossAxisCount: 4,
                                  children: items
                                      .map(
                                        (e) => _ItemButton(
                                          item: e,
                                          onTap: () => _onMenuItemPressed(
                                              state.menu.listCategories, e),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }
                          }
                        }
                        if (_tabController == null) {
                          _tabController =
                              TabController(length: tabs.length, vsync: this);
                        }

                        return Column(
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
                              child: TabBar(
                                  controller: _tabController, tabs: tabs),
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
                            Flexible(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(top: 5),
                                child: TabBarView(
                                  controller: _tabController,
                                  children: tabViews,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: Config.getDeviceHeight(context),
                      // margin: const EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                        border: Border(
                          left: BorderSide(
                            width: 2,
                          ),
                          right: BorderSide(
                            width: 2,
                          ),
                          bottom: BorderSide(
                            width: 2,
                          ),
                          top: BorderSide(
                            width: 2,
                          ),
                        ),
                      ),
                      child: BlocBuilder<ItemsMenuBloc, ItemsMenuState>(
                        builder: (BuildContext context, ItemsMenuState state) {
                          String subtotal = '';
                          String totalAmount = '';
                          String taxAmount = '';
                          List<Item> cartItems = [];
                          if (state is InitialState) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is LoadedState) {
                            subtotal = state.subTotal;
                            taxAmount = state.taxAmount;
                            totalAmount = state.totalAmount;
                            cartItems = state.cartItems;
                          }
                          return _ItemsCart(
                            subTotal: subtotal,
                            taxAmount: taxAmount,
                            totalAmount: totalAmount,
                            items: cartItems,
                            onTap: _onCartItemTap,
                            onAddItem: _onAddItem,
                            onItemCommentChanged: _onItemCommentChanged,
                            onQuantityChanged: _onQuantityChanged,
                            onReduceItem: _onReduceItem,
                            onRemoveItem: _onRemoveItem,
                          );
                        },
                      ),
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
}
