import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/models/customer_table.dart' as t;
import 'package:google_fonts/google_fonts.dart';

import 'widgets/app_widgets.dart';

class OrderInfoScreen extends StatelessWidget {
  final ImageProvider dineIn = AssetImage('assets/dine_in.jpg'),
      takeAway = AssetImage('assets/takeaway.jpg'),
      delivery = AssetImage('assets/delivery.jpg');

  final dineInOrdertype = ORDERTYPE.DINE_IN;
  final takeAwayOrderType = ORDERTYPE.TAKE_AWAY;
  final deliveryOrderType = ORDERTYPE.DELIVERY;

  final Widget dineInLayout = DineInLayout();
  final Widget takeAwayLayout = TakeAwayLayout();
  final Widget deliveryLayout = DeliveryLayout();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderInfoBloc, OrderInfoState>(
        listener: (context, state) async {
          if (state is ValidSubmission) {
            Navigator.of(context)
                .pushNamed('/pos', arguments: state.customerOrder);
          } else if (state is OrderInfoError) {
            AppTheme.snackbar(context, state.message, textColor: Colors.red);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppTheme.appBarNormal(
              appBarTitle: 'Order Type',
              appBarBgColor: AppTheme.appBarColor,
              appBarElevation: 0.0,
              context: context),
          body: Container(
            height: Config.getDeviceHeight(context),
            width: Config.getDeviceWidth(context),
            child: Row(
              children: [
                Expanded(
                    child: BlocBuilder<OrderInfoBloc, OrderInfoState>(
                  buildWhen: (previous, current) {
                    if (previous.orderType != current.orderType) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    switch (state.orderType) {
                      case ORDERTYPE.DINE_IN:
                        return dineInLayout;
                        break;
                      case ORDERTYPE.TAKE_AWAY:
                        return takeAwayLayout;
                        break;
                      case ORDERTYPE.DELIVERY:
                        return deliveryLayout;
                        break;
                      default:
                        return Container();
                        break;
                    }
                  },
                )),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Config.allowDineIn
                              ? orderTypeButton(
                                  context,
                                  'Dine-In',
                                  () => passEvent(context,
                                      OrderTypeChanged(type: dineInOrdertype)),
                                  dineIn)
                              : Container(),
                          Config.allowTakeAway
                              ? orderTypeButton(
                                  context,
                                  'Takeaway',
                                  () => passEvent(
                                      context,
                                      OrderTypeChanged(
                                          type: takeAwayOrderType)),
                                  takeAway)
                              : Container(),
                          Config.allowDelivery
                              ? orderTypeButton(
                                  context,
                                  'Delivery',
                                  () => passEvent(
                                      context,
                                      OrderTypeChanged(
                                          type: deliveryOrderType)),
                                  delivery)
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void passEvent(BuildContext c, OrderInfoEvent event) =>
      c.read<OrderInfoBloc>().add(event);
}

class DineInLayout extends StatelessWidget {
  final orderType = ORDERTYPE.DINE_IN;

  DineInLayout();
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderInfoBloc, OrderInfoState>(
      listenWhen: (previous, current) {
        if (current.orderType != null && current.orderType == orderType) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        if (state is WaitersState) {
        } else if (state is TablesState) {
        } else if (state is InvalidCovers) {
          AppTheme.snackbar(context, state.message);
        } else if (state is InvalidTables) {
          AppTheme.snackbar(context, state.message);
        } else if (state is InvalidWaiter) {
          AppTheme.snackbar(context, state.message);
        }
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Card(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ListTile(
                        title: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade200,
                            border: Border(
                              left: BorderSide(
                                color: Colors.yellow.shade700,
                                width: 3.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: TextField(
                            cursorColor: Colors.yellow[700],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.group,
                                  color: Colors.yellow.shade800,
                                  size: 20,
                                ),
                                hintText: 'Covers',
                                border: InputBorder.none,
                                errorText: null),
                            onChanged: (value) => passEvent(context,
                                CoversChanged(type: orderType, covers: value)),
                          ),
                        ),
                      ),
                      ListTile(
                        title: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.redAccent)),
                          child:
                              Text('OK', style: TextStyle(color: Colors.white)),
                          onPressed: () =>
                              passEvent(context, Submit(type: orderType)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Card(
                  color: Colors.white70,
                  child: BlocBuilder<OrderInfoBloc, OrderInfoState>(
                    buildWhen: (previous, current) {
                      if (current is WaitersState || current is TablesState) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      return gridLayoutController(state);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget gridLayoutController(OrderInfoState state) {
    if (state is WaitersState) {
      return waitersGridView(state.waiters);
    } else if (state is TablesState) {
      return tablesGridView(state.tables);
    } else {
      return waitersGridView([]);
    }
  }

  Widget waitersGridView(List<Waiter> listWaiters) => GridView.builder(
        itemCount: listWaiters.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) => Container(
          child: Card(
            color: listWaiters[index].selected
                ? Colors.redAccent[200]
                : Colors.white,
            child: InkWell(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: Text(
                      listWaiters[index].name.toUpperCase(),
                      style: GoogleFonts.ubuntuCondensed(
                        color: listWaiters[index].selected
                            ? Colors.black
                            : Colors.grey[800],
                        fontSize: 14,
                        letterSpacing: 1.0,
                        wordSpacing: 1.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage('assets/waiter.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                passEvent(
                  context,
                  WaiterChanged(
                    type: orderType,
                    waiter: listWaiters[index],
                  ),
                );
              },
            ),
          ),
        ),
      );

  Widget tablesGridView(List<t.Tables> listTables) => GridView.builder(
        itemCount: listTables.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) => Card(
          elevation: 10,
          color: listTables[index].selected
              ? Colors.redAccent[200]
              : Colors.grey.shade100,
          child: InkWell(
            child: Stack(
              children: [
                Positioned(
                  top: 2,
                  left: 2,
                  child: Text(
                    listTables[index].tableName,
                    style: GoogleFonts.ubuntuCondensed(
                      color: Colors.grey.shade900,
                      fontSize: 16,
                      letterSpacing: 1.0,
                      wordSpacing: 1.0,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: Image(
                      image: AssetImage('assets/table.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(-1, -1),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: listTables[index].reserved
                        ? Icon(Icons.lock, color: Colors.black)
                        : Icon(Icons.check,
                            color: listTables[index].selected
                                ? Colors.green
                                : Colors.white),
                  ),
                ),
              ],
            ),
            onTap: () {
              passEvent(
                context,
                TableChanged(type: orderType, table: listTables[index]),
              );
            },
          ),
        ),
      );

  void passEvent(BuildContext c, OrderInfoEvent event) =>
      c.read<OrderInfoBloc>().add(event);
}

class TakeAwayLayout extends StatelessWidget {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final orderType = ORDERTYPE.TAKE_AWAY;
  static Key nameKey = GlobalKey();
  static Key contactKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderInfoBloc, OrderInfoState>(
      listenWhen: (previous, current) {
        if (current.orderType != null && current.orderType == orderType)
          return true;
        else
          return false;
      },
      listener: (context, state) {
        if (state is InvalidCustomer) {
          AppTheme.snackbar(context, state.message);
        } else if (state is InvalidContact) {
          AppTheme.snackbar(context, state.message);
        } else if (state is CustomerFound) {
          nameController.text = state.customer.name;
          contactController.text = state.customer.contact;
          AppTheme.snackbar(context, state.message);
        } else if (state is CustomerNotFound) {
          nameController.text = '';
          AppTheme.snackbar(context, state.message);
        }
      },
      child: SingleChildScrollView(
        child: Container(
          height: Config.getDeviceHeight(context) * 0.8,
          margin: EdgeInsets.all(5.0),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    title: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        border: Border(
                          left: BorderSide(
                            color: Colors.yellow.shade700,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: TextField(
                        key: nameKey,
                        controller: contactController,
                        onChanged: (value) => passEvent(context,
                            ContactChanged(type: orderType, contact: value)),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.yellow.shade700,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.dialpad,
                              color: Colors.yellow.shade800,
                              size: 20,
                            ),
                            hintText: 'Contact',
                            border: InputBorder.none,
                            errorText: null),
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () =>
                            passEvent(context, SearchCustomer(type: orderType)),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        border: Border(
                          left: BorderSide(
                            color: Colors.yellow.shade700,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: TextField(
                        key: contactKey,
                        controller: nameController,
                        onChanged: (value) => passEvent(
                            context,
                            CustomerChanged(
                                type: orderType, customerName: value)),
                        cursorColor: Colors.yellow.shade700,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.yellow.shade800,
                            ),
                            border: InputBorder.none,
                            hintText: 'Name',
                            errorText: null),
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent),
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => passEvent(
                            context,
                            Submit(
                              type: orderType,
                            ))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void passEvent(BuildContext c, OrderInfoEvent event) =>
      c.read<OrderInfoBloc>().add(event);
}

class DeliveryLayout extends StatelessWidget {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final orderType = ORDERTYPE.DELIVERY;
  static Key nameKey = GlobalKey();
  static Key contactKey = GlobalKey();
  static Key addressKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderInfoBloc, OrderInfoState>(
      listenWhen: (previous, current) {
        if (current.orderType != null && current.orderType == orderType) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        if (state is CustomerFound) {
          nameController.text = state.customer.name;
          contactController.text = state.customer.contact;
          addressController.text = state.customer.address;
          AppTheme.snackbar(context, state.message);
        } else if (state is CustomerNotFound) {
          nameController.text = '';
          AppTheme.snackbar(context, state.message);
        } else if (state is InvalidCustomer) {
          AppTheme.snackbar(context, state.message);
        } else if (state is InvalidContact) {
          AppTheme.snackbar(context, state.message);
        } else if (state is InvalidAddress) {
          AppTheme.snackbar(context, state.message);
        }
      },
      child: SingleChildScrollView(
        child: Container(
          height: Config.getDeviceHeight(context) * 0.8,
          margin: EdgeInsets.all(5.0),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    title: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        border: Border(
                          left: BorderSide(
                            color: Colors.yellow.shade700,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: TextField(
                        key: nameKey,
                        controller: contactController,
                        onChanged: (value) => passEvent(context,
                            ContactChanged(type: orderType, contact: value)),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.yellow.shade700,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.dialpad,
                              size: 20,
                              color: Colors.yellow.shade800,
                            ),
                            hintText: 'Contact',
                            border: InputBorder.none,
                            errorText: null),
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            passEvent(context, SearchCustomer(type: orderType)),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        border: Border(
                          left: BorderSide(
                            color: Colors.yellow.shade700,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: TextField(
                        key: contactKey,
                        controller: nameController,
                        onChanged: (value) => passEvent(
                            context,
                            CustomerChanged(
                                type: orderType, customerName: value)),
                        cursorColor: Colors.yellow.shade700,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.yellow.shade800,
                            ),
                            hintText: 'Name',
                            border: InputBorder.none,
                            errorText: null),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        border: Border(
                          left: BorderSide(
                            color: Colors.yellow.shade700,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: TextField(
                        key: addressKey,
                        controller: addressController,
                        onChanged: (value) => passEvent(context,
                            AddressChanged(type: orderType, address: value)),
                        cursorColor: Colors.yellow.shade700,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.home,
                              size: 20,
                              color: Colors.yellow.shade800,
                            ),
                            hintText: 'Address',
                            border: InputBorder.none,
                            errorText: null),
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () =>
                          passEvent(context, Submit(type: orderType)),
                    ),
                    // tileColor: deliverySearchButton ? Colors.redAccent : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void passEvent(BuildContext c, OrderInfoEvent event) =>
      c.read<OrderInfoBloc>().add(event);
}
