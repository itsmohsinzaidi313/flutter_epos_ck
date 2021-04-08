import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/models/objects/customer_table.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/models/objects/waiter.dart';
import 'package:pos_app/pages/order_info_screen.dart';
import 'package:pos_app/repositories/tables_repository.dart';
import 'package:pos_app/repositories/waiters_repository.dart';
import '../shared/config.dart';
import '../shared/widgets/dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController closingAmount = TextEditingController();
  bool checkField = false;
  String errorMessage = 'Required';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 0.0,
          title: Row(
            children: [
              Text('User: ${Config.user.name}'),
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
          children: [
            DashboardCard(
                title: 'New Order',
                asset: 'cutlery.png',
                onTap: () async {
                  ServerResponse response1 = await WaiterRepo.repo.waiters;
                  ServerResponse response2 = await TablesRepo.repo.tables;
                  if (response1.status && response2.status) {
                    final List<Waiter> waiters =
                        (response1.data as List<dynamic>)
                            .map((e) => Waiter.fromJson(e))
                            .toList();
                    final List<Tables> tables =
                        (response2.data as List<dynamic>)
                            .map((e) => Tables.fromJson(e))
                            .toList();
                    return Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (_) => OrderInfoBloc(),
                        child: NewOrderInfoScreen(
                          waiters: waiters,
                          tables: tables,
                        ),
                      ),
                    ));
                  }
                }),
          ],
        ));
  }
}
