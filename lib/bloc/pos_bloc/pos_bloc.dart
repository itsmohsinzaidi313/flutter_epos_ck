import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/menu_item.dart';
import 'package:pos_app/repositories/categories_repository.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:pos_app/repositories/menu_items_repository.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/repositories/users_repository.dart';
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
        await initializePOS();
        yield CategoriesLoaded(list: listCategories);
        yield ItemsLoaded(
            list: listItems
                .where((e) => e.categoryId == listCategories.first.id)
                .toList());

        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is CategoryChanged) {
        for (var item in listCategories) {
          if (item.id == event.categoryId) {
            item.selected = true;
          } else {
            item.selected = false;
          }
        }
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
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is ReduceItem) {
        if (customerOrder.editOrder) {
          double qty = 0;
          for (var item in customerOrder.cartItems) {
            qty += item.quantity;
          }
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
          subTotal: customerOrder.subTotal,
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
          subTotal: customerOrder.subTotal,
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
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is AddComment) {
        customerOrder.addItemComment(event.itemId, event.comment);
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is PostOrder) {
        yield POSLoading(message: 'Submitting order please wait...');

        if (isOrderValid(customerOrder)) {
          bool orderStatus = false;
          if (!requestSubmitted) {
            requestSubmitted = true;
            if (customerOrder.editOrder) {
              // TODO:
              // response = await OrderRepo.repo
              //     .updateOrder(customerOrder: customerOrder);
            } else {
              orderStatus =
                  await OrderRepo.repo.newOrder(customerOrder: customerOrder);
            }
            requestSubmitted = false;
          } else {
            yield POSLoading(message: 'Submitting order please wait...');
          }
          if (orderStatus) {
            if (customerOrder.editOrder) {
              yield OrderUpdated(message: 'Order Updated');
            } else {
              yield OrderPosted(message: 'Order Saved');
            }
          } else {
            yield OrderPostFailed(message: 'Order cannot be saved.');
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

  Future<void> initializePOS() async {
    customerOrder ??= Order();
    customerOrder.register = await GeneralRepo.repo.getCurrentRegister();
    customerOrder.device = await GeneralRepo.repo.getCurrentDevice();
    listCategories = await CategoryRepo.repo.rawCategories();
    listItems = await MenuItemRepo.repo.allItems();
    listCategories.first.selected = true;
  }

  bool isOrderValid(Order order) {
    if (order.cartItems.length <= 0) {
      return false;
    }

    for (var item in order.cartItems) {
      if (item.quantity <= 0) {
        return false;
      }
    }
    return true;
  }
}
