import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/deals.dart';
import 'package:pos_app/models/items_cart.dart';
import 'package:pos_app/models/items_category.dart';
import 'package:pos_app/models/menu.dart';
import 'package:pos_app/models/item.dart';
import 'package:pos_app/repositories/menu_repository.dart';
import 'package:pos_app/repositories/order_repository.dart';
import 'package:pos_app/shared/app_library.dart';
import 'package:pos_app/shared/config.dart';
import 'package:pos_app/shared/enums.dart';

part 'items_menu_event.dart';
part 'items_menu_state.dart';

class ItemsMenuBloc extends Bloc<ItemsMenuEvents, ItemsMenuState> {
  Order order;
  Map<String, dynamic> _orderOldState = {};
  POSMenu menu = POSMenu();
  bool requestSubmitted = false;
  bool orderCompleted = false;
  String message = '';
  ItemsMenuBloc({required this.order}) : super(InitialState()) {
    on<ItemsMenuBuild>((event, emit) async {
      try {
        orderCompleted = false;
        await loadMenu(emit);
      } catch (e) {
        log('Error: ${e.toString()}', name: 'posBloc');
        emit(ErrorState(message: e.toString()));
      }
    });
    on<CategoryChanged>((event, emit) async {
      try {
        menu.listCategories.forEach((e) {
          if (e.id == event.categoryId) {
            e.selected = true;
          } else {
            e.selected = false;
          }
        });
        await loadMenu(emit);
      } catch (e) {
        log('Error: ${e.toString()}', name: 'posBloc');
        emit(ErrorState(message: e.toString()));
      }
    });
    on<PostOrder>((event, emit) async {
      try {
        emit(ErrorState(message: 'Submitting order please wait...'));
        order =
            Order.modify(order, deviceId: (await Config.deviceData)!.androidId);
        if (isOrderValid(order)) {
          Response response;
          if (!requestSubmitted) {
            if (!(order.orderStatus == OrderStatus.complete)) {
              emit((LoadingState(message: 'Please wait...')));
              requestSubmitted = true;
              response = await postOrder(order);
            } else {
              if (order.map.toString() != _orderOldState.toString()) {
                emit((LoadingState(message: 'Please wait...')));
                requestSubmitted = true;
                response = await updateOrder(order);
              } else {
                response = Response("Order Updated", HttpStatus.created);
              }
            }
            if (response.statusCode == HttpStatus.created) {
              if (order.orderStatus == OrderStatus.complete) {
                orderCompleted = true;
                message = 'Order Updated';
                emit(LoadingState(message: 'Order Updated'));
              } else {
                orderCompleted = true;
                message = 'Order Saved';
                emit(LoadingState(message: 'Order Saved'));
              }
              add(ResetPOSOrder());
            } else {
              log(response.body);
              emit(ErrorState(message: Lib.getMessage(response)));
            }
            requestSubmitted = false;
          } else {
            emit(LoadingState(message: 'Please wait...'));
          }
        } else {
          emit(ErrorState(message: 'Please add some items in your cart'));
        }
        await loadMenu(emit);
      } catch (e) {
        log('Error: ${e.toString()}', name: 'posBloc');
        emit(ErrorState(message: e.toString()));
      }
    });
    on<ResetPOSOrder>((event, emit) {
      try {
        order = Order(cart: ItemsCart(items: []));
      } catch (e) {
        log('Error: ${e.toString()}', name: 'posBloc');
        emit(ErrorState(message: e.toString()));
      }
    });
    on<LoadCustomerOrder>((event, emit) async {
      try {
        _orderOldState = event.customerOrder.map;
        order = event.customerOrder;
        await loadMenu(emit);
      } catch (e) {
        requestSubmitted = false;
        log('Error: ${e.toString()}', name: 'posBloc');
        emit(ErrorState(message: e.toString()));
      }
    });
    on<UpdateItemsMenu>((event, emit) async {
      await loadMenu(emit);
    });
    on<UpdateCart>((event, emit) async {
      order = Order.modify(order, cart: event.cart);
      await loadMenu(emit);
    });
    on<AddComment>((event, emit) async {
      order.cart.addComment(event.index, event.value);
      await loadMenu(emit);
    });
    on<IncreaseItem>((event, emit) async {
      order.cart.increase(event.index);
      await loadMenu(emit);
    });
    on<DecreaseItem>((event, emit) async {
      order.cart.reduce(event.index);
      await loadMenu(emit);
    });
    on<RemoveItem>((event, emit) async {
      order.cart.remove(event.index);
      await loadMenu(emit);
    });
    on<AddMenuItem>((event, emit) async {
      if (event.item is OnSpotDeal) {
        order.cart.add(OnSpotDeal.modify(event.item as OnSpotDeal));
      } else if (event.item is FixedDeal) {
        order.cart.add(OnSpotDeal.modify(event.item as OnSpotDeal));
      } else if (event.item is FoodItem) {
        order.cart.add(FoodItem.modify(event.item as FoodItem));
      }
      await loadMenu(emit);
    });
  }

  bool isOrderValid(Order order) {
    if (order.cart.items.length <= 0) {
      return false;
    }

    for (var item in order.cart.items) {
      if ((item.quantity) <= 0) {
        return false;
      }
    }
    return true;
  }

  Future<void> loadMenu(Emitter<ItemsMenuState> emit) async {
    final response = await MenuRepo.repo.getMenu();
    if (response.statusCode == HttpStatus.ok) {
      try {
        final json = jsonDecode(response.body);
        final listCategories = (json['Categories'] as List<dynamic>)
            .map((e) => Category.fromJson(e))
            .toList();
        final listItems = (json['Items'] as List<dynamic>)
            .map((e) => FoodItem.fromMap(e))
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
        emit(
          LoadedState(
            totalAmount: order.totalTaxedAmount,
            subTotal: order.subTotal,
            taxAmount: order.totalTax,
            menu: menu,
            order: order,
            orderCompleted: orderCompleted,
            message: message,
          ),
        );
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
      menu.listCategories.first.selected = true;
    } else {
      emit(ErrorState(message: Lib.getMessage(response)));
    }
  }

  Future<Response> postOrder(Order order) async =>
      await OrderRepo.repo.newOrder(customerOrder: order);

  Future<Response> updateOrder(Order order) async =>
      await OrderRepo.repo.updateOrder(customerOrder: order);
}
