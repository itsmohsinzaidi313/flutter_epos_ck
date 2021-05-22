import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../shared/config.dart';
import '../shared/widgets/dashboard_card.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController closingAmount = TextEditingController();
  bool checkField = false;
  String errorMessage = 'Required';
  ProgressDialog progDialog;

  @override
  void initState() {
    super.initState();
    progDialog =
        AppTheme.showProgressDialog(context, widget: Text('Loading...'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool value = await AppTheme.showAlertDialogYNFutureReturn(context,
            message: 'Exit application?', title: 'Attention');
        return value;
      },
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.red,
            elevation: 0.0,
            title: Row(
              children: [
                Text('User: ${Config.user.name}'),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            children: [
              DashboardCard(
                  title: 'New Order',
                  asset: 'cutlery.png',
                  onTap: () {
                    Navigator.of(context).pushNamed('/orderInfo');
                  }),
              DashboardCard(
                title: 'Pending Orders',
                asset: 'order.png',
                onTap: () {
                  try {
                    progDialog.show();
                    OrderRepo.repo
                        .getAllOrders(userId: Config.user.id, type: '0')
                        .then((response) {
                          if (response.status) {
                            List<Order> ordersList =
                                (response.data as List<dynamic>)
                                    .map((e) => Order.fromJson(e))
                                    .toList();
                            progDialog.hide();
                            Navigator.of(context)
                                .pushNamed('/orders', arguments: ordersList);
                          } else {
                            AppTheme.snackbar(context, response.message);
                          }
                        })
                        .catchError((e) => AppTheme.snackbar(
                            context, e.toString(),
                            textColor: Colors.red))
                        .whenComplete(() => progDialog.hide());
                  } catch (e) {
                    log('Menu Screen', error: e);
                    AppTheme.snackbar(context, e.toString(),
                        textColor: Colors.red);
                  }
                },
              ),
              DashboardCard(
                  title: 'Logout',
                  onTap: () async {
                    bool x = await AppTheme.showAlertDialogYNFutureReturn(
                        context,
                        title: 'Attention',
                        message: 'Are you sure?');
                    if (x)
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  asset: 'logout.png')
            ],
          )),
    );
  }
}
