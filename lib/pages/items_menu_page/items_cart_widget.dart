part of 'items_menu_page.dart';

class _ItemsCart extends StatelessWidget {
  final String subTotal;
  final String taxAmount;
  final String totalAmount;
  final bool amountDescriptions;
  final List<Item> items;

  final void Function(BuildContext context, Item item) onTap;
  final void Function(BuildContext context, Item item) onAddItem;
  final void Function(BuildContext context, Item item) onReduceItem;
  final void Function(BuildContext context, Item item) onRemoveItem;
  final void Function(BuildContext context, Item, String) onQuantityChanged;
  final void Function(BuildContext context, String value, Item item)
      onItemCommentChanged;
  const _ItemsCart({
    Key key,
    this.subTotal,
    this.taxAmount,
    this.totalAmount,
    this.amountDescriptions = true,
    this.items,
    this.onTap,
    this.onAddItem,
    this.onItemCommentChanged,
    this.onQuantityChanged,
    this.onReduceItem,
    this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: items
                      .map(
                        (e) => _CartItemTile(
                          item: e,
                          onTap: onTap,
                          onAddItem: onAddItem,
                          onItemCommentChanged: onItemCommentChanged,
                          onQuantityChanged: onQuantityChanged,
                          onReduceItem: onReduceItem,
                          onRemoveItem: onRemoveItem,
                        ),
                      )
                      .toList() ??
                  [],
            ),
          ),
        ),
        Divider(),
        amountDescriptions
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Subtotal'.toUpperCase())),
                        Text(subTotal),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Tax'.toUpperCase())),
                        Text(taxAmount),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(child: Text('Total'.toUpperCase())),
                        Text(totalAmount),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
