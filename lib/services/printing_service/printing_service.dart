import 'dart:developer';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/repositories/printing_repository.dart';
import 'package:pos_app/services/printing_service/kot_print.dart';
import 'package:pos_app/services/printing_service/pre_payment_bill_print.dart';
import 'package:pos_app/services/service_common.dart';

enum PrintType { kot, saleReceipt, bill, additional, delete }

class PrintingService extends ServiceCommon {
  NetworkPrinter _printer;
  PrintingService(
      {@required int id, @required String name, @required VerboseBloc bloc})
      : super(id: id, name: name, serviceVersion: '1', bloc: bloc) {
    initiate();
  }

  @override
  Future<bool> perform() async {
    _printer ??= NetworkPrinter(PaperSize.mm80, await CapabilityProfile.load());
    final list = await PrintingRepo.repo.getPrints();
    if (list.isNotEmpty) {
      for (var element in list) {
        final PosPrintResult result =
            await _printer.connect('192.168.18.87', port: 9100);
        if (result == PosPrintResult.success) {
          try {
            if (element.master.printType ==
                PrintType.kot.toString().split('.').last) {
              await kot(element, _printer);
            } else if (element.master.printType ==
                PrintType.saleReceipt.toString().split('.').last) {
              await prePaymentSlip(element, _printer);
            }
          } catch (e) {
            log('Error', error: e, name: name);
          } finally {
            _printer.feed(2);
            _printer.cut();
            _printer.disconnect();
            await PrintingRepo.repo.deletePrint(id: element.master.id);
          }
        } else {
          bloc.add(VerboseNotify(
              message:
                  "ORDER# '${element.master.orderNo}' failed to print because the printer is unavailable."));
        }
      }
    }
    return true;
  }

  @override
  void onError(e) {}
}
