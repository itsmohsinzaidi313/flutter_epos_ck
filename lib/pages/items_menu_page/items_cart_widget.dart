part of 'items_menu_page.dart';

class _ItemsCart extends StatelessWidget {
  final String? subTotal;
  final String? taxAmount;
  final String? totalAmount;
  final bool amountDescriptions;
  final ItemsCart itemsCart;

  final void Function(BuildContext context, int index) onTap;
  final void Function(BuildContext context, int index) onIncreaseItem;
  final void Function(BuildContext context, int index) onReduceItem;
  final void Function(BuildContext context, int index) onRemoveItem;
  final void Function(BuildContext context, String quantity, int index)?
      onQuantityChanged;
  final void Function(BuildContext context, String value, int index)?
      onItemCommentChanged;
  const _ItemsCart({
    Key? key,
    required this.itemsCart,
    required this.onTap,
    required this.onIncreaseItem,
    required this.onReduceItem,
    required this.onRemoveItem,
    this.subTotal,
    this.taxAmount,
    this.totalAmount,
    this.amountDescriptions = true,
    this.onItemCommentChanged,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: itemsCart.items.length,
            itemBuilder: (context, index) => _CartItemTile(
              item: itemsCart.items[index],
              onTap: (context, item) => onTap(context, index),
              onIncreaseItem: (context, item) =>
                  onIncreaseItem(context, index),
              onItemCommentChanged: (context, comment, item) =>
                  onItemCommentChanged!(context, comment, index),
              onQuantityChanged: (context, item, quantity) =>
                  onQuantityChanged!(context, quantity, index),
              onReduceItem: (context, item) => onReduceItem(context, index),
              onRemoveItem: (context, item) => onRemoveItem(context, index),
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
                        Text(subTotal!),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Tax'.toUpperCase())),
                        Text(taxAmount!),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(child: Text('Total'.toUpperCase())),
                        Text(totalAmount!),
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
