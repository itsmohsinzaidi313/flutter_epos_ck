import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/repositories/categories_repository.dart';
import 'package:pos_app/repositories/menu_items_repository.dart';
part 'pos_event.dart';
part 'pos_state.dart';

class POSBloc extends Bloc<POSEvents, POSState> {
  final Order customerOrder;
  final List<Category> listCategories;
  final List<MenuItem> listItems;
  POSBloc({this.customerOrder, this.listCategories, this.listItems})
      : super(PosInitial());

  @override
  Stream<POSState> mapEventToState(
    POSEvents event,
  ) async* {
    try {
      if (state is PosInitial) {
        yield CategoriesLoaded(list: listCategories);
        yield ItemsLoaded(
            list: listItems
                .where((e) => e.categoryId == listCategories.first.id)
                .toList());
        yield CartItems(list: customerOrder.cartItems);
      } else if (event is LoadCategories) {
        yield CategoriesLoaded(list: listCategories);
      } else if (event is LoadItems) {
        yield ItemsLoaded(
            list: listItems
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is AddItem) {
        customerOrder.addCartItem(listItems
            .where((element) => element.id == '${event.itemId}')
            .first);
        yield CartItems(
            list: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is ReduceItem) {
        customerOrder.reduceCartItem(event.itemId);
        yield CartItems(
            list: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is RemoveItem) {
        customerOrder.removeCartItem(event.itemId);
        yield CartItems(
            list: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is AddComment) {
        customerOrder.addItemComment(event.itemId, event.comment);
        yield CartItems(
            list: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is PostOrder) {
        if (customerOrder.cartItems.length > 0)
          yield SubmissionValid(customerOrder: customerOrder);
        else
          yield SubmissionInvalid(
              message: 'Please add some items in your cart');
      }
    } catch (e) {
      log('POS Bloc', error: e);
    }
  }
}
