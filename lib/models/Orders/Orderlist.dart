import 'package:ding_web/models/Orders/Order.dart';

class Orderlist {
  List<Order>? orderlist;
  String? number_of_table;
  String? payment_state;
  String? payment_method;
  int? number_of_orders;

  Orderlist({this.orderlist,this.number_of_table,this.payment_state,this.payment_method,this.number_of_orders});
}