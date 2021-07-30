import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';

class OrdersScreen extends StatefulWidget {
  final List<Order> ordersList = [];
  final enablePayment = false;
  final enableOrderDelete = false;

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  List<Tab> tabs;
  TabController tabController;

  _OrdersScreenState() {
    widget.ordersList.clear();
    tabs = [];
    Tab dineInTab = Tab(
      child: Text('DINE IN'),
    );
    Tab takeAwayTab = Tab(
      child: Text('TAKE AWAY'),
    );
    Tab deliveryTab = Tab(
      child: Text('DELIVERY'),
    );
    final tabsBuffer = [dineInTab, takeAwayTab, deliveryTab];
    // tabs = tabsBuffer;
    if (Config.allowDineIn) tabs.add(tabsBuffer[0]);
    if (Config.allowTakeAway) tabs.add(tabsBuffer[1]);
    if (Config.allowDelivery) tabs.add(tabsBuffer[2]);

    tabController = TabController(length: tabs.length, vsync: this);
  }

  void updateOrders() async {
    try {
      AppTheme.snackbar(context, 'Refreshing orders...');
      List<Order> temp = await OrderRepo.repo.getOrders(orderType: '0');
      widget.ordersList.clear();
      for (var item in temp) {
        widget.ordersList.add(item);
      }
      setState(() {});
    } catch (e) {
      AppTheme.snackbar(context, e.toString(), textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppTheme.appBarNormal(
          appBarTitle: 'Pending Orders',
          appBarBgColor: AppTheme.appBarColor,
          appBarElevation: 0.0,
          context: context,
          bottom: TabBar(
            tabs: tabs,
            controller: tabController,
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
              ),
              child: Row(
                children: [
                  Icon(Icons.sync, color: Colors.red),
                  Text(
                    'Refresh',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              onPressed: updateOrders,
            )
          ]),
      body: Container(
        child: TabBarView(
          controller: tabController,
          children: getTabWidgets(),
          //     [
          //   getOrdersList(
          //       order: ordersList.where((e) {
          //     if (e.orderType == '1')
          //       return true;
          //     else
          //       return false;
          //   }).toList()),
          //   getOrdersList(
          //       order: ordersList.where((e) {
          //     if (e.orderType == '2')
          //       return true;
          //     else
          //       return false;
          //   }).toList()),
          //   getOrdersList(
          //       order: ordersList.where((e) {
          //     if (e.orderType == '3')
          //       return true;
          //     else
          //       return false;
          //   }).toList()),
          // ],
        ),
      ),
    );
  }

  List<Widget> getTabWidgets() {
    final widgetsBuffer = <Widget>[
      getOrdersList(
          order: widget.ordersList.where((e) {
        if (e.orderType == '1')
          return true;
        else
          return false;
      }).toList()),
      getOrdersList(
          order: widget.ordersList.where((e) {
        if (e.orderType == '2')
          return true;
        else
          return false;
      }).toList()),
      getOrdersList(
          order: widget.ordersList.where((e) {
        if (e.orderType == '3')
          return true;
        else
          return false;
      }).toList()),
    ];
    final tabWidgets = <Widget>[];
    if (Config.allowDineIn) tabWidgets.add(widgetsBuffer[0]);
    if (Config.allowTakeAway) tabWidgets.add(widgetsBuffer[1]);
    if (Config.allowDelivery) tabWidgets.add(widgetsBuffer[2]);
    return tabWidgets;
  }

  Widget orderGridItem({@required Order order}) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.red,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'ORDER#: ${order.orderNo}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // boxTile(title: 'SUBTOTAL', description: order.subTotal),
                  // Divider(),
                  // boxTile(title: 'TAX', description: order.totalTaxAmount),
                  // Divider(),
                  boxTile(
                      title: 'AMOUNT',
                      description: order.totalTaxedAmount,
                      fontWeight: FontWeight.bold),
                  Divider(),
                  boxTile(title: 'TIME', description: '${order.time}'),
                  Divider(),
                  order.orderType == '1'
                      ? boxTile(title: 'TABLE', description: '${order.tableId}')
                      : Container(),
                  order.orderType != '1'
                      ? boxTile(title: 'NAME', description: '${order.customer}')
                      : Container(),
                  order.orderType != '1' ? Divider() : Container(),
                  order.orderType != '1'
                      ? boxTile(
                          title: 'CONTACT',
                          description: '${order.customer.contact}')
                      : Container(),
                  order.orderType != '1' ? Divider() : Container(),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Colors.amber,
                    ),
                    onPressed: () async {
                      order.editOrder = true;
                      await Navigator.of(context)
                          .pushNamed('/pos', arguments: order);
                      updateOrders();
                    },
                  ),
                  widget.enablePayment
                      ? IconButton(
                          icon: Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            AppTheme.showAlertDialogYN(context,
                                title: 'Order Payment',
                                message: 'Are You Sure?',
                                onNo: () => Navigator.pop(context),
                                onYes: () {
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .pushNamed('/payment', arguments: order);
                                });
                          },
                        )
                      : Container(),
                  widget.enableOrderDelete
                      ? IconButton(
                          icon: Icon(
                            Icons.delete_rounded,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            AppTheme.showAlertDialogYN(context,
                                title: 'Delete Order',
                                message: 'Are You Sure?',
                                onNo: () => Navigator.pop(context),
                                onYes: () => Navigator.pop(context));
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderListItem({@required Order order}) {
    return InkWell(
        child: ListTile(
          leading: Text(order.orderNo.toString()),
          title: order.orderType == '1'
              ? Text(
                  'ORDER#: ${order.orderNo} | TIME: ${order.time} | TABLE: ${order.tableId}',
                  style:
                      TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
                )
              : Text(
                  'ORDER#: ${order.orderNo} | TIME: ${order.time} | CUSTOMER: ${order.customer}',
                  style:
                      TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
                ),
        ),
        onDoubleTap: () {});
  }

  Widget getListItemExpansion({@required Order order}) {
    return ExpansionTile(
      title: order.orderType == '1'
          ? Text(
              'ORDER#: ${order.orderNo} | TIME: ${order.time} | TABLE: ${order.tableId}',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            )
          : Text(
              'ORDER#: ${order.orderNo} | TIME: ${order.time} | CUSTOMER: ${order.customer}',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
      leading: Text(order.orderNo.toString()),
      trailing: Icon(Icons.arrow_drop_down),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_rounded,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/pos', arguments: order);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.green,
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/payment', arguments: order),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    await AppTheme.showAlertDialogYN(context,
                        title: 'Delete Order',
                        message: 'Are You Sure?',
                        onNo: () => Navigator.of(context).pop(false),
                        onYes: () {
                          Navigator.of(context).pop(true);
                        });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget getOrdersList({List<Order> order}) {
    if (order.length < 1) {
      return Center(
        child: Text(
          'No Pending Orders Available',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
      );
    }
    return false
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: order.length,
            itemBuilder: (context, index) {
              return getListItemExpansion(order: order[index]);
            },
          )
        : GridView.builder(
            shrinkWrap: true,
            itemCount: order.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemBuilder: (context, index) => orderGridItem(order: order[index]),
          );
  }

  Widget boxTile(
      {String title,
      String description,
      FontWeight fontWeight = FontWeight.normal}) {
    final gridTextStyle = TextStyle(fontSize: 12, fontWeight: fontWeight);
    return Row(
      children: [
        Text(
          title,
          style: gridTextStyle ?? '',
        ),
        Expanded(child: SizedBox()),
        Text(
          description ?? '',
          style: gridTextStyle,
        ),
      ],
    );
  }
}
