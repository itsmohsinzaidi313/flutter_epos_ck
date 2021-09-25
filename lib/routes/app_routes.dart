import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/bloc/report_bloc/report_bloc.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/pages/login_page.dart';
import 'package:pos_app/pages/menu_pages/menu_page.dart';
import 'package:pos_app/pages/order_info_page.dart';
import 'package:pos_app/pages/pos_page.dart';
import 'package:pos_app/pages/report_pages/reports_page.dart';
import 'package:pos_app/pages/splash_page.dart';
import 'package:pos_app/pages/orders_page.dart';

class AppRoutes {
  LoginBloc _loginBloc;
  OrderInfoBloc _orderInfoBloc;
  POSBloc _posBloc;
  ReportBloc _reportBloc;
  final Order _customerOrder = Order();

  AppRoutes() {
    _loginBloc = LoginBloc();
    _orderInfoBloc = OrderInfoBloc();
    _posBloc = POSBloc();
    _reportBloc = ReportBloc();
  }

  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashScreen());
        break;
      case '/login':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _loginBloc,
            child: LoginPage(),
          ),
        );
        break;
      case '/menu':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _loginBloc,
            child: MenuPage(),
          ),
        );
        break;
      case '/orderInfo':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _orderInfoBloc,
            child: OrderInfoPage(),
          ),
        );
        break;
      case '/pos':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _posBloc,
            child: PosPage(
              order: routeSettings.arguments as Order,
            ),
          ),
        );
        break;
      case '/orders':
        return MaterialPageRoute(
          builder: (context) =>
              OrdersPage(),
        );
        break;
      case '/reports':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _reportBloc,
            child: ReportsPage(),
          ),
        );
        break;
      default:
        return null;
        break;
    }
  }

  void dispose() {
    _loginBloc.close();
    _orderInfoBloc.close();
    _posBloc.close();
    _reportBloc.close();
  }
}
