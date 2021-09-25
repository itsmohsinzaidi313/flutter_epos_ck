import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/repositories/order_repository.dart';
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
            Navigator.of(context)
                      .pushNamed('/orders', arguments: <Order>[]);
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
}
