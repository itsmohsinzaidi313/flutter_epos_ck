import 'package:pos_app/database/models/printing_detail.dart';
import 'package:pos_app/database/models/printing_master.dart';

class OrderPrint {
  List<String> printerIps;
  PrintingMaster master;
  List<PrintingDetail> details;
  OrderPrint({this.master, this.details});
}
