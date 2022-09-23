import 'package:flutter/material.dart';
import 'package:pos_app/pages/menu_page/menu_page_arguments.dart';
import 'package:pos_app/pages/menu_page/menu_page_buttons.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/app_theme.dart';

class MenuPage extends StatelessWidget {
  static const String path = 'menu_page';
  final closingAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MenuPageArgs args = Lib.getArguments<MenuPageArgs>(context)!;
    return WillPopScope(
      onWillPop: () async {
        bool value = await (AppTheme.showAlertDialogYNFutureReturn(context,
            message: 'Exit application?', title: 'Attention') as Future<bool>);
        return value;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Row(
            children: [
              Text(
                'User: ${args.user!.name}'.toUpperCase(),
              ),
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
