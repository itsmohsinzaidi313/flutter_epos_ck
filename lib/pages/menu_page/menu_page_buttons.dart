import 'package:flutter/material.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/shared/app_theme.dart';
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
          onTap: () => Navigator.of(context).pushNamed('/orders'),
        ),
        MainMenuCard(
            title: 'Close Register',
            subtitle: 'close your register',
            onTap: () async {
              bool x = await AppTheme.showAlertDialogYNFutureReturn(context,
                  title: 'Attention', message: 'Are you sure?');
              if (x) {
                context.read<LoginBloc>().add(LogoutPressed());
                Navigator.of(context).pushNamed('/register');
              }
            },
            asset: 'register.png'),
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
            title: 'SQL',
            subtitle: 'use for database interactions',
            onTap: () => Navigator.of(context).pushNamed('/database'),
            asset: 'database-storage.png')
      ];
}
