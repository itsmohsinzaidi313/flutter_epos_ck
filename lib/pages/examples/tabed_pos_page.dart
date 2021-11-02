import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/pages/widgets/app_widgets.dart';
import 'package:pos_app/shared/config.dart';

class TabbedPOSPage extends StatefulWidget {
  const TabbedPOSPage({Key key}) : super(key: key);

  @override
  _TabbedPOSPageState createState() => _TabbedPOSPageState();
}

class _TabbedPOSPageState extends State<TabbedPOSPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs = [];
  List<Widget> _tabViews = [];
  void passEvent(BuildContext context, POSEvents event) =>
      context.read<POSBloc>().add(event);

  @override
  void initState() {
    super.initState();
  }

  bool ranOnce = false;

  @override
  Widget build(BuildContext context) {
    if (!ranOnce) {
      passEvent(context, POSBuild());
      ranOnce = true;
    }
    return BlocListener<POSBloc, POSState>(
      listener: (context, state) {
        if (state is POSMenuLoaded) {
          log('Incoming menu');
          log('end');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tabbed Pos Page'),
        ),
        body: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 6,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    // flex: 3,
                    child: BlocBuilder<POSBloc, POSState>(
                      buildWhen: (previous, current) {
                        if (current is POSMenuLoaded)
                          return true;
                        else
                          return false;
                      },
                      builder: (context, state) {
                        if (state is POSMenuLoaded) {
                          _tabs.clear();
                          _tabViews.clear();
                          _tabs = state.menu.listCategories.map(
                            (e) {
                              List<Item> items = state.menu.listItems
                                  .where(
                                      (element) => element.categoryId == e.id)
                                  .toList();
                              _tabViews.add(
                                GridView.count(
                                  crossAxisCount: items.length,
                                  children: items
                                      .map(
                                        (f) => ItemButton(
                                          item: f,
                                          onTap: () {},
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                              return Tab(
                                child: categoryButton(
                                    context: context,
                                    category: e,
                                    text: e.name),
                              );
                            },
                          ).toList();
                          return DefaultTabController(
                            length: _tabs.length,
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Flexible(
                                  child: TabBar(tabs: _tabs),
                                ),
                                Flexible(
                                  child: TabBarView(
                                    children: _tabViews,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  // Flexible(
                  //   flex: 6,
                  //   child: Container(),
                  // ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(),
            ),
          ],
        ),
      ),
    );
  }
}
