import 'package:draggable_floating_button/draggable_floating_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/repositories/menu_items_repository.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pos_app/pages/widgets/app_widgets.dart';

class PosScreen extends StatelessWidget {
  // final subTotal = TextEditingController();
  // final taxAmount = TextEditingController();
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
  final _listKey = GlobalKey<AnimatedListState>();
  final _cartKey = GlobalKey<AnimatedListState>();
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
                    // Top bar for table and waiters
                    // Container(
                    //   color: Colors.red,
                    //   child: Row(
                    //     children: [
                    //       Flexible(
                    //         flex: 1,
                    //         child: ListTile(
                    //           leading: Container(
                    //             padding: EdgeInsets.all(5),
                    //             decoration: BoxDecoration(
                    //               color: Colors.red,
                    //               shape: BoxShape.rectangle,
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //             child: Text(
                    //               '',
                    //               style: TextStyle(
                    //                   color: Colors.grey[600],
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ),
                    //           title: Container(
                    //             padding: EdgeInsets.all(5),
                    //             decoration: BoxDecoration(
                    //               color: Colors.red,
                    //               shape: BoxShape.rectangle,
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //             child: Center(
                    //               child: Text('',
                    //                   style: TextStyle(
                    //                       color: Colors.grey[600],
                    //                       fontWeight: FontWeight.bold)),
                    //             ),
                    //           ),
                    //           trailing: Container(
                    //             padding: EdgeInsets.all(5),
                    //             decoration: BoxDecoration(
                    //               color: Colors.red,
                    //               shape: BoxShape.rectangle,
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //             child: Text('',
                    //                 style: TextStyle(
                    //                     color: Colors.grey[600],
                    //                     fontWeight: FontWeight.bold)),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                                  height:
                                      Config.getDeviceHeight(context) * 0.12,
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
                                      List<Category> list = [];
                                      Future f = Future(() {});
                                      if (state is CategoriesLoaded) {
                                        //   state.list.forEach((element) {
                                        //     f = f.then((value) => Future.delayed(
                                        //             Duration(milliseconds: 50),
                                        //             () {
                                        //           list.add(element);
                                        //           _listKey.currentState
                                        //               .insertItem(
                                        //                   list.length - 1);
                                        //         }));
                                        //   });
                                        // }
                                        // Tween<Offset> _offset = Tween(
                                        //     begin: Offset(0, -1),
                                        //     end: Offset(0, 0));
                                        // return AnimatedList(
                                        //   key: _listKey,
                                        //   scrollDirection: Axis.horizontal,
                                        //   initialItemCount: list.length,
                                        //   itemBuilder:
                                        //       (context, index, animation) =>
                                        //           SlideTransition(
                                        //     position: animation.drive(_offset),
                                        //     child: categoryButton(
                                        //       context,
                                        //       list,
                                        //       index,
                                        //     ),
                                        //   ),
                                        // );

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
                                              children: getItemsWidgets(
                                                  context, state.list),
                                            );
                                          } else {
                                            return AppTheme.progIndicator;
                                          }
                                        },
                                      )),
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
                                      if (state.list.length < 1) {
                                        return Container(
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              // scale: 10,
                                              image: AssetImage(
                                                'assets/empty_cart.png',
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'Subtotal'
                                                              .toUpperCase(),
                                                          style: titleStyle,
                                                        ),
                                                        Text(
                                                          subTotal,
                                                          style: textStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'Tax'.toUpperCase(),
                                                          style: titleStyle,
                                                        ),
                                                        Text(
                                                          taxAmount,
                                                          style: textStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'Total'.toUpperCase(),
                                                          style: titleStyle,
                                                        ),
                                                        Text(
                                                          totalAmount,
                                                          style: textStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(),
                                            Expanded(
                                              child: ListView(
                                                children: getCartItemsWidgets(
                                                    context, state.list),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    } else {
                                      return AppTheme.progIndicator;
                                    }
                                  },
                                )),
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
        ));
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool type = await AppTheme.showAlertDialogYNFutureReturn(
      context,
      title: 'Question?',
      message: 'Are you sure?',
    );

    if (type) {
      if (true) {
        Navigator.pop(context);
        return true;
      } else {
        Navigator.pop(context);
        return false;
      }
    } else {
      return false;
    }
  }

  // CREATES CATEGORY WIDGETS
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

  // CREATE ITEMS WIDGETS
  List<Widget> getItemsWidgets(BuildContext context, List<MenuItem> lstItem) =>
      lstItem
          .map(
            (item) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              // color: Colors.redAccent,
              child: InkWell(
                  onTap: () {
                    if (item.code == MenuItem.OPENFOOD_CODE.toString()) {
                      openFoodDialog(context, item.categoryId).then((openItem) {
                        if (openItem != null) {
                          passEvent(context, AddOpenItem(openItem: openItem));
                        }
                      });
                    } else {
                      passEvent(
                        context,
                        AddItem(
                          code: int.parse(item.code),
                          itemId: int.parse(item.id),
                        ),
                      );
                    }
                  },
                  child: itemButton2(context, item)),
            ),
          )
          .toList() ??
      [AppTheme.progIndicator];

  // CREATES CART ITEMS
  List<Widget> getCartItemsWidgets(
          BuildContext context, List<MenuItem> lstItem) =>
      lstItem.map((item) {
        final controller =
            TextEditingController(text: item.quantity.toString());
        controller.selection = TextSelection(
            baseOffset: item.quantity.toString().length,
            extentOffset: item.quantity.toString().length);
        return Card(
          elevation: 4,
          child: ListTile(
            // leading: CircleAvatar(
            //   backgroundColor: Colors.yellow.shade700,
            //   radius: 16,
            //   child: CircleAvatar(
            //     radius: 14,
            //     backgroundImage: AssetImage('assets/no_image1.jpg'),
            //   ),
            // ),
            title: Text(
              item.name.toUpperCase(),
              style: GoogleFonts.ubuntuCondensed(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                wordSpacing: 0.5,
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  ' ${double.parse(item.price).toInt().toString()} x ${item.quantity} '
                  '= ${(double.parse(item.price).toInt() * item.quantity).toString()}',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                      onPressed: () => passEvent(
                          context,
                          ReduceItem(
                              code: int.parse(item.code),
                              itemId: int.parse(item.id))),
                    ),
                    // Text(
                    //   item.quantity.toString(),
                    //   style: TextStyle(
                    //     color: Colors.grey.shade900,
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Container(
                      width: Config.getDeviceWidth(context) * 0.05,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onSubmitted: (value) => context
                                  .read<POSBloc>()
                                  .add(
                                    ItemQuantityChanged(
                                      code: int.tryParse(item.code),
                                      itemId: int.parse(item.id),
                                      quantity: double.tryParse(value) ?? 0.0,
                                    ),
                                  ),
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                              ),
                              controller: controller,
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.red,
                      ),
                      onPressed: () => passEvent(
                        context,
                        AddItem(
                          code: int.parse(item.code),
                          itemId: int.parse(item.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isThreeLine: true,
            trailing: SizedBox(
              width: 96,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.red.shade800,
                      size: 22,
                    ),
                    onPressed: () async {
                      String comments =
                          await openItemCommentDialog(context, item.name);
                      passEvent(
                          context,
                          AddComment(
                              code: int.parse(item.code),
                              itemId: int.parse(item.id),
                              comment: comments));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.yellow.shade800,
                      size: 22,
                    ),
                    onPressed: () => passEvent(
                      context,
                      RemoveItem(
                        code: int.parse(item.code),
                        itemId: int.parse(item.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList() ??
      [];

  void passEvent(BuildContext context, POSEvents event) =>
      context.read<POSBloc>().add(event);

  Widget autoCompleteSearchBar(BuildContext context) {
    return TypeAheadField(
      hideOnEmpty: true,
      textFieldConfiguration: TextFieldConfiguration(
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
      suggestionsCallback: (pattern) async {
        List<MenuItem> list = [];
        if (pattern != '') {
          final serverResponse =
              await MenuItemRepo.repo.searchItems(phrase: pattern);
          if (serverResponse.status) {
            for (var item in (serverResponse.data as List)) {
              list.add(MenuItem.fromJson(item));
            }
          }
        }
        return list;
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
          code: int.parse((suggestion as MenuItem).code),
          itemId: int.parse((suggestion as MenuItem).id),
        ),
      ),
      noItemsFoundBuilder: (context) => ListTile(
        title: Text('No Item Found!'),
      ),
    );
  }
}
