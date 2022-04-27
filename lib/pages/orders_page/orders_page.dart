import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/pages/items_menu_page/items_menu_page.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';

part 'orders_grid_item.dart';
part 'grid_box_tile.dart';

class OrdersPage extends StatelessWidget {
  static const String path = 'orders_page';
  const OrdersPage();

  final enablePayment = false;
  final enableOrderDelete = false;

  void passEvent(BuildContext context, OrdersBlocEvent event) =>
      context.read<OrdersBloc>().add(event);

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [];

    Tab dineInTab = Tab(child: Text('DINE IN'));
    Tab takeAwayTab = Tab(child: Text('TAKE AWAY'));
    Tab deliveryTab = Tab(child: Text('DELIVERY'));
    final tabsBuffer = [dineInTab, takeAwayTab, deliveryTab];

    if (Config.allowDineIn) tabs.add(tabsBuffer[0]);
    if (Config.allowTakeAway) tabs.add(tabsBuffer[1]);
    if (Config.allowDelivery) tabs.add(tabsBuffer[2]);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppTheme.appBarNormal(
            appBarTitle: 'Pending Orders',
            appBarElevation: 0.0,
            context: context,
            bottom: TabBar(
              tabs: tabs,
            ),
            actions: [
              ElevatedButton(
                child: Row(
                  children: [
                    Icon(Icons.sync),
                    Text('Refresh'),
                  ],
                ),
                onPressed: () => passEvent(context, FetchOrders()),
              )
            ]),
        body: BlocConsumer<OrdersBloc, OrdersBlocState>(
          listener: (context, state) {
            if (state is LoadingState) {
              AppTheme.snackbar(context, state.message);
            }
          },
          builder: (context, state) {
            List<Order> ordersList = [];
            List<Widget> tabs = [];
            if (state is InitialState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is LoadedState) {
              ordersList = state.ordersList ?? [];
              tabs = getTabWidgets(context, ordersList);
            }
            return Container(
              child: TabBarView(
                children: tabs,
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> getTabWidgets(BuildContext context, List<Order> ordersList) {
    final tabWidgets = <Widget>[];
    if (Config.allowDineIn) {
      tabWidgets.add(getOrdersList(context,
          order: ordersList.where((e) {
            if (e.orderType == '1')
              return true;
            else
              return false;
          }).toList()));
    }
    if (Config.allowTakeAway) {
      tabWidgets.add(getOrdersList(context,
          order: ordersList.where((e) {
            if (e.orderType == '2')
              return true;
            else
              return false;
          }).toList()));
    }
    if (Config.allowDelivery) {
      tabWidgets.add(getOrdersList(context,
          order: ordersList.where((e) {
            if (e.orderType == '3')
              return true;
            else
              return false;
          }).toList()));
    }
    return tabWidgets;
  }

  Widget orderListItem({@required Order order}) {
    return InkWell(
        child: ListTile(
          leading: Text(order.orderNo.toString()),
          title: order.orderType == '1'
              ? Text(
                  'ORDER#: ${order.orderNo} | TIME: ${order.time} | TABLE: ${order.tableId}',
                  style:
                      TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
                )
              : Text(
                  'ORDER#: ${order.orderNo} | TIME: ${order.time} | CUSTOMER: ${order.customer}',
                  style:
                      TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
                ),
        ),
        onDoubleTap: () {});
  }

  Widget getListItemExpansion(
      {@required BuildContext context, @required Order order}) {
    return ExpansionTile(
      title: order.orderType == '1'
          ? Text(
              'ORDER#: ${order.orderNo} | TIME: ${order.time} | TABLE: ${order.tableId}',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            )
          : Text(
              'ORDER#: ${order.orderNo} | TIME: ${order.time} | CUSTOMER: ${order.customer}',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
      leading: Text(order.orderNo.toString()),
      trailing: Icon(Icons.arrow_drop_down),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_rounded),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/pos', arguments: order);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.monetization_on_outlined),
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/payment', arguments: order),
                ),
                IconButton(
                  icon: Icon(Icons.delete_rounded),
                  onPressed: () async {
                    await AppTheme.showAlertDialogYN(context,
                        title: 'Delete Order',
                        message: 'Are You Sure?',
                        onNo: () => Navigator.of(context).pop(false),
                        onYes: () {
                          Navigator.of(context).pop(true);
                        });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget getOrdersList(BuildContext context, {List<Order> order}) {
    if (order.length < 1) {
      return Center(
        child: Text(
          'No Pending Orders Available',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      );
    }
    return false
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: order.length,
            itemBuilder: (context, index) {
              return getListItemExpansion(
                  context: context, order: order[index]);
            },
          )
        : GridView.builder(
            shrinkWrap: true,
            itemCount: order.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemBuilder: (context, index) =>
                _OrdersGridItem(order: order[index]),
          );
  }
}
