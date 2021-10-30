import 'dart:convert';
import 'dart:io';

import 'package:draggable_floating_button/draggable_floating_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pos_app/pages/widgets/app_widgets.dart';

class PosScreen extends StatefulWidget {
  // final subTotal = TextEditingController();
  // final taxAmount = TextEditingController();
  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen>
    with SingleTickerProviderStateMixin {
  String subTotal = '';
  String taxAmount = '';
  String totalAmount = '';
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
    passEvent(context, POSBuild());
    return BlocListener<POSBloc, POSState>(
      listener: (context, state) async {
        if (state is SubmissionInvalid) {
          AppTheme.snackbar(context, state.message);
        } else if (state is SubmissionValid) {
        } else if (state is CartItems) {
          subTotal = state.subTotal;
          taxAmount = state.taxAmount;
          totalAmount = ((double.tryParse(state.subTotal) ?? 0) +
                  (double.tryParse(state.taxAmount) ?? 0))
              .toStringAsFixed(2);
        } else if (state is POSLoading) {
          AppTheme.snackbar(context, state.message);
        } else if (state is POSError) {
          await AppTheme.showAlertDialogOK(context,
              message: state.message,
              title: 'Error',
              onOK: () => Navigator.of(context).pop());
        } else if (state is OrderPostFailed) {
          await AppTheme.showAlertDialogOK(context,
              message: state.message,
              title: 'Failed',
              onOK: () => Navigator.of(context).pop());
        } else if (state is OrderPosted) {
          AppTheme.snackbar(context, state.message);

          Navigator.of(context)
              .pushNamedAndRemoveUntil('/menu', (route) => false);
        } else if (state is OrderUpdated) {
          AppTheme.snackbar(context, state.message);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
        // AppTheme.appBarNormal(
        //   context: context,
        //   appBarTitle: 'Menu',
        //   appBarElevation: 0.0,
        //   appBarBgColor: AppTheme.appBarColor,
        // ),
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
                                child: BlocBuilder<POSBloc, POSState>(
                                  buildWhen: (previous, current) {
                                    if (current is CategoriesLoaded) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is CategoriesLoaded) {
                                      return ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: getCategoryWidgets(
                                            context, state.list),
                                      );
                                    } else {
                                      return AppTheme.progIndicator;
                                    }
                                  },
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
                                  child: BlocBuilder<POSBloc, POSState>(
                                    buildWhen: (previous, current) {
                                      if (current is ItemsLoaded) {
                                        return true;
                                      } else {
                                        return false;
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is ItemsLoaded) {
                                        return GridView.count(
                                          crossAxisCount: 4,
                                          children: _getItemsWidgets(context,
                                              state.items, state.categories),
                                        );
                                      } else {
                                        return AppTheme.progIndicator;
                                      }
                                    },
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
                            child: BlocBuilder<POSBloc, POSState>(
                              buildWhen: (previous, current) {
                                if (current is CartItems) {
                                  return true;
                                } else {
                                  return false;
                                }
                              },
                              builder: (context, state) {
                                if (state is CartItems) {
                                  return _getCartWidget(context, state.list);
                                } else {
                                  return AppTheme.progIndicator;
                                }
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
              onPressed: () => passEvent(context, PostOrder()),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getCategoryWidgets(
          BuildContext context, List<Category> lstCategory) =>
      lstCategory
          .map((category) => Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: category.selected ? Colors.redAccent[200] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => passEvent(
                      context,
                      CategoryChanged(categoryId: category.id),
                    ),
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

  List<Widget> _getItemsWidgets(
          BuildContext context, List<Item> items, List<Category> categories) =>
      items
          .map(
            (item) => ItemButton(
              item: item,
              onTap: () async {
                if (item.code == Item.OPENFOOD_CODE.toString()) {
                  openFoodDialog(context, item.categoryId).then((openItem) {
                    if (openItem != null) {
                      passEvent(context, AddOpenItem(openItem: openItem));
                    }
                  });
                } else if (item is OnSpotDeal) {
                  final list = categories.where((element) {
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
                      code: item.code,
                      itemId: int.parse(item.id),
                    ),
                  );
                }
                return true;
              },
            ),
          )
          .toList() ??
      [AppTheme.progIndicator];

  Widget _getCartWidget(BuildContext context, List<Item> items) => cartWidget(
        context: context,
        subTotal: subTotal,
        taxAmount: taxAmount,
        totalAmount: totalAmount,
        items: items,
        onReduceItem: (item) {
          if (item is OnSpotDeal) {
            passEvent(context, ReduceOnSpotDeal(deal: item));
          } else {
            passEvent(
              context,
              ReduceItem(
                code: item.code,
                itemId: int.parse(item.id),
              ),
            );
          }
        },
        onAddItem: (item) {
          if (item is OnSpotDeal) {
            passEvent(context, AddOnSpotDeal(deal: item));
          } else {
            passEvent(
              context,
              AddItem(
                code: item.code,
                itemId: int.parse(item.id),
              ),
            );
          }
        },
        onQuantityChanged: (item, value) {
          if (item is OnSpotDeal) {
            passEvent(
                context,
                OnSpotDealQuantityChanged(
                    deal: item, quantity: int.tryParse(value) ?? 0.0));
          } else {
            passEvent(
              context,
              ItemQuantityChanged(
                code: item.code,
                itemId: int.parse(item.id),
                quantity: double.tryParse(value) ?? 0.0,
              ),
            );
          }
        },
        onRemoveItem: (item) {
          if (item is OnSpotDeal) {
            passEvent(context, RemoveOnSpotDeal(deal: item));
          } else {
            passEvent(
              context,
              RemoveItem(
                code: item.code,
                itemId: int.parse(item.id),
              ),
            );
          }
        },
        onItemCommentPressed: (item) async {
          String comments = await openItemCommentDialog(context, item.name);
          passEvent(
              context,
              AddComment(
                  code: item.code,
                  itemId: int.parse(item.id),
                  comment: comments));
        },
      );

  void passEvent(BuildContext context, POSEvents event) =>
      context.read<POSBloc>().add(event);

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
      onSuggestionSelected: (suggestion) => passEvent(
        context,
        AddItem(
          code: (suggestion as Item).code,
          itemId: int.parse((suggestion as Item).id),
        ),
      ),
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
