import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';

class OrdersScreen extends StatefulWidget {
  final List<Order> ordersList;
  OrdersScreen({@required this.ordersList});
  @override
  _OrdersScreenState createState() =>
      _OrdersScreenState(ordersList: ordersList);
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  List<Order> ordersList;
  List<Tab> tabs;
  TabController tabController;
  final gridTextStyle = TextStyle(fontSize: 14);
  _OrdersScreenState({@required this.ordersList}) {
    Tab dineInTab = Tab(
      child: Text('DINE IN'),
    );
    Tab takeAwayTab = Tab(
      child: Text('TAKE AWAY'),
    );
    Tab deliveryTab = Tab(
      child: Text('DELIVERY'),
    );
    tabs = [dineInTab, takeAwayTab, deliveryTab];
    tabController = TabController(length: tabs.length, vsync: this);
  }

  void updateOrders() async {
    final progDialog =
        AppTheme.showProgressDialog(context, widget: Text('Loading...'));
    await progDialog.show();
    try {
      ServerResponse response =
          await OrderRepo.repo.getAllOrders(userId: Config.user.id, type: '0');
      if (response.status) {
        await progDialog.hide();
        setState(() {
          ordersList = (response.data as List<dynamic>)
              .map((e) => Order.fromJson(e))
              .toList();
        });
      } else {
        await progDialog.hide();
        AppTheme.snackbar(context, response.message);
      }
    } catch (e) {
      await progDialog.hide();
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
            IconButton(
              icon: Icon(Icons.sync),
              onPressed: updateOrders,
            )
          ]),
      body: Container(
        // height: Config.getDeviceHeight(context),
        // width: Config.getDeviceWidth(context),
        child: TabBarView(
          controller: tabController,
          children: [
            getOrdersList(
                order: ordersList.where((e) {
              if (e.orderType == '1')
                return true;
              else
                return false;
            }).toList()),
            getOrdersList(
                order: ordersList.where((e) {
              if (e.orderType == '2')
                return true;
              else
                return false;
            }).toList()),
            getOrdersList(
                order: ordersList.where((e) {
              if (e.orderType == '3')
                return true;
              else
                return false;
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget orderGridItem({@required Order order}) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(
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
                        style: TextStyle(color: Colors.white, fontSize: 22),
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
                  Row(
                    children: [
                      Text(
                        'AMOUNT',
                        style: gridTextStyle,
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        '${order.totalAmount}',
                        style: gridTextStyle,
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'TIME',
                        style: gridTextStyle,
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        '${order.time}',
                        style: gridTextStyle,
                      ),
                    ],
                  ),
                  Divider(),
                  order.orderType == '1'
                      ? Row(
                          children: [
                            Text(
                              'TABLE',
                              style: gridTextStyle,
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Text(
                              '${order.table}',
                              style: gridTextStyle,
                            ),
                          ],
                        )
                      : Container(),
                  order.orderType != '1'
                      ? Row(
                          children: [
                            Text(
                              'NAME',
                              style: gridTextStyle,
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Text(
                              '${order.customer}',
                              style: gridTextStyle,
                            ),
                          ],
                        )
                      : Container(),
                  order.orderType != '1' ? Divider() : Container(),
                  order.orderType != '1'
                      ? Row(
                          children: [
                            Text(
                              'CONTACT',
                              style: gridTextStyle,
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Text(
                              '${order.contact}',
                              style: gridTextStyle,
                            ),
                          ],
                        )
                      : Container(),
                  order.orderType != '1' ? Divider() : Container(),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                IconButton(
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
                ),
                IconButton(
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
                ),
              ],
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
                  'ORDER#: ${order.orderNo} | TIME: ${order.time} | TABLE: ${order.table}',
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
              'ORDER#: ${order.orderNo} | TIME: ${order.time} | TABLE: ${order.table}',
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
      return Expanded(
        flex: 1,
        child: Center(
          child: Text(
            'No Pending Orders Available',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
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
}
