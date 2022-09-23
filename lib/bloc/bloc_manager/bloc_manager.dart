import 'package:pos_app/bloc/items_menu_bloc/items_menu_bloc.dart';
import 'package:pos_app/bloc/login_bloc/login_bloc.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:pos_app/bloc/payment_bloc/payment_bloc.dart';
import 'package:pos_app/bloc/report_bloc/report_bloc.dart';
import 'package:pos_app/models/customer_order.dart';

class BlocManager {
  final LoginBloc loginBloc;
  final OrderInfoBloc orderInfoBloc;
  final ItemsMenuBloc posBloc;
  final PaymentBloc paymentBloc;
  final OrdersBloc ordersBloc;
  final ReportBloc reportBloc;

  BlocManager(Order order)
      : loginBloc = LoginBloc(),
        orderInfoBloc = OrderInfoBloc(order: order),
        posBloc = ItemsMenuBloc(order: order),
        ordersBloc = OrdersBloc(),
        paymentBloc = PaymentBloc(),
        reportBloc = ReportBloc();

  void dispose() {
    loginBloc.close();
    orderInfoBloc.close();
    posBloc.close();
    paymentBloc.close();
    ordersBloc.close();
    reportBloc.close();
  }
}
