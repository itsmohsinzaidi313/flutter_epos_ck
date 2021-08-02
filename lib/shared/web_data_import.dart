import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:pos_app/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/server_response.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:sqflite/sqflite.dart';

class ImportData {
  final Database database;
  final VerboseBloc bloc;
  ImportData({@required this.database, @required this.bloc});
  Future<ServerResponse> fetchData() async =>
      await GeneralRepo.repo.getInstallationData();

  Future<bool> import() async {
    final serverResponse = await fetchData();
    if (_validResponse(serverResponse)) {
      Map data = jsonDecode(serverResponse.response.body);
      try {
        await _getCompanyList(data[CompanyTable.TABLE_NAME]);
        log('DATA LIST Company Ready.');
      } catch (e) {
        log('>>>ERROR ON getCompanyList', error: e);
        return false;
      }

      try {
        await _getOutletList(data[OutletTable.TABLE_NAME]);
        log('DATA LIST outlet Ready.');
      } catch (e) {
        log('>>>ERROR ON getOutletList', error: e);
        return false;
      }

      try {
        await _getUsersList(data['users']);
        log('DATA LIST users Ready.');
      } catch (e) {
        log('>>>ERROR ON getUsersList', error: e);
        return false;
      }

      try {
        await _getVatAmountList(data['vatamount']);
        log('DATA LIST vatamount Ready.');
      } catch (e) {
        log('>>>ERROR ON getVatAmountList', error: e);
        return false;
      }

      try {
        await _getTablesList(data['tables']);
        log('DATA LIST tables Ready.');
      } catch (e) {
        log('>>>ERROR ON getTablesList', error: e);
        return false;
      }

      try {
        await _getCategoriesList(data['categories']);
        log('DATA LIST categories Ready.');
      } catch (e) {
        log('>>>ERROR ON getCategoriesList', error: e);
        return false;
      }

      try {
        await _getModifiersList(data['modifiers']);
        log('DATA LIST modifiers Ready.');
      } catch (e) {
        log('>>>ERROR ON getModifiersList', error: e);
        return false;
      }

      try {
        await _getItemList(data['item_menus']);
        log('DATA LIST item_menus Ready.');
      } catch (e) {
        log('>>>ERROR ON getItemMenusList', error: e);
        return false;
      }

      try {
        await _getItemModifiersList(data['item_modifiers']);
        log('DATA LIST item_modifiers Ready.');
      } catch (e) {
        log('>>>ERROR ON getItemModifiersList', error: e);
        return false;
      }

      try {
        await _getCustomersList(data['customers']);
        log('DATA LIST customers Ready.');
      } catch (e) {
        log('>>>ERROR ON getCustomersList', error: e);
        return false;
      }

      try {
        await _getPaymentMethodsList(data['payment_methods']);
        log('DATA LIST payment_methods Ready.');
      } catch (e) {
        log('>>>ERROR ON getPaymentMethodsList', error: e);
        return false;
      }

      try {
        await _getExpenseCategoriesList(data['expense_categories']);
        log('DATA LIST expense_categories Ready.');
      } catch (e) {
        log('>>>ERROR ON getExpenseCategoriesList', error: e);
        return false;
      }

      try {
        await _getSalesList(data['sales']);
        log('DATA LIST sales Ready.');
      } catch (e) {
        log('>>>ERROR ON getSalesList', error: e);
        return false;
      }

      // try {
      //   await _getExpensesList(data['expenses']);
      //   log('DATA LIST expenses Ready.');
      // } catch (e) {
      //   log('>>>ERROR ON getExpensesList', error: e);
      //   return false;
      // }

      try {
        await _getDeviceList(data['device']);
        log('DATA LIST device Ready.');
      } catch (e) {
        log('>>>ERROR ON getDeviceList', error: e);
        return false;
      }

      try {
        await _getRegisterList(data['registers']);
        log('DATA LIST registers Ready.');
      } catch (e) {
        log('>>>ERROR ON getRegistersList', error: e);
        return false;
      }
    } else {
      return false;
    }
    return true;
  }

  bool _validResponse(ServerResponse response) {
    bool valid = true;
    if (response == null) {
      valid = false;
    } else if (response.response == null) {
      valid = false;
    }
    return valid;
  }

