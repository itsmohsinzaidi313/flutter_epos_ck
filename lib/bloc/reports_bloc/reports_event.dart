part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object> get props => [];
}

class RptFromDateChanged extends ReportsEvent {
  final String fromDate;
  RptFromDateChanged({this.fromDate});
}

class RptToDateChanged extends ReportsEvent {
  final String toDate;
  RptToDateChanged({this.toDate});
}