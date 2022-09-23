part of 'order_info_page.dart';

enum DineInViewType { grid, list }

class DineInLayout extends StatefulWidget {
  final List<Waiter> waiters;
  final List<Tables> tables;
  final DineInViewType viewType;

  DineInLayout({
    required this.waiters,
    required this.tables,
    this.viewType = DineInViewType.list,
  });

  @override
  State<DineInLayout> createState() => _DineInLayoutState();
}

class _DineInLayoutState extends State<DineInLayout>
    with TickerProviderStateMixin {
  final orderType = OrderType.dineIn;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.group,
                            size: 20,
                          ),
                          label: Text('Covers'),
                          hintText: 'e.g 3',
                          border: InputBorder.none,
                          errorText: null),
                      onChanged: (value) =>
                          passEvent(context, CoversChanged(covers: value)),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(),
              ),
            ),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  tabs: [
                    Tab(
                      child: Text('Waiters'.toUpperCase()),
                    ),
                    Tab(
                      child: Text('Tables'.toUpperCase()),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Container(
                        child: widget.viewType == DineInViewType.grid
                            ? _WaitersGrid(
                                listWaiters: widget.waiters,
                                onTap: (context, waiter) => passEvent(
                                  context,
                                  WaiterChanged(waiter: waiter),
                                ),
                              )
                            : _WaitersList(
                                waitersList: widget.waiters,
                                onTap: (context, waiter) => passEvent(
                                  context,
                                  WaiterChanged(waiter: waiter),
                                ),
                              ),
                      ),
                      Container(
                        child: widget.viewType == DineInViewType.grid
                            ? _TablesGrid(
                                listTables: widget.tables,
                                onTap: (context, table) => passEvent(
                                  context,
                                  TableChanged(table: table),
                                ),
                              )
                            : _TablesList(
                                listTables: widget.tables,
                                onTap: (context, table) => passEvent(
                                  context,
                                  TableChanged(table: table),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void passEvent(BuildContext c, OrderInfoEvent event) =>
      c.read<OrderInfoBloc>().add(event);
}