  Future<void> _getCompanyList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(CompanyTable.TABLE_NAME, {
        CompanyTable.SERVER_ID: item[CompanyTable.SERVER_ID],
        CompanyTable.CURRENCY: item[CompanyTable.CURRENCY],
        CompanyTable.TIMEZONE: item[CompanyTable.TIMEZONE],
        CompanyTable.DATEFORMAT: item[CompanyTable.DATEFORMAT],
        CompanyTable.OUTLET_ID: item[CompanyTable.OUTLET_ID],
        CompanyTable.NAME: item[CompanyTable.NAME],
        CompanyTable.EMAIL: item[CompanyTable.EMAIL],
        CompanyTable.PHONE1: item[CompanyTable.PHONE1],
        CompanyTable.PHONE2: item[CompanyTable.PHONE2],
        CompanyTable.ADDRESS: item[CompanyTable.ADDRESS],
        CompanyTable.STATUS: item[CompanyTable.STATUS],
        CompanyTable.DATE_ADDED: item[CompanyTable.DATE_ADDED],
        CompanyTable.EXPIRY_DATE: item[CompanyTable.EXPIRY_DATE],
        CompanyTable.TOKEN: item[CompanyTable.TOKEN],
      });
      showMessage('Importing',
          'Getting ${CompanyTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getOutletList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(OutletTable.TABLE_NAME, {
        OutletTable.SERVER_ID: item[OutletTable.SERVER_ID],
        OutletTable.OUTLET_NAME: item[OutletTable.OUTLET_NAME],
        OutletTable.OUTLET_CODE: item[OutletTable.OUTLET_CODE],
        OutletTable.ADDRESS: item[OutletTable.ADDRESS],
        OutletTable.PHONE: item[OutletTable.PHONE],
        OutletTable.INVOICE_PRINT: item[OutletTable.INVOICE_PRINT],
        OutletTable.STARTING_DATE: item[OutletTable.STARTING_DATE],
        OutletTable.INVOICE_FOOTER: item[OutletTable.INVOICE_FOOTER],
        OutletTable.COLLECT_TAX: item[OutletTable.COLLECT_TAX],
        OutletTable.PRE_OR_POST_ORDER: item[OutletTable.PRE_OR_POST_ORDER],
        OutletTable.USER_ID: item[OutletTable.USER_ID],
        OutletTable.COMPANY_ID: item[OutletTable.COMPANY_ID],
        OutletTable.DEL_STATUS: item[OutletTable.DEL_STATUS],
      });

      showMessage('Importing',
          'Getting ${OutletTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getUsersList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(UserTable.TABLE_NAME, {
        UserTable.SERVER_ID: item[UserTable.SERVER_ID],
        UserTable.FULL_NAME: item[UserTable.FULL_NAME],
        UserTable.PHONE: item[UserTable.PHONE],
        UserTable.EMAIL: item[UserTable.EMAIL],
        UserTable.PASSWORD: item[UserTable.PASSWORD],
        UserTable.DESIGNATION: item[UserTable.DESIGNATION],
        UserTable.WILL_LOGIN: item[UserTable.WILL_LOGIN],
        UserTable.ROLE: item[UserTable.ROLE],
        UserTable.OUTLET_ID: item[UserTable.OUTLET_ID],
        UserTable.COMPANY_ID: item[UserTable.COMPANY_ID],
        UserTable.ACCOUNT_CREATED_DATE: item[UserTable.ACCOUNT_CREATED_DATE],
        UserTable.LANGUAGE: item[UserTable.LANGUAGE],
        UserTable.LAST_LOGIN: item[UserTable.LAST_LOGIN],
        UserTable.ACTIVE_STATUS: item[UserTable.ACTIVE_STATUS],
        UserTable.DEL_STATUS: item[UserTable.DEL_STATUS],
      });
      showMessage('Importing',
          'Getting ${UserTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getVatAmountList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(VatAmountTable.TABLE_NAME, {
        VatAmountTable.SERVER_ID: item[VatAmountTable.SERVER_ID],
        VatAmountTable.NAME: item[VatAmountTable.NAME],
        VatAmountTable.PERCENTAGE: item[VatAmountTable.PERCENTAGE],
        VatAmountTable.USER_ID: item[VatAmountTable.USER_ID],
        VatAmountTable.COMPANY_ID: item[VatAmountTable.COMPANY_ID],
        VatAmountTable.DEL_STATUS: item[VatAmountTable.DEL_STATUS],
      });
      showMessage('Importing',
          'Getting ${VatAmountTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getTablesList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(TablesTable.TABLE_NAME, {
        TablesTable.SERVER_ID: item[TablesTable.SERVER_ID],
        TablesTable.NAME: item[TablesTable.NAME],
        TablesTable.SIT_CAPACITY: item[TablesTable.SIT_CAPACITY],
        TablesTable.POSITION: item[TablesTable.POSITION],
        TablesTable.DESCRIPTION: item[TablesTable.DESCRIPTION],
        TablesTable.USER_ID: item[TablesTable.USER_ID],
        TablesTable.OUTLET_ID: item[TablesTable.OUTLET_ID],
        TablesTable.COMPANY_ID: item[TablesTable.COMPANY_ID],
        TablesTable.DEL_STATUS: item[TablesTable.DEL_STATUS],
        TablesTable.OCCUPIED: 0,
      });
      showMessage('Importing',
          'Getting ${TablesTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getCategoriesList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(CategoryTable.TABLE_NAME, {
        CategoryTable.SERVER_ID: item[CategoryTable.SERVER_ID],
        CategoryTable.CATEGORY_NAME: item[CategoryTable.CATEGORY_NAME],
        CategoryTable.DESCRIPTION: item[CategoryTable.DESCRIPTION],
        CategoryTable.USER_ID: item[CategoryTable.USER_ID],
        CategoryTable.COMPANY_ID: item[CategoryTable.COMPANY_ID],
        CategoryTable.DEL_STATUS: item[CategoryTable.DEL_STATUS],
      });
      showMessage('Importing',
          'Getting ${CategoryTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getModifiersList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(ModifierTable.TABLE_NAME, {
        ModifierTable.SERVER_ID: item[ModifierTable.SERVER_ID],
        ModifierTable.NAME: item[ModifierTable.NAME],
        ModifierTable.PRICE: item[ModifierTable.PRICE],
        ModifierTable.DESCRIPTION: item[ModifierTable.DESCRIPTION],
        ModifierTable.USER_ID: item[ModifierTable.USER_ID],
        ModifierTable.COMPANY_ID: item[ModifierTable.COMPANY_ID],
        ModifierTable.DEL_STATUS: item[ModifierTable.DEL_STATUS],
      });
      showMessage('Importing',
          'Getting ${ModifierTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getItemList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(ItemTable.TABLE_NAME, {
        ItemTable.SERVER_ID: item[ItemTable.SERVER_ID],
        ItemTable.CODE: item[ItemTable.CODE],
        ItemTable.NAME: item[ItemTable.NAME],
        ItemTable.SALE_PRICE: item[ItemTable.SALE_PRICE],
        ItemTable.PHOTO: item[ItemTable.PHOTO],
        ItemTable.CATEGORY_ID: item[ItemTable.CATEGORY_ID],
        ItemTable.PERCENTAGE: item[ItemTable.PERCENTAGE],
      });
      showMessage('Importing',
          'Getting ${ItemTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getItemModifiersList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(ItemModifierTable.TABLE_NAME, {
        ItemModifierTable.SERVER_ID: item[ItemModifierTable.SERVER_ID],
        ItemModifierTable.FOOD_MENU_ID: item[ItemModifierTable.FOOD_MENU_ID],
        ItemModifierTable.USER_ID: item[ItemModifierTable.USER_ID],
        ItemModifierTable.OUTLET_ID: item[ItemModifierTable.OUTLET_ID],
        ItemModifierTable.COMPANY_ID: item[ItemModifierTable.COMPANY_ID],
        ItemModifierTable.NAME: item[ItemModifierTable.NAME],
        ItemModifierTable.PRICE: item[ItemModifierTable.PRICE],
        ItemModifierTable.DEL_STATUS: item[ItemModifierTable.DEL_STATUS],
      });
      showMessage('Importing',
          'Getting ${ItemModifierTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getCustomersList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(CustomerTable.TABLE_NAME, {
        CustomerTable.SERVER_ID: item[CustomerTable.SERVER_ID],
        CustomerTable.NAME: item[CustomerTable.NAME],
        CustomerTable.PHONE: item[CustomerTable.PHONE],
        CustomerTable.EMAIL: item[CustomerTable.EMAIL],
        CustomerTable.ADDRESS: item[CustomerTable.ADDRESS],
        CustomerTable.GST_NUMBER: item[CustomerTable.GST_NUMBER],
        CustomerTable.AREA_ID: item[CustomerTable.AREA_ID],
        CustomerTable.USER_ID: item[CustomerTable.USER_ID],
        CustomerTable.COMPANY_ID: item[CustomerTable.COMPANY_ID],
        CustomerTable.DEL_STATUS: item[CustomerTable.DEL_STATUS],
        CustomerTable.DATE_OF_BIRTH: item[CustomerTable.DATE_OF_BIRTH],
        CustomerTable.DATE_OF_ANNIVERSARY:
            item[CustomerTable.DATE_OF_ANNIVERSARY],
        CustomerTable.IS_UPLOADED: item[CustomerTable.IS_UPLOADED],
      });
      showMessage('Importing',
          'Getting ${CustomerTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getPaymentMethodsList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(PaymentMethodTable.TABLE_NAME, {
        PaymentMethodTable.SERVER_ID: item[PaymentMethodTable.SERVER_ID],
        PaymentMethodTable.NAME: item[PaymentMethodTable.NAME],
        PaymentMethodTable.DESCRIPTION: item[PaymentMethodTable.DESCRIPTION],
        PaymentMethodTable.USER_ID: item[PaymentMethodTable.USER_ID],
        PaymentMethodTable.COMPANY_ID: item[PaymentMethodTable.COMPANY_ID],
        PaymentMethodTable.DEL_STATUS: item[PaymentMethodTable.DEL_STATUS],
      });
      showMessage('Importing',
          'Getting ${PaymentMethodTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getExpenseCategoriesList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(ExpenseCategoryTable.TABLE_NAME, {
        ExpenseCategoryTable.SERVER_ID: item[ExpenseCategoryTable.SERVER_ID],
        ExpenseCategoryTable.NAME: item[ExpenseCategoryTable.NAME],
        ExpenseCategoryTable.DESCRIPTION:
            item[ExpenseCategoryTable.DESCRIPTION],
        ExpenseCategoryTable.USER_ID: item[ExpenseCategoryTable.USER_ID],
        ExpenseCategoryTable.COMPANY_ID: item[ExpenseCategoryTable.COMPANY_ID],
        ExpenseCategoryTable.DEL_STATUS: item[ExpenseCategoryTable.DEL_STATUS],
      });
      showMessage('Importing',
          'Getting ${ExpenseCategoryTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> _getSalesList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      final masterId = await database.insert(SalesMasterTable.TABLE_NAME, {
        SalesMasterTable.CUSTOMER_ID: item[SalesMasterTable.CUSTOMER_ID],
        SalesMasterTable.SALE_NO: item[SalesMasterTable.SALE_NO],
        SalesMasterTable.TOTAL_ITEMS: item[SalesMasterTable.TOTAL_ITEMS],
        SalesMasterTable.SUBTOTAL: item[SalesMasterTable.SUBTOTAL],
        SalesMasterTable.PAID_AMOUNT: item[SalesMasterTable.PAID_AMOUNT],
        SalesMasterTable.DUE_AMOUNT: item[SalesMasterTable.DUE_AMOUNT],
        SalesMasterTable.DISC: item[SalesMasterTable.DISC],
        SalesMasterTable.DISC_ACTUAL: item[SalesMasterTable.DISC_ACTUAL],
        SalesMasterTable.VAT: item[SalesMasterTable.VAT],
        SalesMasterTable.TOTAL_PAYABLE: item[SalesMasterTable.TOTAL_PAYABLE],
        SalesMasterTable.PAYMENT_METHOD_ID:
            item[SalesMasterTable.PAYMENT_METHOD_ID],
        SalesMasterTable.CLOSE_TIME: item[SalesMasterTable.CLOSE_TIME],
        SalesMasterTable.TABLE_ID: item[SalesMasterTable.TABLE_ID],
        SalesMasterTable.TOTAL_ITEM_DISCOUNT_AMOUNT:
            item[SalesMasterTable.TOTAL_ITEM_DISCOUNT_AMOUNT],
        SalesMasterTable.SUBTOTAL_WITH_DISCOUNT:
            item[SalesMasterTable.SUBTOTAL_WITH_DISCOUNT],
        SalesMasterTable.SUBTOTAL_DISCOUNT_AMOUNT:
            item[SalesMasterTable.SUBTOTAL_DISCOUNT_AMOUNT],
        SalesMasterTable.TOTAL_DISCOUNT_AMOUNT:
            item[SalesMasterTable.TOTAL_DISCOUNT_AMOUNT],
        SalesMasterTable.DELIVERY_CHARGE:
            item[SalesMasterTable.DELIVERY_CHARGE],
        SalesMasterTable.SUBTOTAL_DISCOUNT_VALUE:
            item[SalesMasterTable.SUBTOTAL_DISCOUNT_VALUE],
        SalesMasterTable.SUBTOTAL_DISCOUNT_TYPE:
            item[SalesMasterTable.SUBTOTAL_DISCOUNT_TYPE],
        SalesMasterTable.SALE_DATE: item[SalesMasterTable.SALE_DATE],
        SalesMasterTable.DATETIME: item[SalesMasterTable.DATETIME],
        SalesMasterTable.ORDER_TIME: item[SalesMasterTable.ORDER_TIME],
        SalesMasterTable.COOKING_START_TIME:
            item[SalesMasterTable.COOKING_START_TIME],
        SalesMasterTable.COOKING_DONE_TIME:
            item[SalesMasterTable.COOKING_DONE_TIME],
        SalesMasterTable.MODIFIED: item[SalesMasterTable.MODIFIED],
        SalesMasterTable.USER_ID: item[SalesMasterTable.USER_ID],
        SalesMasterTable.OUTLET_ID: item[SalesMasterTable.OUTLET_ID],
        SalesMasterTable.WAITER_ID: item[SalesMasterTable.WAITER_ID],
        SalesMasterTable.ORDER_STATUS: item[SalesMasterTable.ORDER_STATUS],
        SalesMasterTable.ORDER_TYPE: item[SalesMasterTable.ORDER_TYPE],
        SalesMasterTable.DEL_STATUS: item[SalesMasterTable.DEL_STATUS],
        SalesMasterTable.SALE_VAT_OBJECTS:
            item[SalesMasterTable.SALE_VAT_OBJECTS],
        SalesMasterTable.DEVICE_KEY: item[SalesMasterTable.DEVICE_KEY],
        SalesMasterTable.SERVER_ID: item[SalesMasterTable.SERVER_ID],
        SalesMasterTable.COMPANY_ID: item[SalesMasterTable.COMPANY_ID],
        SalesMasterTable.IS_DELETED: item[SalesMasterTable.IS_DELETED] ?? 0,
        SalesMasterTable.IS_UPLOADED: item[SalesMasterTable.IS_UPLOADED] ?? 1,
        SalesMasterTable.SHIFT: item[SalesMasterTable.SHIFT],
      });
      await getSalesDetailsList(item['details'], masterId);
      showMessage('Importing',
          'Getting ${SalesMasterTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  Future<void> getSalesDetailsList(List<dynamic> i, int masterId) async {
    int count = 1;
    for (var item in i) {
      await database.insert(SalesDetailTable.TABLE_NAME, {
        SalesDetailTable.SERVER_ID: item[SalesDetailTable.SERVER_ID],
        SalesDetailTable.FOOD_MENU_ID: item[SalesDetailTable.FOOD_MENU_ID],
        SalesDetailTable.MENU_NAME: item[SalesDetailTable.MENU_NAME],
        SalesDetailTable.QUANTITY: item[SalesDetailTable.QUANTITY],
        SalesDetailTable.MENU_PRICE_WITHOUT_DISCOUNT:
            item[SalesDetailTable.MENU_PRICE_WITHOUT_DISCOUNT],
        SalesDetailTable.MENU_PRICE_WITH_DISCOUNT:
            item[SalesDetailTable.MENU_PRICE_WITH_DISCOUNT],
        SalesDetailTable.MENU_UNIT_PRICE:
            item[SalesDetailTable.MENU_UNIT_PRICE],
        SalesDetailTable.MENU_VAT_PERCENTAGE:
            item[SalesDetailTable.MENU_VAT_PERCENTAGE],
        SalesDetailTable.MENU_TAXES: item[SalesDetailTable.MENU_TAXES],
        SalesDetailTable.MENU_DISCOUNT_VALUE:
            item[SalesDetailTable.MENU_DISCOUNT_VALUE],
        SalesDetailTable.DISCOUNT_TYPE: item[SalesDetailTable.DISCOUNT_TYPE],
        SalesDetailTable.MENU_NOTE: item[SalesDetailTable.MENU_NOTE],
        SalesDetailTable.DISCOUNT_AMOUNT:
            item[SalesDetailTable.DISCOUNT_AMOUNT],
        SalesDetailTable.ITEM_TYPE: item[SalesDetailTable.ITEM_TYPE],
        SalesDetailTable.COOKING_STATUS: item[SalesDetailTable.COOKING_STATUS],
        SalesDetailTable.COOKING_START_TIME:
            item[SalesDetailTable.COOKING_START_TIME],
        SalesDetailTable.COOKING_DONE_TIME:
            item[SalesDetailTable.COOKING_DONE_TIME],
        SalesDetailTable.PREVIOUS_ID: item[SalesDetailTable.PREVIOUS_ID],
        SalesDetailTable.SALES_MASTER_ID: masterId,
        SalesDetailTable.ORDER_STATUS: item[SalesDetailTable.ORDER_STATUS],
        SalesDetailTable.USER_ID: item[SalesDetailTable.USER_ID],
        SalesDetailTable.OUTLET_ID: item[SalesDetailTable.OUTLET_ID],
        SalesDetailTable.DEL_STATUS: item[SalesDetailTable.DEL_STATUS],
      });
      showMessage('Importing',
          'Getting ${SalesDetailTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  // Future<void> _getExpensesList(List<dynamic> i) async {}

  Future<void> _getDeviceList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(DeviceTable.TABLE_NAME, {
        DeviceTable.SERVER_ID: item[DeviceTable.SERVER_ID],
        DeviceTable.OUTLET_ID: item[DeviceTable.OUTLET_ID],
        DeviceTable.COMPANY_ID: item[DeviceTable.COMPANY_ID],
        DeviceTable.DEVICE_KEY: item[DeviceTable.DEVICE_KEY],
        DeviceTable.DEL_STATUS: item[DeviceTable.DEL_STATUS],
        DeviceTable.IS_INSTALLED: item[DeviceTable.IS_INSTALLED],
        DeviceTable.DATE_ADDED: item[DeviceTable.DATE_ADDED],
        DeviceTable.DATE_MODIFIED: item[DeviceTable.DATE_MODIFIED],
      });
      showMessage('Importing',
          'Getting ${DeviceTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }

  void showMessage(String title, String message) {
    bloc.add(VerboseNewEvent(title: title, message: message));
  }

  Future<void> _getRegisterList(List<dynamic> i) async {
    int count = 1;
    for (var item in i) {
      await database.insert(RegisterTable.TABLE_NAME, {
        RegisterTable.SERVER_ID: item[RegisterTable.SERVER_ID],
        RegisterTable.CLOSING_BALANCE: item[RegisterTable.CLOSING_BALANCE],
        RegisterTable.CLOSING_BALANCE_DATE_TIME:
            item[RegisterTable.CLOSING_BALANCE_DATE_TIME],
        RegisterTable.COMPANY_ID: item[RegisterTable.COMPANY_ID],
        RegisterTable.CUSTOMER_DUE_RECEIVE:
            item[RegisterTable.CUSTOMER_DUE_RECEIVE],
        RegisterTable.DEVICE_KEY: item[RegisterTable.DEVICE_KEY],
        RegisterTable.OPENING_BALANCE: item[RegisterTable.OPENING_BALANCE],
        RegisterTable.OPENING_BALANCE_DATE_TIME:
            item[RegisterTable.OPENING_BALANCE_DATE_TIME],
        RegisterTable.OUTLET_ID: item[RegisterTable.OUTLET_ID],
        RegisterTable.PAYMENT_METHODS_SALE:
            item[RegisterTable.PAYMENT_METHODS_SALE],
        RegisterTable.REGISTER_NO: item[RegisterTable.REGISTER_NO],
        RegisterTable.REGISTER_STATUS: item[RegisterTable.REGISTER_STATUS],
        RegisterTable.SALE_PAID_AMOUNT: item[RegisterTable.SALE_PAID_AMOUNT],
        RegisterTable.USER_ID: item[RegisterTable.USER_ID],
      });
      showMessage('Importing',
          'Getting ${RegisterTable.TABLE_NAME} ... $count/${i.length} ');
      count++;
    }
  }
}
