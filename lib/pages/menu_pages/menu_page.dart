import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/pages/menu_pages/menu_page_buttons.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/app_theme.dart';
import '../../shared/config.dart';
import '../../shared/widgets/menu_card.dart';

class MenuScreen extends StatelessWidget {
  final closingAmount = TextEditingController();
  bool checkField = false;
  String errorMessage = 'Required';

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
          children: MenuPageButtons(context: context).buttons,
        ),
      ),
    );
  }
}
