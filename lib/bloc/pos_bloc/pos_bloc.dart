import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/menu.dart';
import 'package:pos_app/models/menu_item.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
part 'pos_event.dart';
part 'pos_state.dart';

class POSBloc extends Bloc<POSEvents, POSState> {
  Order customerOrder;
  Menu menu;
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
        yield* loadMenu();
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is CategoryChanged) {
        menu.listCategories.forEach((e) {
          if (e.id == event.categoryId) {
            e.selected = true;
          } else {
            e.selected = false;
          }
        });
        yield CategoriesLoaded(list: menu.listCategories);
        yield ItemsLoaded(
            list: menu.listItems
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is LoadItems) {
        yield ItemsLoaded(
            list: menu.listItems
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is AddItem) {
        if (event.code == MenuItem.OPENFOOD_CODE) {
          customerOrder.addCartItem(
            MenuItem(
              code: event.code.toString(),
              id: event.itemId.toString(),
            ),
          );
        } else {
          customerOrder.addCartItem(menu.listItems
              .where((element) => element.code == '${event.code}')
              .first);
        }
        yield CartItems(
          list: customerOrder.cartItems,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is ReduceItem) {
        if (customerOrder.editOrder) {
          double qty = 0;
          customerOrder.cartItems.forEach((element) => qty += element.quantity);
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
      } else if (event is AddOpenItem) {
        customerOrder.addCartItem(event.openItem);
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
        customerOrder.tiltId = Config.user.tiltId;
        if (isOrderValid(customerOrder)) {
          Response response;
          if (!requestSubmitted) {
            requestSubmitted = true;
            if (!customerOrder.editOrder) {
              response = await postOrder(customerOrder);
            } else {
              response = await updateOrder(customerOrder);
            }
            requestSubmitted = false;
          } else {
            yield POSLoading(message: 'Please wait...');
          }
          if (response.statusCode == HttpStatus.created) {
            if (customerOrder.editOrder) {
              yield OrderUpdated(message: 'Order Updated');
            } else {
              yield OrderPosted(message: 'Order Saved');
            }
          } else {
            yield OrderPostFailed(message: Lib.getMessage(response));
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
      log('Error: ${e.toString()}', name: 'posBloc');
      yield POSError(message: e.toString());
    }
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

  Stream<POSState> loadMenu() async* {
    final response = await MenuRepo.repo.getMenu();
    if (response.statusCode == HttpStatus.ok) {
      try {
        final json = jsonDecode(response.body);
        final listCategories = (json['Categories'] as List<dynamic>)
            .map((e) => Category.fromJson(e))
            .toList();
        final listItems = (json['Items'] as List<dynamic>)
            .map((e) => MenuItem.fromMap(e))
            .toList();
        final listFixedDeals = (json['FixedDeals'] as List<dynamic>)
            .map((e) => FixedDeal.fromMap(e))
            .toList();
        final listOnSpotDeals = (json['OnSpotDeals'] as List<dynamic>)
            .map((e) => MenuItem.fromMap(e))
            .toList();
        this.menu = Menu(
          listCategories: listCategories,
          listItems: listItems,
          listFixedDeals: listFixedDeals,
          listOnSpotDeals: listOnSpotDeals,
        );
        yield CategoriesLoaded(list: listCategories);
        yield ItemsLoaded(
            list: listItems
                .where((e) => e.categoryId == listCategories.first.id)
                .toList());
      } catch (e) {
        yield POSError(message: e.toString());
      }
      menu.listCategories.first.selected = true;
    } else {
      yield SubmissionInvalid(message: Lib.getMessage(response));
    }
  }

  Future<Response> postOrder(Order order) async =>
      await OrderRepo.repo.newOrder(customerOrder: order);

  Future<Response> updateOrder(Order order) async =>
      await OrderRepo.repo.updateOrder(customerOrder: order);
}
