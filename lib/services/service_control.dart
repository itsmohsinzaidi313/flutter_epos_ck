import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/services/order_service.dart';
import 'package:pos_app/services/printing_service/printing_service.dart';
import 'package:pos_app/services/register_service.dart';
import 'package:pos_app/services/service_common.dart';
import 'package:pos_app/services/shift_service.dart';
import 'package:sqflite/sqflite.dart';

class ServiceControl {
  final Database db;
  final VerboseBloc bloc;
  static ServiceControl svcCtrl;
  ServiceControl({this.bloc, this.db}) {
    _services
        .add(OrderService(id: 1, name: 'Order Service', db: db, bloc: bloc));
    _services.add(
        RegisterService(id: 2, name: 'Register Service', db: db, bloc: bloc));
    _services
        .add(ShiftService(id: 3, name: 'Shift Service', db: db, bloc: bloc));
    _services.add(PrintingService(id: 4, name: 'Printing Service', bloc: bloc));
    svcCtrl = this;
  }

  List<Map<int, String>> get services {
    List<Map<int, String>> list = [];
    for (var svc in _services) {
      list.add({svc.id: svc.name});
    }
    return list;
  }

  List<ServiceCommon> _services = [];

  ServiceCommon getService({String name = ''}) {
    return _services.where((element) => element.name == name).toList().first;
  }

  void enableServices({String name = ''}) {
    if (name != '') {
      _services.where((svc) => svc.name == name).toList().first.setState(true);
    } else {
      for (var svc in _services) {
        svc.setState(true);
      }
    }
  }

  void disableServices({String name = ''}) {
    if (name != '') {
      _services.where((svc) => svc.name == name).toList().first.setState(false);
    } else {
      for (var svc in _services) {
        svc.setState(false);
      }
    }
  }

  void startServices({String name = ''}) {
    if (name != '') {
      _services.where((svc) => svc.name == name).toList().first.start();
    } else {
      for (var svc in _services) {
        svc.start();
      }
    }
  }

  void stopServices({String name = ''}) {
    if (name != '') {
      _services.where((svc) => svc.name == name).toList().first.stop();
    } else {
      for (var svc in _services) {
        svc.stop();
      }
    }
  }

  List<Map<String, bool>> serviceStatus({String name = ''}) {
    if (name != '') {
      final svc = _services.where((svc) => svc.name == name).toList().first;
      return [
        {svc.name: svc.isBusy}
      ];
    } else {
      final list = <Map<String, bool>>[];
      for (var svc in _services) {
        list.add({svc.name: svc.isBusy});
      }
      return list;
    }
  }
}
