import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/models/objects/waiter.dart';
import 'package:pos_app/pages/pos_screen.dart';
import 'package:pos_app/repositories/categories_repository.dart';
import 'package:pos_app/repositories/menu_items_repository.dart';
import '../shared/app_theme.dart';
import '../shared/config.dart';
import '../models/objects/customer_table.dart' as t;
import 'package:google_fonts/google_fonts.dart';

class NewOrderInfoScreen extends StatefulWidget {
  final List<Waiter> waiters;
  final List<t.Tables> tables;
  NewOrderInfoScreen({this.waiters, this.tables});
  @override
  _NewOrderInfoScreenState createState() =>
      _NewOrderInfoScreenState(waiterList: waiters, tableList: tables);
}

class _NewOrderInfoScreenState extends State<NewOrderInfoScreen> {
  List<Waiter> waiterList;
  List<t.Tables> tableList;
  _NewOrderInfoScreenState({this.waiterList, this.tableList});

  bool customerExists = true;
  int customerId = 0;
  String errorMsg;
  bool takeawaySearchButton = false;
  bool deliverySearchButton = false;
  ImageProvider dineIn, takeAway, delivery;
  bool waiterSelected = false;

  List<TextEditingController> controllers = [
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
  ];

  List<bool> check = [false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    dineIn = AssetImage('assets/dine_in.jpg');
    takeAway = AssetImage('assets/takeaway.jpg');
    delivery = AssetImage('assets/delivery.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderInfoBloc, OrderInfoState>(
      listener: (context, state) async {
        switch (state.orderType) {
          case ORDERTYPE.DINE_IN:
            if (state is WaitersState) {
              waiterSelected = false;
            }
            if (state is TablesState) {
              waiterSelected = true;
            }
            if (state is InvalidCovers) {
              snackbar(state.message);
            }
            if (state is InvalidTables) {
              snackbar(state.message);
            }
            if (state is InvalidWaiter) {
              snackbar(state.message);
            }

            break;
          case ORDERTYPE.TAKE_AWAY:
            if (state is InvalidCustomer) {
              snackbar(state.message);
            }
            if (state is InvalidContact) {
              snackbar(state.message);
            }
            break;
          case ORDERTYPE.DELIVERY:
            if (state is InvalidCustomer) {
              snackbar(state.message);
            }
            if (state is InvalidContact) {
              snackbar(state.message);
            }
            if (state is InvalidAddress) {
              snackbar(state.message);
            }
            break;
          default:
            break;
        }
        if (state is ValidSubmission) {
          final catResponse = await CategoryRepo.repo.categories;
          if (catResponse.status) {
            final listCategories = (catResponse.data as List<dynamic>)
                .map((e) => Category.fromJson(e))
                .toList();
          final itemResponse = await MenuItemRepo.repo.allItems;
          if (itemResponse.status) {
            final listItems = (itemResponse.data as List<dynamic>)
                .map((e) => MenuItem.fromJson(e))
                .toList();

                Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => POSBloc(customerOrder: state.customerOrder, listCategories: listCategories, listItems: listItems),
              child: PosScreen(),
            ),
          ));
        }
        }
          }
          
      },
      child:
          BlocBuilder<OrderInfoBloc, OrderInfoState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppTheme.appBarNormal(
              appBarTitle: 'Order Type',
              appBarBgColor: AppTheme.appBarColor,
              appBarElevation: 0.0,
              context: context),
          body: Container(
            height: Config.getDeviceHeight(context),
            width: Config.getDeviceWidth(context),
            child: Row(
              children: [
                Expanded(
                  child: layoutController(state),
                ),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          orderTypeButton(
                              'Dine-In',
                              () => context.read<OrderInfoBloc>().add(
                                  OrderTypeChanged(type: ORDERTYPE.DINE_IN)),
                              dineIn),
                          orderTypeButton(
                              'Takeaway',
                              () => context.read<OrderInfoBloc>().add(
                                  OrderTypeChanged(type: ORDERTYPE.TAKE_AWAY)),
                              takeAway),
                          orderTypeButton(
                              'Delivery',
                              () => context.read<OrderInfoBloc>().add(
                                  OrderTypeChanged(type: ORDERTYPE.DELIVERY)),
                              delivery),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget layoutController(OrderInfoState state) {
    switch (state.orderType) {
      case ORDERTYPE.DINE_IN:
        return BlocProvider.value(
          value: BlocProvider.of<OrderInfoBloc>(context),
          child: DineInLayout(
            listWaiters: waiterList,
            listTables: tableList,
          ),
        );
        break;
      case ORDERTYPE.TAKE_AWAY:
        return BlocProvider.value(
          value: BlocProvider.of<OrderInfoBloc>(context),
          child: TakeAwayLayout(),
        );
        break;
      case ORDERTYPE.DELIVERY:
        return BlocProvider.value(
          value: BlocProvider.of<OrderInfoBloc>(context),
          child: DeliveryLayout(),
        );
        break;
      default:
        return Container();
        break;
    }
  }

  void snackbar(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Widget orderTypeButton(String title, Function onTap, ImageProvider image) =>
      Card(
        color: Color(0xff7c94b6),
        elevation: 5,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: image,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.dstATop),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 2,
            ),
            height: Config.getDeviceHeight(context) * 0.25,
            width: Config.getDeviceWidth(context),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                title,
                style: GoogleFonts.ptSans(
                  fontSize: 35,
                  letterSpacing: 3.0,
                  wordSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
}

class DineInLayout extends StatelessWidget {
  final List<Waiter> listWaiters;
  final List<t.Tables> listTables;
  Waiter selectedWaiter;
  t.Tables selectedTable;
  String covers;

  DineInLayout({this.listWaiters, this.listTables});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderInfoBloc, OrderInfoState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Card(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ListTile(
                          title: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey.shade200,
                              border: Border(
                                left: BorderSide(
                                  color: Colors.yellow.shade700,
                                  width: 3.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: TextField(
                              cursorColor: Colors.yellow[700],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.group,
                                    color: Colors.yellow.shade800,
                                    size: 20,
                                  ),
                                  hintText: 'Covers',
                                  border: InputBorder.none,
                                  errorText: null),
                              onChanged: (value) => covers = value,
                            ),
                          ),
                        ),
                        ListTile(
                          title: TextButton(
                            child: Text('OK',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () =>
                                context.read<OrderInfoBloc>().add(Submit(
                                      type: ORDERTYPE.DINE_IN,
                                      covers: covers,
                                      waiter: selectedWaiter,
                                      table: selectedTable,
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  color: Colors.white70,
                  child: DineInGrid(
                    listTables: listTables,
                    listWaiters: listWaiters,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget waitersGridView() => GridView.builder(
        itemCount: listWaiters.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) => Container(
          child: Card(
            color: true ? Colors.redAccent[200] : Colors.white,
            child: InkWell(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: Text(
                      listWaiters[index].name.toUpperCase(),
                      style: GoogleFonts.ubuntuCondensed(
                        color: true ? Colors.black : Colors.grey[800],
                        fontSize: 14,
                        letterSpacing: 1.0,
                        wordSpacing: 1.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage('assets/waiter.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                selectedWaiter = listWaiters[index];
                context.read<OrderInfoBloc>().add(
                      WaiterChanged(
                        type: ORDERTYPE.DINE_IN,
                        waiter: listWaiters[index],
                      ),
                    );
              },
            ),
          ),
        ),
      );

  Widget tablesGridView() => GridView.builder(
        itemCount: listTables.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) => Card(
          elevation: 10,
          color: Colors.grey.shade100,
          child: InkWell(
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Text(
                      listTables[index].tableName,
                      style: GoogleFonts.ubuntuCondensed(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        letterSpacing: 1.0,
                        wordSpacing: 1.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Image(
                        image: AssetImage('assets/table.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(-1, -1),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(Icons.check),
                    ),
                  ),
                ],
              ),
              onTap: () {
                selectedTable = listTables[index];
                context.read<OrderInfoBloc>().add(TableChanged(
                    type: ORDERTYPE.DINE_IN, table: listTables[index]));
              }),
        ),
      );
}

class DineInGrid extends StatefulWidget {
  final List<Waiter> listWaiters;
  final List<t.Tables> listTables;
  DineInGrid({this.listTables, this.listWaiters});

  @override
  _DineInGridState createState() {
    return _DineInGridState(listTables: listTables, listWaiters: listWaiters);
  }
}

class _DineInGridState extends State<DineInGrid> {
  List<Waiter> listWaiters;
  List<t.Tables> listTables;
  Waiter selectedWaiter;
  t.Tables selectedTable;
  bool waiterSelected = false;

  _DineInGridState({this.listTables, this.listWaiters});
  @override
  void initState() {
    super.initState();
    context
        .read<OrderInfoBloc>()
        .add(TableChanged(type: ORDERTYPE.DINE_IN, table: t.Tables()));
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<OrderInfoBloc, OrderInfoState>(
        listener: (context, state) {
          if (state is InvalidCovers) {
            snackbar(state.message);
          } else if (state is InvalidTables) {
            snackbar(state.message);
          } else if (state is InvalidWaiter) {
            snackbar(state.message);
          } else if (state is TablesState) {
            waiterSelected = true;
          } else if (state is WaitersState) {
            waiterSelected = false;
          }
        },
        child: waiterSelected ? tablesGridView() : waitersGridView(),
      );

  void snackbar(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Widget waitersGridView() => GridView.builder(
        itemCount: listWaiters.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) => Container(
          child: Card(
            color: true ? Colors.redAccent[200] : Colors.white,
            child: InkWell(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: Text(
                      listWaiters[index].name.toUpperCase(),
                      style: GoogleFonts.ubuntuCondensed(
                        color: true ? Colors.black : Colors.grey[800],
                        fontSize: 14,
                        letterSpacing: 1.0,
                        wordSpacing: 1.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage('assets/waiter.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                selectedWaiter = listWaiters[index];
                context.read<OrderInfoBloc>().add(
                      WaiterChanged(
                        type: ORDERTYPE.DINE_IN,
                        waiter: listWaiters[index],
                      ),
                    );
              },
            ),
          ),
        ),
      );

  Widget tablesGridView() => GridView.builder(
        itemCount: listTables.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) => Card(
          elevation: 10,
          color: Colors.grey.shade100,
          child: InkWell(
            child: Stack(
              children: [
                Positioned(
                  top: 2,
                  left: 2,
                  child: Text(
                    listTables[index].tableName,
                    style: GoogleFonts.ubuntuCondensed(
                      color: Colors.grey.shade900,
                      fontSize: 16,
                      letterSpacing: 1.0,
                      wordSpacing: 1.0,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: Image(
                      image: AssetImage('assets/table.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(-1, -1),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(Icons.check),
                  ),
                ),
              ],
            ),
            onTap: () {
              selectedTable = listTables[index];
              context.read<OrderInfoBloc>().add(
                    TableChanged(
                        type: ORDERTYPE.DINE_IN, table: listTables[index]),
                  );
            },
          ),
        ),
      );
}

class TakeAwayLayout extends StatefulWidget {
  @override
  _TakeAwayLayoutState createState() => _TakeAwayLayoutState();
}

class _TakeAwayLayoutState extends State<TakeAwayLayout> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DeliveryLayout extends StatefulWidget {
  @override
  _DeliveryLayoutState createState() => _DeliveryLayoutState();
}

class _DeliveryLayoutState extends State<DeliveryLayout> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
