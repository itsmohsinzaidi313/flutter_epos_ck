import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/shared/app_theme.dart';
import 'package:pos_app/shared/config.dart';

part 'orders_grid_item.dart';
part 'grid_box_tile.dart';
part 'flip_tile.dart';

class OrdersPage extends StatefulWidget {
  static const String path = 'orders_page';
  const OrdersPage();

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  final enablePayment = false;
  final enableOrderDelete = false;

  void _passEvent(BuildContext context, OrdersBlocEvent event) =>
      context.read<OrdersBloc>().add(event);
  int bottomNavItemIndex = 0;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    List<Tab> tabs = [];

    Tab dineInTab = Tab(child: Text('DINE IN'));
    Tab takeAwayTab = Tab(child: Text('TAKE AWAY'));
    Tab deliveryTab = Tab(child: Text('DELIVERY'));
    final tabsBuffer = [dineInTab, takeAwayTab, deliveryTab];

    if (Config.allowDineIn) tabs.add(tabsBuffer[0]);
    if (Config.allowTakeAway) tabs.add(tabsBuffer[1]);
    if (Config.allowDelivery) tabs.add(tabsBuffer[2]);
    _tabController = TabController(length: tabs.length, vsync: this);
    _passEvent(context, FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBarNormal(
          appBarTitle: 'Pending Orders',
          appBarElevation: 0.0,
          context: context,
          // bottom: TabBar(
          //   tabs: tabs,
          // ),
          actions: [
            ElevatedButton(
              child: Row(
                children: [
                  Icon(Icons.sync),
                  Text('Refresh'),
                ],
              ),
              onPressed: () => _passEvent(context, FetchOrders()),
            )
          ]) as PreferredSizeWidget?,
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
          } else if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            child: TabBarView(
              controller: _tabController,
              children: tabs,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavItemIndex,
        onTap: (int value) {
          switch (value) {
            case 0:
              _tabController.index = 0;
              break;
            case 1:
              _tabController.index = 1;
              break;
            case 2:
              _tabController.index = 2;
              break;
            default:
              break;
          }
          setState(() => bottomNavItemIndex = _tabController.index);
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
      ),
    );
  }

  List<Widget> getTabWidgets(BuildContext context, List<Order> ordersList) {
    final tabWidgets = <Widget>[];
    if (Config.allowDineIn) {
      tabWidgets.add(getOrdersView(context,
          orders: ordersList.where((e) {
            if (e.orderType.index + 1 == 1)
              return true;
            else
              return false;
          }).toList()));
    }
    if (Config.allowTakeAway) {
      tabWidgets.add(getOrdersView(context,
          orders: ordersList.where((e) {
            if (e.orderType.index + 1 == 2)
              return true;
            else
              return false;
          }).toList()));
    }
    if (Config.allowDelivery) {
      tabWidgets.add(getOrdersView(context,
          orders: ordersList.where((e) {
            if (e.orderType.index + 1 == 3)
              return true;
            else
              return false;
          }).toList()));
    }
    return tabWidgets;
  }

  Widget getOrdersView(BuildContext context, {required List<Order> orders}) {
    if (orders.length < 1) {
      return Center(
        child: Text(
          'No Pending Orders Available',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) => Container(
        width: 100,
        height: 100,
        child: _FlipTile(
          order: orders[index],
        ),
      ),
    );
  }
}
