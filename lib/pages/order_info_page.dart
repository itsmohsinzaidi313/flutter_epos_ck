import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/pages/backend/order_info_backend.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';

import 'widgets/app_widgets.dart';

enum OrderType { dineIn, takeAway, delivery }

class OrderInfoPage extends StatefulWidget {
  @override
  State<OrderInfoPage> createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  final ImageProvider dineIn = AssetImage('assets/dine_in.jpg'),
      takeAway = AssetImage('assets/takeaway.jpg'),
      delivery = AssetImage('assets/delivery.jpg');
  OrderType _orderType = OrderType.dineIn;
  Widget dineInLayout;
  Widget takeAwayLayout;
  Widget deliveryLayout;

  Order _order;
  @override
  void initState() {
    super.initState();
    _order = context.read<Order>();
    _init(_order);
  }

  void _init(Order order) {
    dineInLayout = DineInLayout(
      tableChanged: (table) => order.setTable(table: table),
      coversChanged: (value) =>
          order.setCovers(covers: int.tryParse(value) ?? 0),
      waiterChanged: (waiter) => order.setWaiter(waiter: waiter),
      onSubmit: () => OrderInfoBackend.instance.nextPage(context),
    );
    takeAwayLayout = TakeAwayLayout(
      onContactChanged: (contact) => order.setCustomer(contact: contact),
      onNameChanged: (name) => order.setCustomer(),
      onSubmit: () => OrderInfoBackend.instance.nextPage(context),
    );
    deliveryLayout = DeliveryLayout(
      onContactChanged: (contact) => order.setCustomer(contact: contact),
      onNameChanged: (name) => order.setCustomer(name: name),
      onAddressChanged: (address) => order.setCustomer(address: address),
      onSubmit: () => OrderInfoBackend.instance.nextPage(context),
    );
  }

  Widget _getlayout(OrderType orderType) {
    switch (orderType) {
      case OrderType.dineIn:
        return dineInLayout;
        break;
      case OrderType.takeAway:
        return takeAwayLayout;
        break;
      case OrderType.delivery:
        return deliveryLayout;
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: _orderType == OrderType.dineIn
                  ? _getlayout(_orderType)
                  : Column(
                      children: [
                        _getlayout(_orderType),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
            ),
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
                              () =>
                                  setState(() => _orderType = OrderType.dineIn),
                              dineIn)
                          : Container(),
                      Config.allowTakeAway
                          ? orderTypeButton(
                              context,
                              'Takeaway',
                              () => setState(
                                  () => _orderType = OrderType.takeAway),
                              takeAway)
                          : Container(),
                      Config.allowDelivery
                          ? orderTypeButton(
                              context,
                              'Delivery',
                              () => setState(
                                  () => _orderType = OrderType.delivery),
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
    );
  }
}

class DineInLayout extends StatefulWidget {
  final void Function(String value) coversChanged;
  final void Function(Waiter waiter) waiterChanged;
  final void Function(Tables table) tableChanged;
  final void Function() onSubmit;

  DineInLayout(
      {this.onSubmit,
      this.coversChanged,
      this.waiterChanged,
      this.tableChanged});

  @override
  State<DineInLayout> createState() => _DineInLayoutState();
}

class _DineInLayoutState extends State<DineInLayout> {
  int viewType = 0;
  List<Waiter> _waiters = [];
  List<Tables> _tables = [];
  @override
  Widget build(BuildContext context) {
    return Container(
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
                          onChanged: widget.coversChanged,
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
                        onPressed: widget.onSubmit,
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
              child: FutureBuilder(
                future: OrderInfoBackend.instance.getValues(viewType),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data is List<Waiter>) {
                        if (_waiters.length == 0) {
                          _waiters = (snapshot.data as List<Waiter>);
                        }
                        return WaitersGrid(
                          listWaiters: _waiters,
                          onTap: (waiter) {
                            setState(() {
                              viewType = 1;
                              for (var item in _waiters) {
                                if (item.id == waiter.id)
                                  item.selected = true;
                                else
                                  item.selected = false;
                              }
                              widget.waiterChanged(waiter);
                            });
                          },
                        );
                      } else if (snapshot.data is List<Tables>) {
                        if (_tables.length == 0) {
                          _tables = (snapshot.data as List<Tables>);
                        }
                        return TablesGrid(
                          listTables: _tables,
                          onTap: (table) {
                            setState(() {
                              viewType = 0;
                              for (var item in _tables) {
                                if (item.id == table.id)
                                  item.selected = true;
                                else
                                  item.selected = false;
                              }
                              widget.tableChanged(table);
                            });
                          },
                        );
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TakeAwayLayout extends StatelessWidget {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final void Function(String name) onNameChanged;
  final void Function(String contact) onContactChanged;
  final void Function() onSubmit;
  TakeAwayLayout({this.onContactChanged, this.onNameChanged, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // height: Config.getDeviceHeight(context) * 0.8,
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
                      controller: _contactController,
                      onChanged: onContactChanged,
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
                      onPressed: () async {
                        if (_contactController.text == '') {
                          final value = await OrderInfoBackend.instance
                              .findCustomer(context,
                                  contact: _contactController.text);
                          if (value != '') {
                            _nameController.text = value;
                          } else {
                            AppTheme.snackbar(context, 'No customer found.');
                          }
                        } else {
                          AppTheme.snackbar(context, 'Enter contact number');
                        }
                      },
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
                      controller: _nameController,
                      onChanged: (value) => onNameChanged,
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
                    onPressed: onSubmit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeliveryLayout extends StatelessWidget {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final void Function(String contact) onContactChanged;
  final void Function(String name) onNameChanged;
  final void Function(String address) onAddressChanged;
  final void Function() onSubmit;
  DeliveryLayout(
      {this.onContactChanged,
      this.onNameChanged,
      this.onAddressChanged,
      this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      controller: _contactController,
                      onChanged: onContactChanged,
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
                      onPressed: () async {
                        if (_contactController.text == '') {
                          final value = await OrderInfoBackend.instance
                              .findCustomer(context,
                                  contact: _contactController.text);
                          if (value != '') {
                            _nameController.text = value;
                          } else {
                            AppTheme.snackbar(context, 'No customer found.');
                          }
                        } else {
                          AppTheme.snackbar(context, 'Enter contact number');
                        }
                      },
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
                      controller: _nameController,
                      onChanged: onNameChanged,
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
                      controller: _addressController,
                      onChanged: onAddressChanged,
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
                    onPressed: onSubmit,
                  ),
                  // tileColor: deliverySearchButton ? Colors.redAccent : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
