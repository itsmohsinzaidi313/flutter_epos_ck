class SalesDetails {
  String id;
  String foodMenuId;
  String menuName;
  String qty;
  String menuPriceWithoutDiscount;
  String menuPriceWithDiscount;
  String menuUnitPrice;
  String menuVatPercentage;
  String menuTaxes;
  String menuDiscountValue;
  String discountType;
  String menuNote;
  String discountAmount;
  String itemType;
  String cookingStatus;
  String cookingStartTime;
  String cookingDoneTime;
  String previousId;
  String salesMasterId;
  String orderStatus;
  String userId;
  String outletId;
  String delStatus;

  SalesDetails(
      {this.id,
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
      : id = map[''],
        foodMenuId = map[''],
        menuName = map[''],
        qty = map[''],
        menuPriceWithoutDiscount = map[''],
        menuPriceWithDiscount = map[''],
        menuUnitPrice = map[''],
        menuVatPercentage = map[''],
        menuTaxes = map[''],
        menuDiscountValue = map[''],
        discountType = map[''],
        menuNote = map[''],
        discountAmount = map[''],
        itemType = map[''],
        cookingStatus = map[''],
        cookingStartTime = map[''],
        cookingDoneTime = map[''],
        previousId = map[''],
        salesMasterId = map[''],
        orderStatus = map[''],
        userId = map[''],
        outletId = map[''],
        delStatus = map[''];
}
