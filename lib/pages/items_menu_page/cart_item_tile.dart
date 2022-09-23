part of 'items_menu_page.dart';

class _CartItemTile extends StatelessWidget {
  final Item item;
  final void Function(BuildContext context, Item? item) onTap;
  final void Function(BuildContext context, Item item) onIncreaseItem;
  final void Function(BuildContext context, Item item) onReduceItem;
  final void Function(BuildContext context, Item item) onRemoveItem;
  final void Function(BuildContext context, Item, String) onQuantityChanged;
  final void Function(BuildContext context, String value, Item? item)?
      onItemCommentChanged;

  const _CartItemTile({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onIncreaseItem,
    required this.onReduceItem,
    required this.onRemoveItem,
    required this.onQuantityChanged,
    this.onItemCommentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            // color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey)),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => onRemoveItem(context, item),
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: InkWell(
            onTap: () => onTap(context, item),
            child: Column(
              children: [
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${item.name.toUpperCase()}\n',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                              text:
                                  '${item.quantity}x${item.price}=${item.quantity * item.price}')
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(Icons.add),
                          ),
                          onTap: () => onIncreaseItem(context, item),
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Center(
                            child: Text(
                              '${item.quantity}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        InkWell(
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Icon(Icons.remove),
                          ),
                          onTap: () => onReduceItem(context, item),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: Colors.grey[300]!.withOpacity(0.2),
                        ),
                        child: TextField(
                          onChanged: (value) =>
                              onItemCommentChanged!(context, value, item),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'e.g. No mayo please',
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Icon(Icons.delete),
                      ),
                      onTap: () => onRemoveItem(context, item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
