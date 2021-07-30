import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/sql_commons.dart';
import 'package:pos_app/shared/config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pos_app/database/tables/database_tables.dart';

/// Provides interface for database operations
/// Execute [initialize] once to initialize local database
/// Use [getDatabase] to get database instance for database operations after executing [initialize] once
class LocalDatabase {
  static LocalDatabase database = LocalDatabase._internal();
  LocalDatabase._internal();

  Database _database;
  VerboseBloc _bloc;

  /// Use after using [initialize] once
  /// Otherwise provide [VerboseBloc] instance
  /// This will first execute [initialize] then provide a database instance
  Future<Database> getDatabase({VerboseBloc bloc}) async =>
      await initialize(verboseBloc: bloc);

  /// Creates/Updates database and provides a database instance
  /// It is recommended to be used only once
  /// Use [getDatabase] throughout the App
  /// To get an instance for database operations
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

  Future<void> reinstall() async {
    await _dropTables(_database);
    await _createTables(_database);
  }

  Future<void> clear() async => await _deleteTables(_database);

  Future<Database> _openDb() async =>
      await openDatabase(join((await getDatabasesPath()), Config.DATABASE_NAME),
          singleInstance: true,
          version: Config.DATABASE_VERSION,
          onOpen: _onOpen,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: _onDowngrade);

  List<SqlCommons> _tables;
  List<SqlCommons> tables(Database db, VerboseBloc bloc) => _tables ??= [
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

  Future<void> _createTables(Database db) async {
    List<SqlCommons> list = tables(db, _bloc);
    for (var table in list) {
      await table.create();
    }
    _bloc.add(VerboseNewEvent(title: 'Local Database', message: 'Installation successful.'));
  }

  Future<void> _deleteTables(Database db) async {
    for (var table in tables(db, _bloc)) {
      await table.deleteTable();
    }
  }

  Future<void> _dropTables(Database db) async {
    for (var table in tables(db, _bloc)) {
      await table.drop();
    }
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    if (version == 1) {
      log('DATABASE CREATED. VERSION: $version', name: 'LocalDatabase');
      await _createTables(db);
    }
  }

  Future<FutureOr<void>> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      log('DATABASE UPGRADED. VERSION: $oldVersion => $newVersion',
          name: 'LocalDatabase');
      await _dropTables(db);
      await _createTables(db);
    }
  }

  Future<FutureOr<void>> _onDowngrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion > newVersion) {
      log('DATABASE DOWNGRADED. VERSION: $oldVersion => $newVersion',
          name: 'LocalDatabase');
      await _dropTables(db);
      await _createTables(db);
    }
  }

  FutureOr<void> _onOpen(Database db) async =>
      log('Database Version: ${await db.getVersion()}', name: 'LocalDatabase');
}
