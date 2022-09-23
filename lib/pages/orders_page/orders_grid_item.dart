part of 'orders_page.dart';

class _OrdersGridItem extends StatelessWidget {
  final Order order;
  final bool enablePayment;
  final bool enableOrderDelete;
  const _OrdersGridItem({
    Key? key,
    required this.order,
    this.enablePayment = false,
    this.enableOrderDelete = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(8.0)),
        child: ExpansionTile(
          title: Text('Order# ${order.orderNumber}'),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Amount'),
                    Text('${order.totalTaxedAmount}'),
                  ],
                ),
                Column(
                  children: [
                    Text('Time'),
                    Text(order.time),
                  ],
                ),
                Column(
                  children: [
                    Text('Table'),
                    Text(order.table.name),
                  ],
                ),
              ],
            ),
            SingleChildScrollView(
              child: DataTable(
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
            ),
          ],
        ),
      ),
    );
  }
}
