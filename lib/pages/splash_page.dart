import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_app/pages/login_page/login_page.dart';
import '../shared/config.dart';

class SplashPage extends StatelessWidget {
  static const String path = 'splash_page';

  void _loadPage(BuildContext context) =>
      Future<void>.delayed(const Duration(seconds: 2))
          .then((value) => Navigator.of(context).pushNamed(LoginPage.path));

  @override
  Widget build(BuildContext context) {
    _loadPage(context);
    return Scaffold(
      body: Container(
        height: Config.getDeviceHeight(context),
        width: Config.getDeviceWidth(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                height: Config.getDeviceHeight(context) * 0.3,
                width: Config.getDeviceWidth(context) * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.blue,
                      BlendMode.colorBurn,
                    ),
                    image: AssetImage('assets/images/logo.ico'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                Config.appTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  letterSpacing: 3.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
