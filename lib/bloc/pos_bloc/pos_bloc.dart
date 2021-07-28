import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/item_category.dart';
import 'package:pos_app/models/objects/menu_item.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/repositories/categories_repository.dart';
import 'package:pos_app/repositories/menu_items_repository.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/config.dart';
part 'pos_event.dart';
part 'pos_state.dart';

class POSBloc extends Bloc<POSEvents, POSState> {
  Order customerOrder;
  List<Category> listCategories = [];
  List<MenuItem> listItems = [];
  bool requestSubmitted = false;
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
        final cateResponse = await CategoryRepo.repo.getCategories;
        final itemResponse = await MenuItemRepo.repo.allItems();
        try {
          listCategories = (cateResponse.data as List<dynamic>)
              .map((e) => Category.fromMap(e))
              .toList();
          listItems = (itemResponse.data as List<dynamic>)
              .map((e) => MenuItem.fromMap(e))
              .toList();
        } catch (e) {
          yield POSError(message: e.toString());
        }
        listCategories.first.selected = true;
        yield CategoriesLoaded(list: listCategories);
        yield ItemsLoaded(
            list: listItems
                .where((e) => e.categoryId == listCategories.first.LOCAL_ID)
                .toList());

        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.SUBTOTAL,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is CategoryChanged) {
        listCategories.forEach((e) {
          if (e.LOCAL_ID == event.categoryId) {
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
        if (event.code == MenuItem.OPENFOOD_CODE) {
          customerOrder.addCartItem(
            MenuItem(
              CODE: event.code.toString(),
              LOCAL_ID: event.itemId.toString(),
            ),
          );
        } else {
          customerOrder.addCartItem(listItems
              .where((element) => element.CODE == '${event.code}')
              .first);
        }
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.SUBTOTAL,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is ReduceItem) {
        if (customerOrder.editOrder) {
          double qty = 0;
          customerOrder.cartItems.forEach((element) => qty += element.QUANTITY);
          if (qty > 1) {
            customerOrder.reduceCartItem(event.itemId);
          } else {
            yield SubmissionInvalid(
                message: 'There should be atleast on item in cart');
          }
        } else {
          customerOrder.reduceCartItem(event.itemId);
        }
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.SUBTOTAL,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is ItemQuantityChanged) {
        if (event.quantity > 0) {
          customerOrder.setItemQuantity(event.itemId, event.quantity);
        } else {
          yield SubmissionInvalid(
              message: 'Quantity should be greater than zero(0)');
        }
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.SUBTOTAL,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is RemoveItem) {
        if (customerOrder.editOrder) {
          if (customerOrder.cartItems.length > 1) {
            customerOrder.removeCartItem(event.itemId);
          } else {
            yield SubmissionInvalid(
                message: 'There should be atleast one item in cart');
          }
        } else {
          customerOrder.removeCartItem(event.itemId);
        }
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.SUBTOTAL,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is AddOpenItem) {
        customerOrder.addCartItem(event.openItem);
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.SUBTOTAL,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is AddComment) {
        customerOrder.addItemComment(event.itemId, event.comment);
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.SUBTOTAL,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is PostOrder) {
        yield POSLoading(message: 'Submitting order please wait...');
        customerOrder.tiltId = Config.user.tiltId;
        if (isOrderValid(customerOrder)) {
          ServerResponse response;
          if (!requestSubmitted) {
            requestSubmitted = true;
            if (customerOrder.editOrder) {
              response = await OrderRepo.repo
                  .updateOrder(customerOrder: customerOrder);
            } else {
              response =
                  await OrderRepo.repo.newOrder(customerOrder: customerOrder);
            }
            requestSubmitted = false;
          } else {
            yield POSLoading(message: 'Submitting order please wait...');
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
      yield POSError(message: e.toString());
    }
  }

  bool isOrderValid(Order order) {
    if (order.cartItems.length <= 0) {
      return false;
    }

    for (var item in order.cartItems) {
      if (item.QUANTITY <= 0) {
        return false;
      }
    }
    return true;
  }
}
