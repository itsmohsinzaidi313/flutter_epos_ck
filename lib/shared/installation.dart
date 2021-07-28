import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:pos_app/database/table_object/company_table.dart';
import 'package:pos_app/database/table_object/outlet_table.dart';
import 'package:pos_app/models/objects/server_response.dart';
import 'package:pos_app/repositories/general_repository.dart';
import 'package:sqflite/sqflite.dart';

class Installation {
  Database _database;
  Installation() {
    getDatabasesPath().then((value) => );
  }
  Future<bool> auto() {}
  Future<ServerResponse> fetchData() async =>
      await GeneralRepo.repo.getInstallationData();

  Future<void> import() async {
    final serverResponse = await fetchData();
    if (serverResponse.status) {
      Map data = serverResponse.data;
      try {
        getCompanyList(data[CompanyTable.TABLE_NAME]);
        log('DATA LIST Company Ready.');
      } catch (e) {
        log('>>>ERROR ON getCompanyList', error: e);
        return false;
      }

      try {
        getOutletList(data[OutletTable.TABLE_NAME]);
        log('DATA LIST outlet Ready.');
      } catch (e) {
        log('>>>ERROR ON getOutletList', error: e);
        return false;
      }

      try {
        getUsersList(data['users']);
        log('DATA LIST users Ready.');
      } catch (e) {
        log('>>>ERROR ON getUsersList', error: e);
        return false;
      }

      try {
        getVatAmountList(data['vatamount']);
        log('DATA LIST vatamount Ready.');
      } catch (e) {
        log('>>>ERROR ON getVatAmountList', error: e);
        return false;
      }

      try {
        getTablesList(data['tables']);
        log('DATA LIST tables Ready.');
      } catch (e) {
        log('>>>ERROR ON getTablesList', error: e);
        return false;
      }

      try {
        getCategoriesList(data['categories']);
        log('DATA LIST categories Ready.');
      } catch (e) {
        log('>>>ERROR ON getCategoriesList', error: e);
        return false;
      }

      try {
        getModifiersList(data['modifiers']);
        log('DATA LIST modifiers Ready.');
      } catch (e) {
        log('>>>ERROR ON getModifiersList', error: e);
        return false;
      }

      try {
        getItemList(data['item_menus']);
        log('DATA LIST item_menus Ready.');
      } catch (e) {
        log('>>>ERROR ON getItemMenusList', error: e);
        return false;
      }

      try {
        getItemModifiersList(data['item_modifiers']);
        log('DATA LIST item_modifiers Ready.');
      } catch (e) {
        log('>>>ERROR ON getItemModifiersList', error: e);
        return false;
      }

      try {
        getCustomersList(data['customers']);
        log('DATA LIST customers Ready.');
      } catch (e) {
        log('>>>ERROR ON getCustomersList', error: e);
        return false;
      }

      try {
        getPaymentMethodsList(data['payment_methods']);
        log('DATA LIST payment_methods Ready.');
      } catch (e) {
        log('>>>ERROR ON getPaymentMethodsList', error: e);
        return false;
      }

      try {
        getExpenseCategoriesList(data['expense_categories']);
        log('DATA LIST expense_categories Ready.');
      } catch (e) {
        log('>>>ERROR ON getExpenseCategoriesList', error: e);
        return false;
      }

      try {
        getSalesList(data['sales']);
        log('DATA LIST sales Ready.');
      } catch (e) {
        log('>>>ERROR ON getSalesList', error: e);
        return false;
      }

      try {
        getExpensesList(data['expenses']);
        log('DATA LIST expenses Ready.');
      } catch (e) {
        log('>>>ERROR ON getExpensesList', error: e);
        return false;
      }

      try {
        getDeviceList(data['device']);
        log('DATA LIST device Ready.');
      } catch (e) {
        log('>>>ERROR ON getDeviceList', error: e);
        return false;
      }

      try {
        getRegisterList(data['registers']);
        log('DATA LIST registers Ready.');
      } catch (e) {
        log('>>>ERROR ON getRegistersList', error: e);
        return false;
      }
    } else {
      throw Exception(serverResponse.message);
    }

    bool validResponse(ServerResponse response) {
      return true;
    }
  }

