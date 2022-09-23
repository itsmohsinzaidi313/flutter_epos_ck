part of 'orders_page.dart';

class _FlipTile extends StatefulWidget {
  final Order order;
  final Duration duration;
  const _FlipTile({
    Key? key,
    required this.order,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _FlipTileState createState() => _FlipTileState();
}

class _FlipTileState extends State<_FlipTile> {
  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _flip,
        child: Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: angle),
                    duration: widget.duration,
                    builder: (BuildContext context, double val, Widget? _) {
                      if (val >= (pi / 2)) {
                        isBack = false;
                      } else {
                        isBack = true;
                      }
                      return (Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(val),
                        child: isBack
                            ? _FrontSide(order: widget.order)
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: _BackSide(order: widget.order),
                              ),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FrontSide extends StatelessWidget {
  final Order order;
  const _FrontSide({Key? key, required this.order}) : super(key: key);
  TextStyle get _textStyle => TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#${order.orderNumber}',
                style: TextStyle(
                  fontSize: 84,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '(Table) ',
                    style: _textStyle,
                  ),
                  Text(
                    order.table.name,
                    style: _textStyle,
                  )
                ]),
              ),
              Flexible(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '(Waiter) ',
                    style: _textStyle,
                  ),
                  Text(
                    order.waiter.name,
                    style: _textStyle,
                  )
                ]),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class _BackSide extends StatelessWidget {
  final Order order;
  const _BackSide({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Expanded(child: Text('Item'))),
                    DataColumn(label: Text('Qty'))
                  ],
                  rows: order.cart.items
                      .map(
                        (e) => DataRow(cells: [
                          DataCell(Text(e.name)),
                          DataCell(Text('${e.quantity}')),
                        ]),
                      )
                      .toList(),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL AMOUNT',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            order.totalTaxedAmount,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
