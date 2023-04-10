import 'package:ding_web/models/Orders/Orderitem.dart';
import 'package:flutter/cupertino.dart';

class Order extends ChangeNotifier{
  List<Orderitem>? items;
  String? order_ids; 
  int? number_of_table;
  String? pending;
  String? customer_uid;
  String? payment_state;
  

  
  Order({this.items,this.number_of_table,this.order_ids,this.pending,this.customer_uid,this.payment_state});

}


// class Order extends ChangeNotifier{
//   List<Orderitem>? items;
//   List? order_ids; 
//   int? number_of_table;
//   String? pending;
//   int? number_of_orders;
  
//   Order({this.items,this.number_of_table,this.order_ids,this.number_of_orders,this.pending});

// }