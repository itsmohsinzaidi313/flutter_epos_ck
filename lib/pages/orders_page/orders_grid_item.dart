part of 'orders_page.dart';

class _OrdersGridItem extends StatelessWidget {
  final Order order;
  final bool enablePayment;
  final bool enableOrderDelete;
  const _OrdersGridItem({
    Key key,
    this.order,
    this.enablePayment = false,
    this.enableOrderDelete = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'ORDER#: ${order.orderNo}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // boxTile(title: 'SUBTOTAL', description: order.subTotal),
                  // Divider(),
                  // boxTile(title: 'TAX', description: order.totalTaxAmount),
                  // Divider(),
                  _GridBoxTile(
                      title: 'AMOUNT',
                      description: order.totalTaxedAmount,
                      fontWeight: FontWeight.bold),
                  Divider(),
                  _GridBoxTile(title: 'TIME', description: '${order.time}'),
                  Divider(),
                  order.orderType == '1'
                      ? _GridBoxTile(
                          title: 'TABLE', description: '${order.tableId}')
                      : Container(),
                  order.orderType != '1'
                      ? _GridBoxTile(
                          title: 'NAME', description: '${order.customer}')
                      : Container(),
                  order.orderType != '1' ? Divider() : Container(),
                  order.orderType != '1'
                      ? _GridBoxTile(
                          title: 'CONTACT',
                          description: '${order.customer.contact}')
                      : Container(),
                  order.orderType != '1' ? Divider() : Container(),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_rounded),
                    onPressed: () async {
                      order.editOrder = true;
                      await Navigator.of(context)
                          .pushNamed(ItemsMenuPage.path, arguments: order);
                    },
                  ),
                  enablePayment
                      ? IconButton(
                          icon: Icon(Icons.monetization_on_outlined),
                          onPressed: () async {
                            AppTheme.showAlertDialogYN(context,
                                title: 'Order Payment',
                                message: 'Are You Sure?',
                                onNo: () => Navigator.pop(context),
                                onYes: () {
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .pushNamed('/payment', arguments: order);
                                });
                          },
                        )
                      : Container(),
                  enableOrderDelete
                      ? IconButton(
                          icon: Icon(Icons.delete_rounded),
                          onPressed: () async {
                            AppTheme.showAlertDialogYN(context,
                                title: 'Delete Order',
                                message: 'Are You Sure?',
                                onNo: () => Navigator.pop(context),
                                onYes: () => Navigator.pop(context));
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
