import 'package:ding_web/models/Orders/List.dart';
import 'package:ding_web/Utils.dart';
import 'package:ding_web/models/Orders/Order.dart';
import 'package:ding_web/models/Orders/Orderitem.dart';
import 'package:ding_web/models/Orders/Orderlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyWidget extends StatefulWidget {
  // Orderlist? orderlist;

  List<Order>? order;
  MyWidget({super.key, this.order,});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  DatabaseReference? ref;
  final current_user = FirebaseAuth.instance.currentUser;
  double cost=0;
  // String state ='';
  
  @override
  void initState() {
    // TODO: implement initState
    widget.order?.forEach((element) { 
      element.items?.forEach((element) {
       cost+=double.parse(element.price!)*int.parse(element.number_of_appereance!);
       });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body:widget.order!.isNotEmpty ? Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: widget.order!.length,
              itemBuilder: (context, index) {
                final item = widget.order![index];
                return Column(
                  children: [
                    Column(
                      children: item.items!.map((e) {
                       
                          
                            // cost+=double.parse(e.price!)*int.parse(e.number_of_appereance!);
                         
                       
                        return ListTile(title: Text(e.name!) ,subtitle: Text(e.price!),trailing: Text(e.description!),
                      leading: e.description=='Unchecked'? Icon(Icons.alarm_add) : e.description=='pending' ? Icon(Icons.pending_actions) : Icon(Icons.check),);}).toList(),
                    ),
                    
                    
                  ],
                );
              },),
          ),
          Padding(
            padding: const EdgeInsets.only( bottom:50),
            child: Text('Total cost '+cost.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold,fontSize: size.width*0.03),),
          )
        ],
      ) : Center(child: Text('The Order is either empty or Due to long time waiting at this page go to previous page to load data'),)
      
      
    );
  }
}