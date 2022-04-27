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

part 'items_menu_event.dart';
part 'items_menu_state.dart';

class ItemsMenuBloc extends Bloc<ItemsMenuEvents, ItemsMenuState> {
  Order _order;
  Map<String, dynamic> _orderOldState;
  POSMenu menu;
  bool requestSubmitted = false;
  bool orderCompleted = false;
  String message = '';
  ItemsMenuBloc() : super(InitialState());

  @override
  Stream<ItemsMenuState> mapEventToState(
    ItemsMenuEvents event,
  ) async* {
    try {
      if (event is ItemsMenuBuild) {
      } else if (event is CategoryChanged) {
        menu.listCategories.forEach((e) {
          if (e.id == event.categoryId) {
            e.selected = true;
          } else {
            e.selected = false;
          }
        });
      } else if (event is AddItem) {
        if (event.code == Item.OPENFOOD_CODE.toString()) {
          _order.addCartItem(
            Item(
              code: event.code,
              id: event.itemId.toString(),
            ),
          );
        } else {
          _order.addCartItem(menu.listItems
              .where((element) => element.code == '${event.code}')
              .first);
        }
      } else if (event is ReduceItem) {
        if (_order.editOrder) {
          double qty = 0;
          _order.items.forEach((element) => qty += element.quantity);
          if (qty > 1) {
            _order.reduceCartItem(event.itemId);
          } else {
            yield ErrorState(
                message: 'There should be atleast on item in cart');
          }
        } else {
          _order.reduceCartItem(event.itemId);
        }
      } else if (event is ItemQuantityChanged) {
        if (event.quantity > 0) {
          _order.setItemQuantity(event.itemId, event.quantity);
        } else {
          yield ErrorState(message: 'Quantity should be greater than zero(0)');
        }
      } else if (event is RemoveItem) {
        if (_order.editOrder) {
          if (_order.items.length > 1) {
            _order.removeCartItem(event.itemId);
          } else {
            yield ErrorState(
                message: 'There should be atleast one item in cart');
          }
        } else {
          _order.removeCartItem(event.itemId);
        }
      } else if (event is AddOpenItem) {
        _order.addCartItem(event.openItem);
      } else if (event is AddComment) {
        _order.addItemComment(event.itemId, event.comment);
      } else if (event is PostOrder) {
        yield ErrorState(message: 'Submitting order please wait...');
        _order.tiltId = Config.user.tiltId;
        if (isOrderValid(_order)) {
          Response response;
          if (!requestSubmitted) {
            requestSubmitted = true;
            if (!_order.editOrder) {
              response = await postOrder(_order);
            } else {
              if (_order.map.toString() != _orderOldState.toString()) {
                response = await updateOrder(_order);
              } else {
                response = Response("Order Updated", HttpStatus.created);
              }
            }
            if (response.statusCode == HttpStatus.created) {
              if (_order.editOrder) {
                orderCompleted = true;
                message = 'Order Updated';
                yield LoadingState(message: 'Order Updated');
              } else {
                orderCompleted = true;
                message = 'Order Saved';
                yield LoadingState(message: 'Order Saved');
              }
            } else {
              yield ErrorState(message: Lib.getMessage(response));
            }
            requestSubmitted = false;
          } else {
            yield LoadingState(message: 'Please wait...');
          }
        } else {
          yield ErrorState(message: 'Please add some items in your cart');
        }
      } else if (event is AddOnSpotDeal) {
        if (_order.items.isEmpty) {
          _order.items.add(event.deal);
        } else {
          bool dealExists = false;
          for (var item in _order.items) {
            if (item is OnSpotDeal) {
              if (item == event.deal) {
                dealExists = true;
                _order.items
                    .firstWhere((element) => element == event.deal)
                    .quantity++;
                break;
              }
            }
          }
          if (!dealExists) {
            _order.items.add(event.deal);
          }
        }
      } else if (event is ReduceOnSpotDeal) {
        for (var item in _order.items) {
          if (item is OnSpotDeal) {
            if (item == event.deal) {
              item.quantity--;
              if (item.quantity < 1) {
                this.add(RemoveOnSpotDeal(deal: event.deal));
              }
            }
          }
        }
      } else if (event is RemoveOnSpotDeal) {
        OnSpotDeal deal = OnSpotDeal();
        bool found = false;
        for (var item in _order.items) {
          if (item is OnSpotDeal) {
            if (item == event.deal) {
              found = true;
              deal = item;
            }
          }
        }
        if (found) _order.items.remove(deal);
      } else if (event is OnSpotDealQuantityChanged) {
        for (var item in _order.items) {
          if (item is OnSpotDeal) {
            if (item == event.deal) {
              item.quantity = event.quantity.toDouble();
            }
          }
        }
      } else if (event is ResetPOSOrder) {
        _order.reset();
      } else if (event is LoadCustomerOrder) {
        _orderOldState = event.customerOrder.map;
        _order = event.customerOrder;
      }
      yield* loadMenu();
    } catch (e) {
      requestSubmitted = false;
      log('Error: ${e.toString()}', name: 'posBloc');
      yield ErrorState(message: e.toString());
      // yield SubmissionInvalid(message: e.toString());
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

  Stream<ItemsMenuState> loadMenu() async* {
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
          listItems: listMenu,
        );
        if (_order == null) {
          _order = Order();
        }
        yield LoadedState(
          totalAmount: _order.totalTaxedAmount,
          subTotal: _order.subTotal,
          taxAmount: _order.totalTax,
          menu: menu,
          cartItems: _order.items,
          orderCompleted: orderCompleted,
          message: message,
        );
      } catch (e) {
        yield ErrorState(message: e.toString());
      }
      menu.listCategories.first.selected = true;
    } else {
      yield ErrorState(message: Lib.getMessage(response));
    }
  }

  Future<Response> postOrder(Order order) async =>
      await OrderRepo.repo.newOrder(customerOrder: order);

  Future<Response> updateOrder(Order order) async =>
      await OrderRepo.repo.updateOrder(customerOrder: order);
}
