class Outlet {
  final String serverId;
  final String outletName;
  final String outletCode;
  final String address;
  final String phone;
  final String invoicePrint;
  final String startingDate;
  final String invoiceFooter;
  final String collectTax;
  final String preOrPostOrder;
  final String userId;
  final String companyId;
  final String delStatus;

  Outlet(
      {this.serverId,
      this.outletName,
      this.outletCode,
      this.address,
      this.phone,
      this.invoicePrint,
      this.startingDate,
      this.invoiceFooter,
      this.collectTax,
      this.preOrPostOrder,
      this.userId,
      this.companyId,
      this.delStatus});

  Outlet.fromMap(Map<String, dynamic> map)
      : serverId = map['id'],
        outletName = map['outlet_name'],
        outletCode = map['outlet_code'],
        address = map['address'],
        phone = map['phone'],
        invoicePrint = map['invoice_print'],
        startingDate = map['starting_date'],
        invoiceFooter = map['invoice_footer'],
        collectTax = map['collect_tax'],
        preOrPostOrder = map['pre_or_post_payment'],
        userId = map['user_id'],
        companyId = map['company_id'],
        delStatus = map['del_status'];
}
