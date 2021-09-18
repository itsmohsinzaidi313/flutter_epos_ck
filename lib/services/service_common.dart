import 'dart:async';
import 'dart:developer';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';

import '../shared/config.dart';

abstract class ServiceCommon {
  ServiceCommon({this.id, this.name, this.serviceVersion, this.description, this.bloc});
  final int id;
  final String name;
  final String description;
  final String serviceVersion;
  final  VerboseBloc bloc;
  int duration = Config.SERVICE_CYCLE_DELAY;
  bool _active = false;
  bool _cycleComplete = true;
  bool enableLogMessages = true;
  bool get isBusy => !_cycleComplete;
  void passEvent(VerboseEvent event) => bloc.add(event);

  Future<bool> perform();

  void setState(bool value) {
    log(value ? 'Started' : 'Stopped', name: name);
    _active = value;
  }

  bool status() => _active;

  void start() {
    log('Started', name: name);
    _active = true;
  }

  void stop() {
    log('Stopped', name: name);
    _active = false;
  }

  void initiate() {
    _mapServices();
    _validate(_list);
    _cycle();
  }

  void forceCycle() => _cycleComplete = true;

  void delayPeriod({int seconds = Config.SERVICE_CYCLE_DELAY}) =>
      duration = seconds;

  void _cycle() async =>
      Timer.periodic(Duration(seconds: duration), (Timer t) => _operation());

  void _operation() async {
    if (_active && _cycleComplete) {
      try {
        enableLogMessages
            ? log('Responding', name: name, time: DateTime.now())
            : null;
        _cycleComplete = false;
        _cycleComplete = await perform();
      } catch (e) {
        enableLogMessages
            ? log('$name Crashed', name: name, error: e, time: DateTime.now())
            : null;
        bloc.add(VerboseNotify(message: e.toString()));
        onError(e);
      } finally {
        _cycleComplete = true;
      }
    }
  }

  static List<Map<int, String>> _list = [];
  void _mapServices({id, name}) {
    _list.add({id: name});
  }

  bool _validate(List<Map<int, String>> list) {
    int idCount = 0, nameCount = 0;
    for (var item1 in list) {
      for (var item2 in list) {
        if (item1.keys.toList().first == item2.keys.toList().first) {}
        if (item1.values.toList().first == item2.values.toList().first) {}
      }
    }
    if (idCount > 1 || nameCount > 1) {
      throw Exception('Services ids and names must be unique.');
    }
    return true;
  }

  void onError(e);
}
