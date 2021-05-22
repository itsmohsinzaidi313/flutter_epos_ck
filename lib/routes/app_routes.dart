import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/pages/login_page.dart';
import 'package:pos_app/pages/menu_page.dart';
import 'package:pos_app/pages/order_info_page.dart';
import 'package:pos_app/pages/payment_page%20copy.dart';
import 'package:pos_app/pages/pos_page.dart';
import 'package:pos_app/pages/splash_page.dart';
import 'package:pos_app/pages/orders_page.dart';

class AppRoutes {
  LoginBloc loginBloc;
  OrderInfoBloc orderInfoBloc;
  POSBloc posBloc;
  PaymentBloc paymentBloc;
  final Order customerOrder = Order();

  AppRoutes() {
    loginBloc = LoginBloc();
    orderInfoBloc = OrderInfoBloc();
    posBloc = POSBloc();
    paymentBloc = PaymentBloc();
  }

  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashScreen());
        break;
      case '/login':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: loginBloc,
            child: LoginScreen(),
          ),
        );
        break;
      case '/menu':
        return MaterialPageRoute(builder: (context) => MenuScreen());
        break;
      case '/orderInfo':
        orderInfoBloc.add(OrderInfoBuild());
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: orderInfoBloc,
            child: OrderInfoScreen(),
          ),
        );
        break;
      case '/pos':
        posBloc
            .add(LoadPOSOrder(customerOrder: routeSettings.arguments as Order));
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: posBloc,
            child: PosScreen(),
          ),
        );
        break;
      case '/payment':
        paymentBloc
            .add(LoadPaymentOrder(customerOrder: routeSettings.arguments as Order));
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: paymentBloc,
            child: PaymentScreen(),
          ),
        );
        break;
      case '/orders':
        return MaterialPageRoute(
          builder: (context) =>
              OrdersScreen(ordersList: routeSettings.arguments),
        );
      default:
        return null;
        break;
    }
  }

  void dispose() {
    loginBloc.close();
    orderInfoBloc.close();
    posBloc.close();
    paymentBloc.close();
  }
}
