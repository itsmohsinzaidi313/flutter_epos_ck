part of 'items_menu_page.dart';

final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(32.0));
Future<OnSpotDeal?> showOnSpotDealDialog(
        {required BuildContext context, OnSpotDeal? onSpotDeal}) async =>
    await showDialog<OnSpotDeal>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
        child: Container(
          width: Config.getDeviceWidth(context) * 0.8,
          height: Config.getDeviceHeight(context) * 0.8,
          child: OnSpotDealPage(
            deal: onSpotDeal,
          ),
        ),
      ),
    );

class OnSpotDealPage extends StatefulWidget {
  final OnSpotDeal? deal;
  OnSpotDealPage({this.deal});
  @override
  _OnSpotDealPageState createState() => _OnSpotDealPageState();
}

class _OnSpotDealPageState extends State<OnSpotDealPage>
    with TickerProviderStateMixin {
  List<Tab> _tabs = [];
  TabController? _tabController;
  TabBarView? _tabBarView;

  @override
  void initState() {
    _tabController = TabController(
      length: widget.deal!.dealSteps.length,
      vsync: this,
    );

    super.initState();
  }

  double _limit(OnSpotDealItem item) =>
      double.tryParse(widget.deal!.dealSteps.where((element) => element.id == item.dealStepId)
          .first
          .limit!) ??
      0;
  double _seletedQuantity(String? categoryId) {
    double total = 0;
    for (OnSpotDealItem dealItem in widget.deal!.dealItems) {
      if (dealItem.categoryId == categoryId) {
        total += dealItem.quantity;
      }
    }
    return total;
  }

  void _buildLayout() {
    _tabs = widget.deal!.dealSteps.map((e) => Tab(
              text: e.name!.toUpperCase(),
            ))
        .toList();
    List<Widget> tabViews = [];
    for (var i = 0; i < widget.deal!.dealSteps.length; i++) {
      List<Widget> buttons = [];
      for (var j = 0; j < widget.deal!.dealItems.length; j++) {
        if (widget.deal!.dealSteps[i].id ==
            widget.deal!.dealItems[j].dealStepId) {
          if (widget.deal!.dealSteps[i].limit == '0') {
            widget.deal!.dealItems[j] = OnSpotDealItem.modify(
              widget.deal!.dealItems[j],
              selected: true,
            );
          }
          buttons.add(
            itemButton2(
              item: widget.deal!.dealItems[j],
              selected: widget.deal!.dealItems[j].selected,
              subtitle:
                  '(${widget.deal!.dealItems[j].quantity.toDouble()}|${_limit(widget.deal!.dealItems[j])})',
              showSubtitle: true,
              isSelectable: true,
              onTap: () => _addItem(j),
            ),
          );
        }
      }
      tabViews.add(GridView.count(
        crossAxisCount: 5,
        children: buttons,
      ));
    }
    _tabBarView = TabBarView(
      controller: _tabController,
      children: tabViews,
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildLayout();
    return Scaffold(
      // borderRadius: _borderRadius,
      floatingActionButton: FloatingActionButton(
        heroTag: '0',
        child: Icon(Icons.check),
        onPressed: () => createDeal(),
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Steps'.toUpperCase(),
                            style: GoogleFonts.staatliches(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5.0,
                            ),
                          ),
                        ),
                        Container(
                          height: Config.getDeviceHeight(context) * 0.12,
                          padding: EdgeInsets.only(top: 5),
                          // decoration: BoxDecoration(border: Border.all(width: 2)),
                          child: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            tabs: _tabs,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Items'.toUpperCase(),
                            style: GoogleFonts.staatliches(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 5.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 5),
                            child: _tabBarView,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addItem(int itemIndex) {
    final OnSpotDealItem item = widget.deal!.dealItems[itemIndex];
    if (_limit(item) < 1) {
      AppTheme.snackbar(
        context,
        'Fixed item cannot be modified.',
        duration: 1,
      );
    } else if (_seletedQuantity(item.categoryId) < _limit(item)) {
      setState(() {
        widget.deal!.dealItems[itemIndex] = OnSpotDealItem.modify(
          item,
          quantity: item.quantity+ 1,
          selected: true,
        );
      });
    } else {
      setState(() {
        widget.deal!.dealItems[itemIndex] = OnSpotDealItem.modify(
          item,
          quantity: 0,
          selected: false,
        );
      });
    }
  }

  void createDeal() {
    Navigator.of(context).pop();
  }
}
