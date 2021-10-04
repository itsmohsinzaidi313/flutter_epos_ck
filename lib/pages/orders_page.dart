import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_theme.dart';

class OrdersPage extends StatefulWidget {
  final enablePayment = false;
  final enableOrderDelete = false;

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> ordersList = [];
  void updateOrders() async {
    try {
      if (mounted)
        AppTheme.snackbar(context, 'Refreshing orders...', duration: 1);
      final response = await OrderRepo.repo.getOrders();
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        final list = (json as List<dynamic>) ?? [];
        if (mounted)
          setState(() {
            ordersList = list.map((e) => Order.fromMap(e)).toList();
            AppTheme.snackbar(context, 'Orders updated', duration: 1);
          });
      } else if (response.statusCode == HttpStatus.notFound) {
        if (mounted)
          setState(() {
            ordersList = [];
            AppTheme.snackbar(context, 'No order are available', duration: 1);
          });
      } else {
        if (mounted)
          AppTheme.snackbar(context,
              'Unable to get orders\nStatusCode: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      if (mounted)
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
        ],
      ),
      body: Container(
        child: getOrdersList(order: ordersList),
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
                  boxTile(title: 'TABLE', description: '${order.tableId}'),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'MEMBER NAME  ',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                      Expanded(
                        child: Text(
                          order.members.first.memberName,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12, overflow: TextOverflow.clip),
                        ),
                      ),
                    ],
                  ),
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
    return GridView.builder(
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
