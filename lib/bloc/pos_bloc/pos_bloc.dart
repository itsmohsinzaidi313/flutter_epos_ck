import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/items_category.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/repositories/categories_repository.dart';
import 'package:pos_app/repositories/menu_items_repository.dart';
import 'package:pos_app/repositories/order_repository.dart';
part 'pos_event.dart';
part 'pos_state.dart';

class POSBloc extends Bloc<POSEvents, POSState> {
  Order customerOrder;
  List<Category> listCategories = [];
  List<MenuItem> listItems = [];
  POSBloc() : super(PosInitial());

  @override
  Stream<POSState> mapEventToState(
    POSEvents event,
  ) async* {
    try {
      if (event is POSBuild) {
        if (customerOrder == null) {
          customerOrder = Order();
        }
        final cateResponse = await CategoryRepo.repo.rawCategories;
        final itemResponse = await MenuItemRepo.repo.allItems;
        listCategories = (cateResponse.data as List<dynamic>)
            .map((e) => Category.fromJson(e))
            .toList();
        listItems = (itemResponse.data as List<dynamic>)
            .map((e) => MenuItem.fromJson(e))
            .toList();
        listCategories.first.selected = true;
        yield CategoriesLoaded(list: listCategories);
        yield ItemsLoaded(
            list: listItems
                .where((e) => e.categoryId == listCategories.first.id)
                .toList());
        yield CartItems(
            list: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is CategoryChanged) {
        listCategories.forEach((e) {
          if (e.id == event.categoryId) {
            e.selected = true;
          } else {
            e.selected = false;
          }
        });
        yield CategoriesLoaded(list: listCategories);
        yield ItemsLoaded(
            list: listItems
                .where((e) => e.categoryId == event.categoryId)
                .toList());
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
        yield POSLoading();
        if (customerOrder.cartItems.length > 0) {
          ServerResponse response;
          if (customerOrder.editOrder) {
            
            response =
                await OrderRepo.repo.updateOrder(customerOrder: customerOrder);
          } else {
            response =
                await OrderRepo.repo.postOrder(customerOrder: customerOrder);
          }
          if (response.status) {
            if (customerOrder.editOrder) {
              yield OrderUpdated(message: 'Order Updated');
            } else {
              yield OrderPosted(message: 'Order Saved');
            }
          } else {
            yield OrderPostFailed(message: response.message);
          }
        } else {
          yield SubmissionInvalid(
              message: 'Please add some items in your cart');
        }
      } else if (event is ResetPOSOrder) {
        customerOrder.reset();
      } else if (event is LoadPOSOrder) {
        customerOrder = event.customerOrder;
      }
    } catch (e) {
      yield POSError(message: e);
    }
  }
}
