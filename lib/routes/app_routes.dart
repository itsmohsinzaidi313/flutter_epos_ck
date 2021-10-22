import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/bloc/report_bloc/report_bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/pages/feedback_page.dart';
import 'package:pos_app/pages/login_page.dart';
import 'package:pos_app/pages/menu_pages/menu_page.dart';
import 'package:pos_app/pages/order_info_page.dart';
import 'package:pos_app/pages/payment_page%20copy.dart';
import 'package:pos_app/pages/pos_page.dart';
import 'package:pos_app/pages/report_pages/reports_page.dart';
import 'package:pos_app/pages/splash_page.dart';
import 'package:pos_app/pages/orders_page.dart';

class AppRoutes {
  LoginBloc _loginBloc;
  OrderInfoBloc _orderInfoBloc;
  POSBloc _posBloc;
  PaymentBloc _paymentBloc;
  ReportBloc _reportBloc;

  AppRoutes() {
    _loginBloc = LoginBloc();
    _orderInfoBloc = OrderInfoBloc();
    _posBloc = POSBloc();
    _paymentBloc = PaymentBloc();
    _reportBloc = ReportBloc();
  }

  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (context) => SplashScreen());
        break;
      case '/login':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _loginBloc,
            child: LoginScreen(),
          ),
        );
        break;
      case '/menu':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _loginBloc,
            child: MenuScreen(),
          ),
        );
        break;
      case '/orderInfo':
        _orderInfoBloc.add(OrderInfoBuild());
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _orderInfoBloc,
            child: OrderInfoScreen(),
          ),
        );
        break;
      case '/pos':
        _posBloc
            .add(LoadPOSOrder(customerOrder: routeSettings.arguments as Order));
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _posBloc,
            child: PosScreen(),
          ),
        );
        break;
      case '/payment':
        _paymentBloc.add(
            LoadPaymentOrder(customerOrder: routeSettings.arguments as Order));
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _paymentBloc,
            child: PaymentScreen(),
          ),
        );
        break;
      case '/orders':
        return MaterialPageRoute(
          builder: (context) =>
              OrdersScreen(ordersList: routeSettings.arguments),
        );
        break;
      case '/feedback':
        return MaterialPageRoute(
          builder: (context) => FeedbackScreen(
            order: routeSettings.arguments,
          ),
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
    _paymentBloc.close();
    _reportBloc.close();
  }
}
