import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/pages/items_menu_page/items_menu_page.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/shared/enums.dart';

part 'order_info_page_widgets.dart';
part 'dine_in_view.dart';
part 'takeaway_view.dart';
part 'delivery_view.dart';
part 'tables_grid_view.dart';
part 'tables_list_view.dart';
part 'waiters_grid_view.dart';
part 'waiters_list_view.dart';

class OrderInfoPage extends StatelessWidget {
  static const String path = 'order_info_page';
  final ImageProvider dineIn = AssetImage('assets/dine_in.jpg'),
      takeAway = AssetImage('assets/takeaway.jpg'),
      delivery = AssetImage('assets/delivery.jpg');

  final dineInOrdertype = OrderType.dineIn;
  final takeAwayOrderType = OrderType.takeAway;
  final deliveryOrderType = OrderType.delivery;

  final Widget takeAwayLayout = TakeAwayLayout();
  final Widget deliveryLayout = DeliveryLayout();

  List<Tables> tables = <Tables>[];
  List<Waiter> waiters = <Waiter>[];

  @override
  Widget build(BuildContext context) {
    OrderType orderType = OrderType.dineIn;
    _passEvent(context, OrderInfoBuild(orderType: dineInOrdertype));
    return Scaffold(
      appBar: AppTheme.appBarNormal(
        appBarTitle: 'Order Type',
        appBarElevation: 0.0,
        context: context,
        actions: [
          BlocBuilder<OrderInfoBloc, OrderInfoState>(
            builder: (context, state) => Container(
              width: Config.getDeviceWidth(context) * 0.2,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).iconTheme.color,
                    )
                  ],
                ),
                onPressed: () =>
                    _passEvent(context, NextPressed(orderType: orderType)),
              ),
            ),
          ),
        ],
      ) as PreferredSizeWidget?,
      bottomNavigationBar: BlocBuilder<OrderInfoBloc, OrderInfoState>(
        builder: (context, state) {
          if (state is LoadedState) orderType = state.order.orderType;
          return BottomNavigationBar(
            currentIndex: (orderType).index,
            onTap: (int value) {
              switch (value) {
                case 0:
                  _passEvent(
                      context, OrderTypeChanged(orderType: dineInOrdertype));
                  break;
                case 1:
                  _passEvent(
                      context, OrderTypeChanged(orderType: takeAwayOrderType));
                  break;
                case 2:
                  _passEvent(
                      context, OrderTypeChanged(orderType: deliveryOrderType));
                  break;
                default:
              }
            },
            items: [
              BottomNavigationBarItem(
                label: 'Dine-In',
                icon: Icon(Icons.table_bar_outlined),
                activeIcon: Icon(
                  Icons.table_bar_rounded,
                ),
              ),
              BottomNavigationBarItem(
                label: 'TakeAway',
                icon: Icon(Icons.person_outline_outlined),
                activeIcon: Icon(
                  Icons.person_rounded,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Delivery',
                icon: Icon(Icons.directions_bike_outlined),
                activeIcon: Icon(
                  Icons.directions_bike,
                ),
              ),
            ],
          );
        },
      ),
      body: BlocConsumer<OrderInfoBloc, OrderInfoState>(
        listener: (context, state) {
          if (state is LoadedState) {
            if (state.validSubmission) {
              Navigator.of(context).pushNamed(
                ItemsMenuPage.path,
                arguments: state.order,
              );
            }
          } else if (state is ErrorState) {
            AppTheme.snackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is LoadedState) {
            tables.clear();
            waiters.clear();
            tables.addAll(state.tables);
            waiters.addAll(state.waiters);
          } else if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                <Widget>() {
                  switch (orderType) {
                    case OrderType.dineIn:
                      return Expanded(
                          child: DineInLayout(
                        tables: tables,
                        waiters: waiters,
                      ));
                    case OrderType.takeAway:
                      return Expanded(child: takeAwayLayout);
                    case OrderType.delivery:
                      return Expanded(child: deliveryLayout);
                    default:
                      return Container();
                  }
                }.call<Widget>(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _passEvent(BuildContext c, OrderInfoEvent event) =>
      c.read<OrderInfoBloc>().add(event);
}
