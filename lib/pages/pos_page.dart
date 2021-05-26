import 'package:draggable_floating_button/draggable_floating_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import '../shared/app_theme.dart';
import '../shared/config.dart';
import 'package:google_fonts/google_fonts.dart';

class PosScreen extends StatelessWidget {
  final totalAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    context.read<POSBloc>().add(POSBuild());
    return BlocListener<POSBloc, POSState>(
        listener: (context, state) async {
          if (state is SubmissionInvalid) {
            AppTheme.snackbar(context, state.message);
          } else if (state is SubmissionValid) {
          } else if (state is CartItems) {
            totalAmount.text = state.totalAmount;
          } else if (state is POSLoading) {
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
          appBar: AppTheme.appBarNormal(
            context: context,
            appBarTitle: 'Menu',
            appBarElevation: 0.0,
            appBarBgColor: AppTheme.appBarColor,
          ),
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
                                    )),
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
                                                    child: TextField(
                                                      controller:
                                                          TextEditingController(
                                                              text: 'Amount: '),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: TextField(
                                                      controller: totalAmount,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // RichText(
                                            //   text: TextSpan(
                                            //     text: 'Tax Amount: ',
                                            //     style: TextStyle(
                                            //       color: Colors.grey,
                                            //       fontSize: 16,
                                            //       letterSpacing: 0,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //     children: <TextSpan>[
                                            //       TextSpan(
                                            //         text: '${states.totalCartTaxAmount.toString()}',
                                            //         style: TextStyle(
                                            //           color: Colors.black,
                                            //           fontSize: 18,
                                            //           letterSpacing: 1,
                                            //           fontWeight: FontWeight.bold,
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            Expanded(
                                              child: ListView(
                                                children:
                                                    getCartItemsNewWidgets(
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
                offset: new Offset(
                  Config.getDeviceWidth(context) * 0.91,
                  Config.getDeviceHeight(context) * 0.72,
                ),
                child: Icon(
                  Icons.done_rounded,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () => context.read<POSBloc>().add(PostOrder()),
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
                    onTap: () => context
                        .read<POSBloc>()
                        .add(CategoryChanged(categoryId: category.id)),
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
                          height: Config.getDeviceHeight(context) * 0.1,
                          width: Config.getDeviceHeight(context) * 0.18,
                          color: category.selected
                              ? Colors.redAccent[200]
                              : Colors.white,
                          child: Center(
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
              color: Colors.white,
              child: InkWell(
                onTap: () => context
                    .read<POSBloc>()
                    .add(AddItem(itemId: int.parse(item.id))),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        height: Config.getDeviceHeight(context) * 0.2,
                        width: Config.getDeviceWidth(context) * 0.159,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: item.image != null
                                ? NetworkImage(item.image)
                                : AssetImage('assets/no_image1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    item.image == null
                        ? Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No Image'.toUpperCase(),
                              style: GoogleFonts.anton(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 15, bottom: 8, left: 8, right: 8),
                        height: Config.getDeviceHeight(context) * 0.094,
                        width: Config.getDeviceWidth(context) * 0.158,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.name.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.ubuntuCondensed(
                                      color: Colors.grey.shade800,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                      wordSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'PKR ${double.parse(item.price).toInt().toString()}',
                                      style: GoogleFonts.ubuntuCondensed(
                                        color: Colors.red.shade500,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        wordSpacing: 1.0,
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.star,
                                    //       size: 10,
                                    //       color: Colors.yellow.shade900,
                                    //     ),
                                    //     Icon(
                                    //       Icons.star,
                                    //       size: 10,
                                    //       color: Colors.yellow.shade900,
                                    //     ),
                                    //     Icon(
                                    //       Icons.star_half_outlined,
                                    //       size: 10,
                                    //       color: Colors.yellow.shade900,
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList() ??
      [AppTheme.progIndicator];

  // CREATES CART ITEMS
  List<Widget> getCartItemsWidgets(
          BuildContext context, List<MenuItem> lstItem) =>
      lstItem
          .map((item) => GestureDetector(
                onTap: () {},
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow.shade700,
                      radius: 16,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundImage: item.image != null
                            ? NetworkImage(item.image)
                            : AssetImage('assets/no_image1.jpg'),
                      ),
                    ),
                    title: Text(
                      item.name.toUpperCase(),
                      style: GoogleFonts.ubuntuCondensed(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        wordSpacing: 0.5,
                      ),
                    ),
                    subtitle: Text(
                      ' ${double.parse(item.price).toInt().toString()} x ${item.quantity.toString()} '
                      '= ${(double.parse(item.price).toInt() * item.quantity).toString()}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 10,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.yellow.shade800,
                        size: 20,
                      ),
                      onPressed: () => context
                          .read<POSBloc>()
                          .add(RemoveItem(itemId: int.parse(item.id))),
                    ),
                  ),
                ),
              ))
          .toList() ??
      [];

  List<Widget> getCartItemsNewWidgets(
          BuildContext context, List<MenuItem> lstItem) =>
      lstItem
          .map((item) => Card(
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
                            onPressed: () {
                              context
                                  .read<POSBloc>()
                                  .add(ReduceItem(itemId: int.parse(item.id)));
                            },
                          ),
                          Text(
                            item.quantity.toString(),
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.red,
                            ),
                            onPressed: () => context
                                .read<POSBloc>()
                                .add(AddItem(itemId: int.parse(item.id))),
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
                            String comments = item.comment;

                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: Text('Comments'),
                                  content: ListTile(
                                    leading: Icon(
                                      Icons.edit,
                                      color: Colors.redAccent,
                                    ),
                                    title: TextField(
                                      controller:
                                          TextEditingController(text: comments),
                                      onChanged: (value) => comments = value,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Ok'),
                                    ),
                                  ]),
                            );
                            item.comment = comments;
                            context.read<POSBloc>().add(AddComment(
                                itemId: int.parse(item.id), comment: comments));
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.yellow.shade800,
                            size: 22,
                          ),
                          onPressed: () => context
                              .read<POSBloc>()
                              .add(RemoveItem(itemId: int.parse(item.id))),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList() ??
      [];
}
