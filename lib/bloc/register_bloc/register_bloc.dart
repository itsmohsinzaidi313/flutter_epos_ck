import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/database/local_database.dart';
import 'package:pos_app/database/models/register.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:pos_app/repositories/users_repository.dart';
import 'package:pos_app/shared/app_library.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());
  double openingAmount = 0.0;
  double closingAmount = 0.0;
  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is LoadRegister) {
      final register = await GeneralRepo.repo.getCurrentRegister();
      if (register.localId == null) {
        yield RegisterExists();
      }
    } else if (event is OpeningAmountChanged) {
      openingAmount = event.amount;
    } else if (event is ClosingAmountChanged) {
      closingAmount = event.amount;
    } else if (event is RegisterOpen) {
      if (openingAmount > 0) {
        final status =
            await GeneralRepo.repo.openShift(openingAmount: openingAmount);

        yield RegisterOpened();
      }
    } else if (event is RegisterClose) {
      final db = await LocalDatabase.database.getDatabase();
      final register = await GeneralRepo.repo.getCurrentRegister();
      register.registerStatus = 2;
      register.isUpload = 1;
      register.closingBalance = closingAmount;
      register.closingBalanceDateTime = Lib.getCurrentDateTimeWithFormat();
      await db.update(RegisterTable.TABLE_NAME, register.getMap(),
          where: '${RegisterTable.LOCAL_ID} = ?',
          whereArgs: [register.localId]);
      yield RegisterClosed();
    }
  }
}
