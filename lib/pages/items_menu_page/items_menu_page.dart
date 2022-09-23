import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pos_app/bloc/items_menu_bloc/items_menu_bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/models/items_cart.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/pages/menu_page/menu_page.dart';
import 'package:pos_app/pages/menu_page/menu_page_arguments.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pos_app/shared/enums.dart';
import 'package:pos_app/shared/widgets/app_widgets.dart';

part 'item_search_widget.dart';
part 'menu_item_widget.dart';
part 'items_cart_widget.dart';
part 'cart_item_tile.dart';
part 'Items_menu_page_functions.dart';
part 'on_spot_deal_dialog.dart';

class ItemsMenuPage extends StatefulWidget {
  static const String path = 'items_menu_page';

  @override
  State<ItemsMenuPage> createState() => _ItemsMenuPageState();
}

class _ItemsMenuPageState extends State<ItemsMenuPage>
    with SingleTickerProviderStateMixin {
  List<Tab> tabs = [];
  List<Widget> tabViews = [];
  OrderType orderType = OrderType.dineIn;
  final _autoCompleteController = TextEditingController(text: '');
  TabController? _tabController;

  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _passEvent(context, ItemsMenuBuild());
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
            onSuggestionSelected: (value) => _onSuggestionSelected(
              context,
              value,
            ),
          ),
          actions: [
            BlocBuilder<ItemsMenuBloc, ItemsMenuState>(
              builder: (context, state) => Container(
                width: Config.getDeviceWidth(context) * 0.2,
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      )
                    ],
                  ),
                  onPressed: () => _onNextPressed(context),
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
                        } else if (state is LoadingState) {
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
                                            context,
                                            state.menu.listCategories,
                                            e,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }
                          }
                        }
                        if (_tabController == null) {
                          _tabController = TabController(
                            length: tabs.length,
                            vsync: this,
                          );
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
                                controller: _tabController,
                                tabs: tabs,
                                isScrollable: true,
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
                          Order order = Order(cart: ItemsCart(items: []));
                          String subtotal = '';
                          String totalAmount = '';
                          String taxAmount = '';
                          if (state is InitialState) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is LoadedState) {
                            subtotal = state.subTotal;
                            taxAmount = state.taxAmount;
                            totalAmount = state.totalAmount;
                            order = state.order;
                          }
                          return _ItemsCart(
                            subTotal: subtotal,
                            taxAmount: taxAmount,
                            totalAmount: totalAmount,
                            itemsCart: order.cart,
                            onTap: (context, i) => _onCartItemTap(context, i),
                            onIncreaseItem: (context, i) =>
                                _onIncreaseItem(context, i),
                            onItemCommentChanged: (
                              context,
                              comment,
                              i,
                            ) =>
                                _onItemCommentChanged(context, comment, i),
                            onReduceItem: (context, i) =>
                                _onReduceItem(context, i),
                            onRemoveItem: (context, i) =>
                                _onRemoveItem(context, i),
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
