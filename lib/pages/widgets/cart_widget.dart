import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/pos_bloc/pos_bloc.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/pages/widgets/app_widgets.dart';

final TextStyle titleStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

final TextStyle textStyle = TextStyle(
  color: Colors.black,
);
Widget cartWidget(
    {BuildContext context,
    List<Item> items,
    String subTotal,
    String totalAmount,
    String taxAmount,
    bool amountDescriptions = true,
    void Function(Item item) onAddItem,
    void Function(Item item) onReduceItem,
    void Function(Item item) onRemoveItem,
    void Function(Item, String) onQuantityChanged,
    void Function(Item item) onItemCommentPressed}) {
  if (items.length < 1) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          // scale: 10,
          image: AssetImage(
            'assets/empty_cart.png',
          ),
        ),
      ),
    );
  } else {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      amountDescriptions
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Subtotal'.toUpperCase(),
                          style: titleStyle,
                        ),
                        Text(
                          subTotal,
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Tax'.toUpperCase(),
                          style: titleStyle,
                        ),
                        Text(
                          taxAmount,
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Total'.toUpperCase(),
                          style: titleStyle,
                        ),
                        Text(
                          totalAmount,
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(),
      Divider(),
      Expanded(
        child: ListView(
          children: items
                  .map(
                    (e) => cartItemTile(
                      context: context,
                      item: e,
                      onTap: () =>
                          e is OnSpotDeal ? showDealDetail(context, e) : null,
                      onAddItem: () => onAddItem(e),
                      onItemCommentPressed: () => onItemCommentPressed(e),
                      onQuantityChanged: (value) => onQuantityChanged(e, value),
                      onReduceItem: () => onReduceItem(e),
                      onRemoveItem: () => onRemoveItem(e),
                    ),
                  )
                  .toList() ??
              [],
        ),
      )
    ]);
  }
}

class CartWidget extends StatefulWidget {
  const CartWidget({Key key}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget>
    with SingleTickerProviderStateMixin {
  String subTotal;
  String totalAmount;
  String taxAmount;
  bool amountDescriptions = true;
  List<Item> items;
  GlobalKey<AnimatedListState> _cartKey;
  ScrollController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = ScrollController();
    _cartKey = GlobalKey<AnimatedListState>();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) {
      return BlocListener<POSBloc, POSState>(
        listener: (context, state) {
          if (state is CartItems) {
            subTotal = state.subTotal;
            taxAmount = state.taxAmount;
            totalAmount = state.totalAmount;
            items = state.list;
          }
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              // scale: 10,
              image: AssetImage(
                'assets/empty_cart.png',
              ),
            ),
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          amountDescriptions
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Subtotal'.toUpperCase(),
                              style: titleStyle,
                            ),
                            Text(
                              subTotal,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Tax'.toUpperCase(),
                              style: titleStyle,
                            ),
                            Text(
                              taxAmount,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Total'.toUpperCase(),
                              style: titleStyle,
                            ),
                            Text(
                              totalAmount,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Divider(),
          Expanded(
            child: AnimatedList(
              key: _cartKey,
              controller: _animationController,
              itemBuilder: (context, index, animation) => SlideTransition(
                position: animation.drive(
                  Tween(
                    begin: Offset(0, 0),
                    end: Offset(1, 0),
                  ),
                ),
                child: cartItemTile(
                  item: items[index],
                  context: context,
                  onReduceItem: () {
                    if (items[index] is OnSpotDeal) {
                      ReduceOnSpotDeal(deal: items[index]);
                    } else {
                      passEvent(
                        context,
                        ReduceItem(
                          code: items[index].code,
                          itemId: int.parse(items[index].id),
                        ),
                      );
                    }
                  },
                  onAddItem: () {
                    if (items[index] is OnSpotDeal) {
                      passEvent(context, AddOnSpotDeal(deal: items[index]));
                    } else {
                      passEvent(
                        context,
                        AddItem(
                          code: items[index].code,
                          itemId: int.parse(items[index].id),
                        ),
                      );
                    }
                  },
                  onQuantityChanged: (value) {
                    if (items[index] is OnSpotDeal) {
                      passEvent(
                          context,
                          OnSpotDealQuantityChanged(
                              deal: items[index],
                              quantity: int.tryParse(value) ?? 0.0));
                    } else {
                      passEvent(
                        context,
                        ItemQuantityChanged(
                          code: items[index].code,
                          itemId: int.parse(items[index].id),
                          quantity: double.tryParse(value) ?? 0.0,
                        ),
                      );
                    }
                  },
                  onRemoveItem: () {
                    if (items[index] is OnSpotDeal) {
                      passEvent(context, RemoveOnSpotDeal(deal: items[index]));
                    } else {
                      passEvent(
                        context,
                        RemoveItem(
                          code: items[index].code,
                          itemId: int.parse(items[index].id),
                        ),
                      );
                    }
                  },
                  onItemCommentPressed: () async {
                    String comments =
                        await openItemCommentDialog(context, items[index].name);
                    passEvent(
                        context,
                        AddComment(
                            code: items[index].code,
                            itemId: int.parse(items[index].id),
                            comment: comments));
                  },
                ),
              ),
            ),
          )
        ],
      );
    }
  }

  bool itemExists(Item item) {
    for (var e in items) {
      if (e.id == item.id) return true;
    }
    return false;
  }

  void updateAnimatedList(List<Item> listItems) {
    for (var item in listItems) {
      if (!itemExists(item)) {
        
      }
    }
  }

  void passEvent(BuildContext context, POSEvents event) =>
      context.read<POSBloc>().add(event);
}
