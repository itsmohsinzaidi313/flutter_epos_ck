import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pos_app/models/objects/customer_order.dart';
import 'package:pos_app/models/objects/venue.dart';
import 'package:pos_app/models/objects/member.dart';
import 'package:pos_app/models/objects/session.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:pos_app/shared/config.dart';

part 'order_info_event.dart';
part 'order_info_state.dart';

class OrderInfoBloc extends Bloc<OrderInfoEvent, OrderInfoState> {
  OrderInfoBloc() : super(OrderInfoInitial());
  Order order;
  @override
  Stream<OrderInfoState> mapEventToState(
    OrderInfoEvent event,
  ) async* {
    try {
      if (event is OrderInfoBuild) {
        order = Order();
        yield OrderInfoStateMembers(members: []);
        yield* decodeSession(await GeneralRepo.repo.getSessions());
        yield* decodeVenues(await GeneralRepo.repo.getVenues());
      } else if (event is OrderInfoWaiterNoChanged) {
        order.waiterId = event.waiterNo;
      } else if (event is OrderInfoCoversChanged) {
        order.covers = event.covers;
      } else if (event is OrderInfoTableNoChanged) {
        order.tableId = event.tableNo;
      } else if (event is OrderInfoMemberAdded) {
        if (order.members
                .where(
                    (element) => element.memberCode == event.member.memberCode)
                .toList()
                .length ==
            0) {
          order.members.add(event.member);
        } else {
          yield OrderInfoError(message: 'Member already added');
        }
        yield OrderInfoStateMembers(members: order.members);
      } else if (event is OrderInfoMemberRemoved) {
        order.members.removeWhere(
            (element) => element.memberCode == event.member.memberCode);
        yield OrderInfoStateMembers(members: order.members);
      } else if (event is OrderInfoPartyChanged) {
        order.party = event.party;
      } else if (event is OrderInfoSessionChanged) {
        order.sessionId = event.session.sessionId;
      } else if (event is OrderInfoVenueChanged) {
        order.venueId = event.venue.venueId;
      } else if (event is OrderInfoGetMembers) {
        yield OrderInfoStateMembers(members: order.members);
      } else if (event is OrderInfoSubmit) {
        yield* validateOrderInfo(order);
      } else if (event is ResetOrderInfoOrder) {
        order.reset();
      }
    } catch (e) {
      log('Error', error: e, name: 'orderInfoBloc');
      yield OrderInfoError(message: e.toString());
    }
  }

  Stream<OrderInfoState> validateOrderInfo(Order order) async* {
    bool status = true;
    if ((order.waiterId ?? '') == '') {
      yield OrderInfoError(message: 'Waiter no is missing');
      status = false;
    }
    if ((order.tableId ?? '') == '') {
      yield OrderInfoError(message: 'Table no is missing');
      status = false;
    }
    if ((order.covers ?? '') == '') {
      yield OrderInfoError(message: 'No of person is missing');
      status = false;
    }
    if (order.members.length == 0) {
      yield OrderInfoError(message: 'Member(s) is missing');
      status = false;
    }
    if ((order.venueId ?? '') == '') {
      yield OrderInfoError(message: 'Venue is missing');
    }
    if ((order.sessionId ?? '') == '') {
      yield OrderInfoError(message: 'Session is missing');
    }
    if (status) {
      order.userId = Config.user.id;
      order.tiltId = Config.user.tiltId;
      yield OrderInfoValid(order: order);
    }
  }

  Stream<OrderInfoState> decodeSession(Response response) async* {
    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      final list =
          (json as List<dynamic>).map((e) => Session.fromJson(e)).toList();
      yield OrderInfoStateSession(sessions: list);
    } else {
      yield OrderInfoError(message: jsonDecode(response.body)['Message']);
    }
  }

  Stream<OrderInfoState> decodeVenues(Response response) async* {
    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      final list =
          (json as List<dynamic>).map((e) => Venue.fromJson(e)).toList();
      yield OrderInfoStateVenues(venues: list);
    } else
      yield OrderInfoError(message: jsonDecode(response.body)['Message']);
  }
}
