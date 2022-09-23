import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/bloc_manager/bloc_manager.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/items_cart.dart';
import 'package:pos_app/pages/items_menu_page/items_menu_page.dart';
import 'package:pos_app/pages/login_page/login_page.dart';
import 'package:pos_app/pages/menu_page/menu_page.dart';
import 'package:pos_app/pages/order_info_page/order_info_page.dart';
import 'package:pos_app/pages/orders_page/orders_page.dart';
import 'package:pos_app/pages/splash_page.dart';
import 'package:pos_app/shared/config.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    runApp(App());
  } catch (e) {
    log('Error', error: e);
  }
}

Color color1 = Color.fromRGBO(3, 49, 140, 1);
Color color2 = Color.fromRGBO(3, 62, 140, 1);
Color color3 = Color.fromRGBO(5, 175, 242, 1);
Color color4 = Color.fromRGBO(242, 226, 5, 1);
Color color5 = Color.fromRGBO(242, 203, 5, 1);

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState(
        blocManager: BlocManager(
          Order(
            cart: ItemsCart(
              items: [],
            ),
          ),
        ),
      );
}

class _AppState extends State<App> {
  final BlocManager blocManager;
  _AppState({required this.blocManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Config.appTitle,
        initialRoute: SplashPage.path,
        routes: {
          SplashPage.path: (context) => SplashPage(),
          LoginPage.path: (context) => BlocProvider.value(
                value: blocManager.loginBloc,
                child: LoginPage(),
              ),
          MenuPage.path: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: blocManager.loginBloc),
                ],
                child: MenuPage(),
              ),
          OrderInfoPage.path: (context) => BlocProvider.value(
                value: blocManager.orderInfoBloc,
                child: OrderInfoPage(),
              ),
          OrdersPage.path: (context) => BlocProvider.value(
                value: blocManager.ordersBloc,
                child: OrdersPage(),
              ),
          ItemsMenuPage.path: (context) => BlocProvider.value(
                value: blocManager.posBloc,
                child: ItemsMenuPage(),
              )
        },
        theme: ThemeData.dark()
        // theme: ThemeData(
        // brightness: Brightness.light,
        // primarySwatch: Colors.blue,
        // primaryColor: Colors.blueAccent,
        // accentColor: Colors.yellow[800],
        // iconTheme: IconThemeData(
        //   color: Colors.white,
        // ),

        // canvasColor: Colors.grey[200],
        // colorScheme: ColorScheme(
        //   brightness: Brightness.light,
        //   primary: color1,
        //   onPrimary: color3,
        //   secondary: color2,
        //   onSecondary: Colors.white,
        //   error: color4,
        //   onError: Colors.white,
        //   background: color3,
        //   onBackground: Colors.white,
        //   surface: color5,
        //   onSurface: Colors.white,
        //   inversePrimary: Colors.black,
        //   inverseSurface: Colors.black,
        //   onInverseSurface: Colors.black,
        //   onTertiary: Colors.black,
        //   tertiary: Colors.black,
        //   tertiaryContainer: Colors.black,
        //   onTertiaryContainer: Colors.black,
        //   primaryContainer: Colors.black,
        //   onPrimaryContainer: Colors.black,
        //   secondaryContainer: Colors.black,
        //   onSecondaryContainer: Colors.black,
        //   outline: Colors.black,
        //   shadow: Colors.grey,
        // ),
        // ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    blocManager.dispose();
  }
}
