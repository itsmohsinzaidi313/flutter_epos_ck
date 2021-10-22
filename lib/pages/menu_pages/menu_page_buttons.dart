import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/pages/widgets/menu_card.dart';

class MenuPageButtons {
  final BuildContext context;
  MenuPageButtons({this.context});

  List<MainMenuCard> get buttons => [
        MainMenuCard(
            title: 'New Order',
            subtitle: 'place new customer order',
            asset: 'cutlery.png',
            onTap: () {
              Navigator.of(context).pushNamed('/orderInfo');
            }),
        MainMenuCard(
          title: 'Pending Orders',
          subtitle: 'all pending customer orders',
          asset: 'order.png',
          onTap: () {
            try {
              AppTheme.snackbar(
                  context, 'Loading pending orders please wait...');
              OrderRepo.repo.getOrders().then((response) {
                if (response.statusCode == HttpStatus.ok) {
                  final ordersList =
                      (jsonDecode(response.body) as List<dynamic>)
                              .map((e) => Order.fromMap(e))
                              .toList() ??
                          <Order>[];
                  if (ordersList.isEmpty) return;
                  Navigator.of(context)
                      .pushNamed('/orders', arguments: ordersList);
                } else {
                  AppTheme.snackbar(context, Lib.getMessage(response));
                }
              }).catchError((e) => AppTheme.snackbar(context, e.toString(),
                  textColor: Colors.red));
            } catch (e) {
              log('Menu Screen', error: e);
              AppTheme.snackbar(context, e.toString(), textColor: Colors.red);
            }
          },
        ),
        MainMenuCard(
            title: 'Logout',
            subtitle: 'logout of you account',
            onTap: () async {
              bool x = await AppTheme.showAlertDialogYNFutureReturn(context,
                  title: 'Attention', message: 'Are you sure?');
              if (x) {
                context.read<LoginBloc>().add(LogoutPressed());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            asset: 'logout.png'),
        MainMenuCard(
            title: 'Feedback',
            subtitle: 'take customer feedback',
            onTap: () {
              final nameController = TextEditingController();
              final contactController = TextEditingController();
              final orderNoController = TextEditingController();
              final dateController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: SingleChildScrollView(
                      child: StatefulBuilder(
                        builder: (context, setState) => Container(
                          width: Config.getDeviceWidth(context) * 0.5,
                          child: Wrap(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(4),
                                          topRight: const Radius.circular(4),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Customer Info',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.person),
                                          labelText: 'Customer name',
                                          errorText: nameController.text == ''
                                              ? 'Required'
                                              : null),
                                    ),
                                    TextField(
                                      controller: contactController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.dialpad),
                                          labelText: 'Customer contact',
                                          errorText:
                                              contactController.text == ''
                                                  ? 'Required'
                                                  : null),
                                    ),
                                    TextField(
                                      controller: orderNoController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.edit),
                                          labelText: 'Order number',
                                          errorText:
                                              orderNoController.text == ''
                                                  ? 'Required'
                                                  : null),
                                    ),
                                    // StatefulBuilder(
                                    //     builder: (context, setState) {
                                    //   return TextField(
                                    //     controller: dateController,
                                    //     keyboardType: TextInputType.datetime,
                                    //     decoration: InputDecoration(
                                    //         icon: Icon(Icons.calendar_today),
                                    //         labelText: 'Order date',
                                    //         errorText: dateController.text == ''
                                    //             ? 'Required'
                                    //             : null),
                                    //     onTap: () async {
                                    //       final date = await showDatePicker(
                                    //           context: context,
                                    //           initialDate: DateTime.now(),
                                    //           firstDate: DateTime(
                                    //               DateTime.now().year - 1),
                                    //           lastDate: DateTime(
                                    //               DateTime.now().year + 5));
                                    //       if (date != null) {
                                    //         dateController.text = date
                                    //             .toIso8601String()
                                    //             .substring(0, 10);
                                    //       }
                                    //     },
                                    //   );
                                    // }),
                                    ButtonBar(
                                      children: [
                                        ElevatedButton(
                                          child: Text('Ok'),
                                          onPressed: () => _onFeedbackPressed(
                                              context,
                                              name: nameController.text,
                                              contact: contactController.text,
                                              orderNo: orderNoController.text),
                                        ),
                                        ElevatedButton(
                                          child: Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            asset: 'feedback3.png'),
        // MainMenuCard(
        //     title: 'Reports',
        //     subtitle: 'view financial reports of your sales',
        //     onTap: () async {
        //       await Lib.forcePortraitView(); // Forces potrate mode
        //       await Navigator.of(context).pushNamed('/reports');
        //       await Lib.forceLandscapeView(); // Resets to landscape mode
        //     },
        //     asset: 'report.png'),
      ];

  Future<void> _onFeedbackPressed(BuildContext context,
      {@required String name,
      @required String contact,
      @required String orderNo}) async {
    if (orderNo != '' && name != '' && contact != '') {
      Order order = await _getOrder(context, orderNo);
      if (order != null) {
        order.customer.name = name;
        order.customer.contact = contact;
        Navigator.of(context).pushNamed('/feedback', arguments: order);
      }
    }
  }

  Future<Order> _getOrder(BuildContext context, String orderNo) async {
    final response = await OrderRepo.repo.getOrders(
      orderNo: orderNo,
    );
    if (response.statusCode == HttpStatus.ok) {
      return Order.fromMap(jsonDecode(response.body));
    } else {
      AppTheme.snackbar(context, 'No order found');
      return null;
    }
  }
}
