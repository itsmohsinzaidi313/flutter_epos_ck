import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/models/customer_table.dart';
import 'package:pos_app/models/waiter.dart';
import 'package:pos_app/pages/items_menu_page/items_menu_page.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';

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

  final dineInOrdertype = ORDERTYPE.DINE_IN;
  final takeAwayOrderType = ORDERTYPE.TAKE_AWAY;
  final deliveryOrderType = ORDERTYPE.DELIVERY;

  final Widget takeAwayLayout = TakeAwayLayout();
  final Widget deliveryLayout = DeliveryLayout();

  @override
  Widget build(BuildContext context) {
    _passEvent(context, OrderInfoBuild());
    return Scaffold(
      appBar: AppTheme.appBarNormal(
        appBarTitle: 'Order Type',
        appBarElevation: 0.0,
        context: context,
        actions: [
          BlocBuilder<OrderInfoBloc, OrderInfoState>(
            builder: (context, state) => Container(
              width: Config.getDeviceWidth(context) * 0.2,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Next'), Icon(Icons.arrow_forward)],
                ),
                onPressed: () =>
                    _passEvent(context, Submit(type: state.orderType)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<OrderInfoBloc, OrderInfoState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: (state.orderType ?? ORDERTYPE.DINE_IN).index,
            onTap: (int value) {
              switch (value) {
                case 0:
                  _passEvent(context, OrderTypeChanged(type: dineInOrdertype));
                  break;
                case 1:
                  _passEvent(
                      context, OrderTypeChanged(type: takeAwayOrderType));
                  break;
                case 2:
                  _passEvent(
                      context, OrderTypeChanged(type: deliveryOrderType));
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
                arguments: state.customerOrder,
              );
            }
          } else if (state is ErrorState) {
            AppTheme.snackbar(
              context,
              state.message,
            );
          }
        },
        builder: (context, state) {
          List<Tables> tables = <Tables>[];
          List<Waiter> waiters = <Waiter>[];
          if (state is LoadedState) {
            tables = state.tables ?? <Tables>[];
            waiters = state.waiters ?? <Waiter>[];
          }
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                <Widget>() {
                  switch (state.orderType) {
                    case ORDERTYPE.DINE_IN:
                      return Expanded(
                          child: DineInLayout(
                        tables: tables,
                        waiters: waiters,
                      ));
                      break;
                    case ORDERTYPE.TAKE_AWAY:
                      return Expanded(child: takeAwayLayout);
                      break;
                    case ORDERTYPE.DELIVERY:
                      return Expanded(child: deliveryLayout);
                      break;
                    default:
                      return Container();
                      break;
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
