part of 'items_menu_page.dart';

void _updateLayout(BuildContext context) =>
    _passEvent(context, UpdateItemsMenu());

void _onNextPressed(BuildContext context) => _passEvent(context, PostOrder());

void _onSuggestionSelected(
  BuildContext context,
  Item item,
) {
  if (item is OnSpotDeal) {
  } else if (item is FixedDeal) {
  } else if (item is FoodItem) {}
}

void _onIncreaseItem(BuildContext context, int index) {
  _passEvent(context, IncreaseItem(index: index));
}

void _onReduceItem(BuildContext context, int index) {
  _passEvent(context, DecreaseItem(index: index));
}

void _onRemoveItem(BuildContext context, int index) {
  _passEvent(context, RemoveItem(index: index));
}

Future<void> _onItemCommentChanged(
    BuildContext context, String value, int index) async {
  _passEvent(context, AddComment(index: index, value: value));
}

void _onCartItemTap(BuildContext context, int index) {}

Future<void> _onMenuItemPressed(
  BuildContext context,
  List<Category>? listCategories,
  Item item,
) async {
  if (item.code == Item.OPENFOOD_CODE.toString()) {
    openFoodDialog(context, item.categoryId).then((openItem) {
      if (openItem != null) {
        // _passEvent(context, AddOpenItem(openItem: openItem));
      }
    });
  } else if (item is OnSpotDeal) {
    try {
      final x = OnSpotDeal.modify(item);
      final deal = await showOnSpotDealDialog(
        context: context,
        onSpotDeal: x,
      );
      if (deal != null && deal.quantity <= 0) {
        _passEvent(context, AddMenuItem(item: deal));
      } else {
        AppTheme.snackbar(context, 'Deal cancelled');
      }
    } catch (e) {
      print(e);
    }
  } else if (item is FixedDeal) {
  } else if (item is FoodItem) {
    _passEvent(context, AddMenuItem(item: item));
  }
  _updateLayout(context);
}

Future<void> _showDealDetail(
    BuildContext context, String? dealName, List<Item> dealItems) async {
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

void _passEvent(BuildContext context, ItemsMenuEvents event) =>
    context.read<ItemsMenuBloc>().add(event);
