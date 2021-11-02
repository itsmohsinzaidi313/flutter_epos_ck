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
  Order _order;
  Map<String, dynamic> _orderOldState;
  POSMenu menu;
  bool requestSubmitted = false;
  POSBloc() : super(PosInitial());

  @override
  Stream<POSState> mapEventToState(
    POSEvents event,
  ) async* {
    try {
      if (event is POSBuild) {
        if (_order == null) {
          _order = Order();
        }
        yield* loadMenu();
        yield CartItems(
          list: _order.items,
          subTotal: _order.subTotal,
          totalAmount: _order.totalTaxAmount,
          taxAmount: _order.totalTax,
        );
      } else if (event is CategoryChanged) {
        menu.listCategories.forEach((e) {
          if (e.id == event.categoryId) {
            e.selected = true;
          } else {
            e.selected = false;
          }
        });
        yield POSMenuLoaded(menu: menu);
        yield CategoriesLoaded(list: menu.listCategories);
        yield ItemsLoaded(
            categories: menu.listCategories,
            items: menu.listItems
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is LoadItems) {
        yield ItemsLoaded(
            categories: menu.listCategories,
            items: menu.listItems
                .where((e) => e.categoryId == event.categoryId)
                .toList());
      } else if (event is AddItem) {
        if (event.code == Item.openFoodCode.toString()) {
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
        yield CartItems(
          list: _order.items,
          subTotal: _order.subTotal,
          totalAmount: _order.totalTaxAmount,
          taxAmount: _order.totalTax,
        );
      } else if (event is ReduceItem) {
        if (_order.editOrder) {
          double qty = 0;
          _order.items.forEach((element) => qty += element.quantity);
          if (qty > 1) {
            // _order.reduceCartItem(event.itemId);
          } else {
            yield SubmissionInvalid(
                message: 'There should be atleast on item in cart');
          }
        } else {
          // _order.reduceCartItem(event.itemId);
        }
        yield CartItems(
          list: _order.items,
          subTotal: _order.subTotal,
          totalAmount: _order.totalTaxAmount,
          taxAmount: _order.totalTax,
        );
      } else if (event is ItemQuantityChanged) {
        if (event.quantity > 0) {
          // _order.setItemQuantity(event.itemId, event.quantity);
        } else {
          yield SubmissionInvalid(
              message: 'Quantity should be greater than zero(0)');
        }
        yield CartItems(
          list: _order.items,
          subTotal: _order.subTotal,
          totalAmount: _order.totalTaxAmount,
          taxAmount: _order.totalTax,
        );
      } else if (event is RemoveItem) {
        if (_order.editOrder) {
          if (_order.items.length > 1) {
            // _order.removeCartItem(event.itemId);
          } else {
            yield SubmissionInvalid(
                message: 'There should be atleast one item in cart');
          }
        } else {
          // _order.removeCartItem(event.itemId);
        }
        yield CartItems(
          list: _order.items,
          subTotal: _order.subTotal,
          totalAmount: _order.totalTaxAmount,
          taxAmount: _order.totalTax,
        );
      } else if (event is AddOpenItem) {
        _order.addCartItem(event.openItem);
        yield CartItems(
          list: _order.items,
          subTotal: _order.subTotal,
          totalAmount: _order.totalTaxAmount,
          taxAmount: _order.totalTax,
        );
      } else if (event is AddComment) {
        // _order.addItemComment(event.itemId, event.comment);
        yield CartItems(
          list: _order.items,
          subTotal: _order.subTotal,
          totalAmount: _order.totalTaxAmount,
          taxAmount: _order.totalTax,
        );
      } else if (event is PostOrder) {
        yield POSLoading(message: 'Submitting order please wait...');
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
        yield CartItems(
          list: _order.items,
          subTotal: _order.subTotal,
          totalAmount: _order.totalTaxAmount,
          taxAmount: _order.totalTax,
        );
      } else if (event is ReduceOnSpotDeal) {
        
      } else if (event is RemoveOnSpotDeal) {
        OnSpotDeal deal = OnSpotDeal();
        bool found = false;
        for (var item in _order.items) {
          if (item is OnSpotDeal) {
            if (item == event.deal) {
              found = true;
              deal = item;
              yield CartItems(
                list: _order.items,
                subTotal: _order.subTotal,
                totalAmount: _order.totalTaxAmount,
                taxAmount: _order.totalTax,
              );
            }
          }
        }
        if (found) _order.items.remove(deal);
      } else if (event is OnSpotDealQuantityChanged) {
        for (var item in _order.items) {
          if (item is OnSpotDeal) {
            if (item == event.deal) {
              item.quantity = event.quantity.toDouble();
              yield CartItems(
                list: _order.items,
                subTotal: _order.subTotal,
                totalAmount: _order.totalTaxAmount,
                taxAmount: _order.totalTax,
              );
            }
          }
        }
      } else if (event is ResetPOSOrder) {
        _order.reset();
      } else if (event is LoadPOSOrder) {
        _orderOldState = event.customerOrder.map;
        _order = event.customerOrder;
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
        this.menu = POSMenu.fromMap(json);
        yield POSMenuLoaded(menu: menu);
        yield CategoriesLoaded(list: menu.listCategories);
        yield ItemsLoaded(
            categories: menu.listCategories,
            items: this
                .menu
                .listItems
                .where((e) => e.categoryId == menu.listCategories.first.id)
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
