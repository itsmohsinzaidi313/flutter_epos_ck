part of 'orders_bloc.dart';

abstract class OrdersBlocEvent {
  const OrdersBlocEvent();
}

class FetchOrders extends OrdersBlocEvent {}
