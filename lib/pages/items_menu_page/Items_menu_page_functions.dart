part of 'items_menu_page.dart';

void _onAddItem(BuildContext context, Item item) {
  if (item is OnSpotDeal) {
    passEvent(context, AddOnSpotDeal(deal: item));
  } else {
    passEvent(
      context,
      AddItem(
        code: item.code,
        itemId: int.parse(item.id),
      ),
    );
  }
}

void _onReduceItem(BuildContext context, Item item) {
  if (item is OnSpotDeal) {
    ReduceOnSpotDeal(deal: item);
  } else {
    passEvent(
      context,
      ReduceItem(
        code: item.code,
        itemId: int.parse(item.id),
      ),
    );
  }
}

void _onQuantityChanged(BuildContext context, Item item, String value) {
  if (item is OnSpotDeal) {
    passEvent(
        context,
        OnSpotDealQuantityChanged(
            deal: item, quantity: int.tryParse(value) ?? 0.0));
  } else {
    passEvent(
      context,
      ItemQuantityChanged(
        code: item.code,
        itemId: int.parse(item.id),
        quantity: double.tryParse(value) ?? 0.0,
      ),
    );
  }
}

void _onRemoveItem(BuildContext context, Item item) {
  if (item is OnSpotDeal) {
    passEvent(context, RemoveOnSpotDeal(deal: item));
  } else {
    passEvent(
      context,
      RemoveItem(
        code: item.code,
        itemId: int.parse(item.id),
      ),
    );
  }
}

Future<void> _onItemCommentChanged(
    BuildContext context, String value, Item item) async {
  passEvent(
    context,
    AddComment(
      code: item.code,
      itemId: int.parse(item.id),
      comment: value ?? '',
    ),
  );
}

void _onCartItemTap(BuildContext context, Item e) {
  if (e is OnSpotDeal) {
    _showDealDetail(context, e.name, e.dealItems);
  } else if (e is FixedDeal) {
    _showDealDetail(context, e.name, e.dealItems);
  }
}

Future<void> _showDealDetail(
    BuildContext context, String dealName, List<Item> dealItems) async {
  String itemNames = '';
  for (var item in dealItems) {
    itemNames += '${item.name} ${(item.quantity.toInt() + 1).toString()}\n';
  }
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        '$dealName',
        style: GoogleFonts.ubuntuCondensed(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          wordSpacing: 0.5,
        ),
      ),
      content: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          child: Text(
            itemNames,
            style: GoogleFonts.ubuntuCondensed(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              wordSpacing: 0.5,
            ),
          ),
        ),
      ),
    ),
  );
}

void passEvent(BuildContext context, ItemsMenuEvents event) =>
    context.read<ItemsMenuBloc>().add(event);
