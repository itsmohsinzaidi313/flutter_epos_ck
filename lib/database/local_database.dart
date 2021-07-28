import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:pos_app/shared/config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pos_app/database/table_object/database_tables.dart';

class LocalDatabase {
  /// EXECUTE [initialize] FIRST
  static LocalDatabase database = LocalDatabase._internal();
  LocalDatabase._internal();

  Database _database;
  VerboseBloc _bloc;

  /// USE AFTER USING [initialize] ONCE
  /// OTHERWISE PROVIDE [VerboseBloc] INSTANCE
  /// THIS WILL FIRST EXECUTE [initialize] THEN PROVIDE A DATABASE INSTANCE
  Future<Database> getDatabase({VerboseBloc bloc}) async =>
      await initialize(verboseBloc: bloc);

  /// CREATES/UPDATES DATABASE AND PROVIDES A DATABASE INSTANCE
  /// RECOMMENDED TO BE USED ONLY ONCE
  /// USE [getDatabase] THROUGHOUT THE APP TO GET AN INSTANCE FOR DATABASE OPERATIONS
  Future<Database> initialize({@required VerboseBloc verboseBloc}) async {
    _bloc ??= verboseBloc;

    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      if (_database == null) {
        _database = await _openDb();
      } else if (!_database.isOpen) {
        _database = await _openDb();
      }
      return _database;
    } else {
      throw Exception('Storage access permission is required.');
    }
  }

  Future<Database> _openDb() async =>
      await openDatabase(join((await getDatabasesPath()), Config.DATABASE_NAME),
          singleInstance: true,
          version: Config.DATABASE_VERSION,
          onOpen: _onOpen,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: _onDowngrade);

  List<SqlCommons> _tables(Database db, VerboseBloc bloc) => [
        CategoryTable(db, bloc),
        CompanyTable(db, bloc),
        CustomerTable(db, bloc),
        DeviceTable(db, bloc),
        ErrorDetailTable(db, bloc),
        ErrorMasterTable(db, bloc),
        ExpenseCategoryTable(db, bloc),
        ItemModifierTable(db, bloc),
        ItemTable(db, bloc),
        ModifierTable(db, bloc),
        OrdersTable(db, bloc),
        OutletTable(db, bloc),
        PaymentMethodTable(db, bloc),
        RegisterTable(db, bloc),
        SalesDetailTable(db, bloc),
        SalesMasterTable(db, bloc),
        SettingDetailTable(db, bloc),
        SettingMasterTable(db, bloc),
        ShiftTable(db, bloc),
        TablesTable(db, bloc),
        UserTable(db, bloc),
        VatAmountTable(db, bloc),
      ];

  FutureOr<void> _onCreate(Database db, int version) {
    if (version == 0) {
      log('DATABASE CREATED. VERSION: $version', name: 'onCreate');
      for (var table in _tables(db, _bloc)) {
        table.create();
      }
    }
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      log('DATABASE UPGRADED. VERSION: $oldVersion => $newVersion',
          name: 'onUpgrade');
    }
  }

  FutureOr<void> _onDowngrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion > newVersion) {
      log('DATABASE DOWNGRADED. VERSION: $oldVersion => $newVersion',
          name: 'onDownGrade');
    }
  }

  FutureOr<void> _onOpen(Database db) {
    db.getVersion().then((version) => log('Database Version: $version'));
  }
}
