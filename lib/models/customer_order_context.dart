import 'package:pos_app/database/models/device.dart';
import 'package:pos_app/database/models/register.dart';
import 'package:pos_app/database/models/shift.dart';
import 'package:pos_app/database/models/user.dart';
import 'package:pos_app/models/customer.dart';

abstract class OrderContext {
  Customer customer;
  Register register;
  User user;
  Device device;
  Shift shift;
  
}
