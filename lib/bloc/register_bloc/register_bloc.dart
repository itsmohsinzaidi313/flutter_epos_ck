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
        final db = await LocalDatabase.database.getDatabase();
        final device = await GeneralRepo.repo.getCurrentDevice();
        final list = await db.query(RegisterTable.TABLE_NAME, columns: [
          '(IFNULL(COUNT(${RegisterTable.LOCAL_ID}),0) + 1) count'
        ]);

        final register = Register();
        register.userId = int.parse((await UsersRepo.repo.getCurrentUser()).id);
        register.registerNo =
            await Lib.codeGenerator('REG', list.first['count']);
        register.openingBalance = openingAmount;
        register.openingBalanceDateTime = Lib.getCurrentDateTimeWithFormat();

        register.closingBalance = 0.0;
        register.closingBalanceDateTime = '0000-00-00 00:00:00';

        register.deviceKey = device.deviceKey;
        register.companyId = device.companyId;
        register.outletId = device.outletId;
        register.registerStatus = 1;
        register.isUpload = 0;
        await db.insert(RegisterTable.TABLE_NAME, register.getMap());
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
