import 'package:meta/meta.dart';
import 'package:pos_app/models/customer.dart';

class CustomerRepo {
  static CustomerRepo repo = CustomerRepo._internal();

  CustomerRepo._internal();

  Future<List<Customer>> searchCustomer({@required String contact}) async => [];

  Future<void> postCustomer({@required Customer customer}) async => [];
}
