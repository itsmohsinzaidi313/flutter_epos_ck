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
import 'package:pos_app/models/item.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
part 'pos_event.dart';
part 'pos_state.dart';

class POSBloc extends Bloc<POSEvents, POSState> {
  Order customerOrder;
  POSMenu menu;
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
          list: customerOrder.items,
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
            categories: menu.listCategories,
            items: menu.listMenu
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is LoadItems) {
        yield ItemsLoaded(
            categories: menu.listCategories,
            items: menu.listMenu
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is AddItem) {
        if (event.code == Item.OPENFOOD_CODE.toString()) {
          customerOrder.addCartItem(
            Item(
              code: event.code,
              id: event.itemId.toString(),
            ),
          );
        } else {
          customerOrder.addCartItem(menu.listMenu
              .where((element) => element.code == '${event.code}')
              .first);
        }
        yield CartItems(
          list: customerOrder.items,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is ReduceItem) {
        if (customerOrder.editOrder) {
          double qty = 0;
          customerOrder.items.forEach((element) => qty += element.quantity);
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
          list: customerOrder.items,
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
          list: customerOrder.items,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is RemoveItem) {
        if (customerOrder.editOrder) {
          if (customerOrder.items.length > 1) {
            customerOrder.removeCartItem(event.itemId);
          } else {
            yield SubmissionInvalid(
                message: 'There should be atleast one item in cart');
          }
        } else {
          customerOrder.removeCartItem(event.itemId);
        }
        yield CartItems(
          list: customerOrder.items,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is AddOpenItem) {
        customerOrder.addCartItem(event.openItem);
        yield CartItems(
          list: customerOrder.items,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is AddComment) {
        customerOrder.addItemComment(event.itemId, event.comment);
        yield CartItems(
          list: customerOrder.items,
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
            if (response.statusCode == HttpStatus.created) {
              if (customerOrder.editOrder) {
                yield OrderUpdated(message: 'Order Updated');
              } else {
                yield OrderPosted(message: 'Order Saved');
              }
            } else {
              yield OrderPostFailed(message: Lib.getMessage(response));
            }
            requestSubmitted = false;
          } else {
            yield POSLoading(message: 'Please wait...');
          }
        } else {
          yield SubmissionInvalid(
              message: 'Please add some items in your cart');
        }
      } else if (event is AddOnSpotDeal) {
        if (customerOrder.items.isEmpty) {
          customerOrder.items.add(event.deal);
        } else {
          bool dealExists = false;
          for (var item in customerOrder.items) {
            if (item is OnSpotDeal) {
              if (item == event.deal) {
                dealExists = true;
                customerOrder.items
                    .firstWhere((element) => element == event.deal)
                    .quantity++;
                break;
              }
            }
          }
          if (!dealExists) {
            customerOrder.items.add(event.deal);
          }
        }
        yield CartItems(
          list: customerOrder.items,
          subTotal: customerOrder.subTotal,
          totalAmount: customerOrder.totalTaxedAmount,
          taxAmount: customerOrder.totalTax,
        );
      } else if (event is ReduceOnSpotDeal) {
        for (var item in customerOrder.items) {
          if (item is OnSpotDeal) {
            if (item == event.deal) {
              item.quantity--;
              if (item.quantity < 1) {
                this.add(RemoveOnSpotDeal(deal: event.deal));
              }
              yield CartItems(
                list: customerOrder.items,
                subTotal: customerOrder.subTotal,
                totalAmount: customerOrder.totalTaxedAmount,
                taxAmount: customerOrder.totalTax,
              );
            }
          }
        }
      } else if (event is RemoveOnSpotDeal) {
        for (var item in customerOrder.items) {
          if (item is OnSpotDeal) {
            if (item == event.deal) {
              customerOrder.items.remove(item);
              yield CartItems(
                list: customerOrder.items,
                subTotal: customerOrder.subTotal,
                totalAmount: customerOrder.totalTaxedAmount,
                taxAmount: customerOrder.totalTax,
              );
            }
          }
        }
      } else if (event is OnSpotDealQuantityChanged) {
        for (var item in customerOrder.items) {
          if (item is OnSpotDeal) {
            if (item == event.deal) {
              item.quantity = event.quantity.toDouble();
              yield CartItems(
                list: customerOrder.items,
                subTotal: customerOrder.subTotal,
                totalAmount: customerOrder.totalTaxedAmount,
                taxAmount: customerOrder.totalTax,
              );
            }
          }
        }
      } else if (event is ResetPOSOrder) {
        customerOrder.reset();
      } else if (event is LoadPOSOrder) {
        customerOrder = event.customerOrder;
      }
    } catch (e) {
      requestSubmitted = false;
      log('Error: ${e.toString()}', name: 'posBloc');
      yield SubmissionInvalid(message: e.toString());
    }
  }

  bool isOrderValid(Order order) {
    if (order.items.length <= 0) {
      return false;
    }

    for (var item in order.items) {
      if ((item.quantity ?? 0) <= 0) {
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
            .map((e) => OnSpotDeal.fromMap(e))
            .toList();
        List<Item> listMenu = [];
        listMenu.addAll(listItems);
        listMenu.addAll(listFixedDeals);
        listMenu.addAll(listOnSpotDeals);
        this.menu = POSMenu(
          listCategories: listCategories,
          listMenu: listMenu,
        );
        yield CategoriesLoaded(list: listCategories);
        yield ItemsLoaded(
            categories: menu.listCategories,
            items: this
                .menu
                .listMenu
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