  void getCompanyList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listCompany.add(new Company(
          serverId: e['id'],
          currency: e['currency'],
          timezone: e['timezone'],
          dateFormat: e['date_format'],
          outletId: e['outlet_id'],
          name: e['name'],
          email: e['email'],
          phone1: e['phone_1'],
          phone2: e['phone_2'],
          address: e['address'],
          status: e['status'],
          dateAdded: e['date_added'],
          expiryDate: e['expiry_date'],
          token: e['token']));
      String newMessage = 'Getting Company ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getOutletList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listOutlet.add(new Outlet(
          serverId: e['id'],
          outletName: e['outlet_name'],
          outletCode: e['outlet_code'],
          address: e['address'],
          phone: e['phone'],
          invoicePrint: e['invoice_print'],
          startingDate: e['starting_date'],
          invoiceFooter: e['invoice_footer'],
          collectTax: e['collect_tax'],
          preOrPostOrder: e['pre_or_post_payment'],
          userId: e['user_id'],
          companyId: e['company_id'],
          delStatus: e['del_status']));
      String newMessage = 'Getting Outlet ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getUsersList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listUsers.add(new User(
          serverId: e['id'],
          fullName: e['full_name'],
          phone: e['phone'],
          emailAddress: e['email_address'],
          password: e['password'],
          designation: e['designation'],
          willLogin: e['will_login'],
          role: e['role'],
          outletId: e['outlet_id'],
          companyId: e['company_id'],
          accountCreationDate: e['account_creation_date'],
          language: e['language'],
          lastLogin: e['last_login'],
          activeStatus: e['active_status'],
          delStatus: e['del_status']));
      String newMessage = 'Getting User ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getVatAmountList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listVatAmount.add(new VatAmount(
        serverID: e['id'],
        name: e['name'],
        percentage: e['percentage'],
        companyId: e['company_id'],
        userId: e['user_id'],
        delStatus: e['del_status'],
      ));
      String newMessage = 'Getting VatAmount ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getTablesList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listTables.add(new Table(
          serverId: e['id'],
          name: e['name'],
          sitCapacity: e['sit_capacity'],
          position: e['position'],
          description: e['description'],
          userId: e['user_id'],
          outletId: e['outlet_id'],
          companyId: e['company_id'],
          delStatus: e['del_status']));
      String newMessage = 'Getting Table ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getCategoriesList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listCategories.add(new Category(
          serverId: e['id'],
          categoryName: e['category_name'],
          description: e['description'],
          userId: e['user_id'],
          companyId: e['company_id'],
          delStatus: e['del_status']));
      String newMessage = 'Getting Category ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getModifiersList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listModifiers.add(new Modifier(
          serverId: e['id'],
          name: e['name'],
          price: e['price'],
          description: e['description'],
          userId: e['user_id'],
          companyId: e['company_id'],
          delStatus: e['del_status']));
      String newMessage = 'Getting Modifier ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getItemList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listItem.add(new Item(
          serverId: e['id'],
          code: e['code'],
          name: e['name'],
          salePrice: e['sale_price'],
          photo: e['photo'],
          categoryName: e['category_name'],
          quantity: 1.toString(),
          percentage: e['percentage']));
      String newMessage = 'Getting Item ... $count/${i.length} ';
      print(newMessage);
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getItemModifiersList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listItemModifiers.add(new ItemModifier(
          serverId: e['id'],
          modifierId: e['modifier_id'],
          foodMenuId: e['food_menu_id'],
          userId: e['user_id'],
          outletId: e['outlet_id'],
          companyId: e['company_id'],
          name: e['name'],
          price: e['price'],
          delStatus: e['del_status']));
      String newMessage = 'Getting ItemModifier ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getCustomersList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listCustomers.add(new Customer(
          serverId: e['id'],
          name: e['name'],
          phone: e['phone'],
          email: e['email'],
          address: e['address'],
          gstNumber: e['gst_number'],
          areaId: e['area_id'],
          userId: e['user_id'],
          companyId: e['company_id'],
          delStatus: e['del_status'],
          dateOfBirth: e['date_of_birth'],
          dateOfAnniversary: e['date_of_anniversary']));
      String newMessage = 'Getting Customer ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getPaymentMethodsList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listPaymentMethods.add(new PaymentMethod(
        serverId: e['id'],
        name: e['name'],
        description: e['description'],
        userId: e['user_id'],
        companyId: e['company_id'],
        delStatus: e['del_status'],
      ));
      String newMessage = 'Getting PaymentMethod ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getExpenseCategoriesList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listExpenseCategories.add(new ExpenseCategory(
        serverId: e['id'],
        name: e['name'],
        description: e['description'],
        userId: e['user_id'],
        companyId: e['company_id'],
        delStatus: e['del_status'],
      ));
      String newMessage = 'Getting ExpenseCategory ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getSalesList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listSales.add(SalesMaster(
        serverId: e['id'],
        customerId: e['customer_id'],
        saleNo: e['sale_no'],
        totalItems: e['total_items'],
        subTotal: e['sub_total'],
        paidAmount: e['paid_amount'],
        dueAmount: e['due_amount'],
        disc: e['disc'],
        discActual: e['disc_actual'],
        vat: e['vat'],
        totalPayable: e['total_payable'],
        paymentMethodId: e['payment_method_id'],
        closeTime: e['close_time'],
        tableId: e['table_id'],
        totalItemDiscountAmount: e['total_item_discount_amount'],
        subTotalWithDiscount: e['sub_total_with_discount'],
        subTotalDiscountAmount: e['sub_total_discount_amount'],
        totalDiscountAmount: e['total_discount_amount'],
        deliveryCharge: e['delivery_charge'],
        subTotalDiscountValue: e['sub_total_discount_value'],
        subTotalDiscountType: e['sub_total_discount_type'],
        saleDate: e['sale_date'],
        dateTime: e['date_time'],
        orderTime: e['order_time'],
        cookingStartTime: e['cooking_start_time'],
        cookingDoneTime: e['cooking_done_time'],
        modified: e['modified'],
        userId: e['user_id'],
        waiterId: e['waiter_id'],
        outletId: e['outlet_id'],
        orderStatus: e['order_status'],
        orderType: e['order_type'],
        delStatus: e['del_status'],
        saleVatObjects: e['sale_vat_objects'],
        deviceKey: e['device_key'],
        companyId: e['company_id'],
      ));
      String newMessage = 'Getting Customer Order ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
      getSalesDetailsList(e['details']);
    });
  }

  void getSalesDetailsList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listSalesDetail.add(SalesDetails(
        salesMasterId: e['sales_id'],
        foodMenuId: e['food_menu_id'],
        menuName: e['menu_name'],
        qty: e['qty'],
        menuPriceWithoutDiscount: e['menu_price_without_discount'],
        menuPriceWithDiscount: e['menu_price_with_discount'],
        menuUnitPrice: e['menu_unit_price'],
        menuVatPercentage: e['menu_vat_percentage'],
        menuTaxes: e['menu_taxes'],
        menuDiscountValue: e['menu_discount_value'],
        discountType: e['discount_type'],
        menuNote: e['menu_note'],
        discountAmount: e['discount_amount'],
        itemType: e['item_type'],
        cookingStatus: e['cooking_status'],
        cookingStartTime: e['cooking_start_time'],
        cookingDoneTime: e['cooking_done_time'],
        previousId: e['previous_id'],
        orderStatus: e['order_status'],
        userId: e['user_id'],
        outletId: e['outlet_id'],
        delStatus: e['del_status'],
      ));
      String newMessage = 'Getting Order Details ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getExpensesList(List<dynamic> i) {}

  void getDeviceList(List<dynamic> i) {
    int count = 1;
    i.forEach((e) {
      DataLists.instance.listDevices.add(new Device(
        serverId: e['id'],
        outletId: e['outlet_id'],
        companyId: e['company_id'],
        deviceKey: e['device_key'],
        delStatus: e['del_status'],
        isInstalled: e['is_installed'],
        dateAdded: e['date_added'],
        dateModified: e['date_modified'],
      ));
      String newMessage = 'Getting Devices ... $count/${i.length} ';
      Lib.dialogMessageUpdate(newMessage: newMessage, bloc: bloc);
      count++;
    });
  }

  void getRegisterList(List<dynamic> i) {
    i.forEach((element) {
      DataLists.instance.listRegisters.add(new Register.fromJson(element));
    });
  }
}
