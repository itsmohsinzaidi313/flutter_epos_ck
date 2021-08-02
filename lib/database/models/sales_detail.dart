import 'package:pos_app/database/tables/database_tables.dart';
import 'package:pos_app/models/customer_order.dart';
import 'package:pos_app/models/menu_item.dart';
import 'package:pos_app/shared/app_library.dart';

class SalesDetails {
  int localId;
  int serverId;
  int foodMenuId;
  String menuName;
  double qty;
  double menuPriceWithoutDiscount;
  double menuPriceWithDiscount;
  double menuUnitPrice;
  double menuVatPercentage;
  double menuTaxes;
  double menuDiscountValue;
  String discountType;
  String menuNote;
  double discountAmount;
  String itemType;
  String cookingStatus;
  String cookingStartTime;
  String cookingDoneTime;
  int previousId;
  int salesMasterId;
  String orderStatus;
  int userId;
  int outletId;
  String delStatus;

  SalesDetails(
      {this.localId,
      this.serverId,
      this.foodMenuId,
      this.menuName,
      this.qty,
      this.menuPriceWithoutDiscount,
      this.menuPriceWithDiscount,
      this.menuUnitPrice,
      this.menuVatPercentage,
      this.menuTaxes,
      this.menuDiscountValue,
      this.discountType,
      this.menuNote,
      this.discountAmount,
      this.itemType,
      this.cookingStatus,
      this.cookingStartTime,
      this.cookingDoneTime,
      this.previousId,
      this.salesMasterId,
      this.orderStatus,
      this.userId,
      this.outletId,
      this.delStatus});

  SalesDetails.fromMap(Map<String, dynamic> map)
      : localId = map[SalesDetailTable.LOCAL_ID],
        serverId = map[SalesDetailTable.SERVER_ID],
        foodMenuId = map[SalesDetailTable.FOOD_MENU_ID],
        menuName = map[SalesDetailTable.MENU_NAME],
        qty = map[SalesDetailTable.QUANTITY],
        menuPriceWithoutDiscount =
            map[SalesDetailTable.MENU_PRICE_WITHOUT_DISCOUNT],
        menuPriceWithDiscount = map[SalesDetailTable.MENU_PRICE_WITH_DISCOUNT],
        menuUnitPrice = map[SalesDetailTable.MENU_UNIT_PRICE],
        menuVatPercentage = map[SalesDetailTable.MENU_VAT_PERCENTAGE],
        menuTaxes = map[SalesDetailTable.MENU_TAXES],
        menuDiscountValue = map[SalesDetailTable.MENU_DISCOUNT_VALUE],
        discountType = map[SalesDetailTable.DISCOUNT_TYPE],
        menuNote = map[SalesDetailTable.MENU_NOTE],
        discountAmount = map[SalesDetailTable.DISCOUNT_AMOUNT],
        itemType = map[SalesDetailTable.ITEM_TYPE],
        cookingStatus = map[SalesDetailTable.COOKING_STATUS],
        cookingStartTime = map[SalesDetailTable.COOKING_START_TIME],
        cookingDoneTime = map[SalesDetailTable.COOKING_DONE_TIME],
        previousId = map[SalesDetailTable.PREVIOUS_ID],
        salesMasterId = map[SalesDetailTable.SALES_MASTER_ID],
        orderStatus = map[SalesDetailTable.ORDER_STATUS],
        userId = map[SalesDetailTable.USER_ID],
        outletId = map[SalesDetailTable.OUTLET_ID],
        delStatus = map[SalesDetailTable.DEL_STATUS];

  SalesDetails.fromItem(int masterId, int userId, int outletId, MenuItem item)
      : foodMenuId = int.parse(item.id),
        menuName = item.name,
        qty = item.quantity,
        menuPriceWithoutDiscount = double.parse(item.price) * item.quantity,
        menuPriceWithDiscount = (double.parse(item.price) * item.quantity),
        menuUnitPrice = double.parse(item.price),
        menuVatPercentage = 0.0,
        menuDiscountValue = 0,
        discountType = 'plain',
        discountAmount = 0.0,
        itemType = 'Kitchen Item',
        cookingStatus = 'Done',
        cookingStartTime = Lib.getCurrentDateTimeWithFormat(),
        cookingDoneTime = Lib.getCurrentDateTimeWithFormat(),
        salesMasterId = masterId,
        orderStatus = '0',
        userId = userId,
        outletId = outletId,
        delStatus = 'Live';

        Map<String, dynamic> getMapInsert() => {
          SalesDetailTable.SERVER_ID: serverId,
          SalesDetailTable.FOOD_MENU_ID: foodMenuId,
          SalesDetailTable.MENU_NAME: menuName,
          SalesDetailTable.QUANTITY: qty,
          SalesDetailTable.MENU_PRICE_WITHOUT_DISCOUNT: menuPriceWithoutDiscount,
          SalesDetailTable.MENU_PRICE_WITH_DISCOUNT: menuPriceWithDiscount,
          SalesDetailTable.MENU_UNIT_PRICE: menuUnitPrice,
          SalesDetailTable.MENU_VAT_PERCENTAGE: menuVatPercentage,
          SalesDetailTable.MENU_TAXES: menuTaxes,
          SalesDetailTable.MENU_DISCOUNT_VALUE: menuDiscountValue,
          SalesDetailTable.DISCOUNT_TYPE: discountType,
          SalesDetailTable.MENU_NOTE: menuNote,
          SalesDetailTable.DISCOUNT_AMOUNT: discountAmount,
          SalesDetailTable.ITEM_TYPE: itemType,
          SalesDetailTable.COOKING_STATUS: cookingStatus,
          SalesDetailTable.COOKING_START_TIME: cookingStartTime,
          SalesDetailTable.COOKING_DONE_TIME:cookingDoneTime,
          SalesDetailTable.PREVIOUS_ID: previousId,
          SalesDetailTable.SALES_MASTER_ID: salesMasterId,
          SalesDetailTable.ORDER_STATUS: orderStatus,
          SalesDetailTable.USER_ID: userId,
          SalesDetailTable.OUTLET_ID: outletId,
          SalesDetailTable.DEL_STATUS: delStatus,
        };
}
