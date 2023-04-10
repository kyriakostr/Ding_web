import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/OrderPages/AddOrder.dart';
import 'package:ding_web/models/Orders/List.dart';
import 'package:ding_web/Screens/OrderPages/Changeorder.dart';
import 'package:ding_web/Shared/Listtiles.dart';
import 'package:ding_web/models/Menuitem.dart';
import 'package:ding_web/models/Orders/Order.dart';
import 'package:ding_web/models/Orders/Orderitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class OrderSettings extends StatefulWidget {
  Order? order;
  OrderSettings({super.key,this.order});

  @override
  State<OrderSettings> createState() => _OrderSettingsState();
}

class _OrderSettingsState extends State<OrderSettings> {
   late DatabaseReference ref;
  final current_user = FirebaseAuth.instance.currentUser;
  StreamSubscription? subscription;
@override
  void initState() {
    // TODO: implement initState
  ref = FirebaseDatabase.instance.ref().child(current_user!.displayName!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    void showsettingpanel(Orderitem item){
      showDialog(context: context, builder: (context) {
        return ChangeOrder(order: widget.order,item: item,);
      },);
    }
   
    return Scaffold(
      appBar: AppBar(
        
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => showDialog(context: context, 
      builder: (context) => AddOrder(order: widget.order,),),child: Icon(Icons.add_box),),
      body: StreamBuilder(
        stream: ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).onValue ,
        builder: (context, snapshot) {
        if(snapshot.hasData &&
          snapshot.data != null &&
          (snapshot.data! as DatabaseEvent).snapshot.children !=null){
              final data = snapshot.data!.snapshot.value as Map<dynamic,dynamic>;
              widget.order!.items!.clear();
              data.forEach((keys, values) {

                if(keys!='description' && keys!='customer_uid' && keys!='payment_state'){
                String price='';
                String description='';
                String number_of_appereance='';
                String size = '';
                String comments='';
                Map<String,dynamic>? extras={};
                String time = '';
                final value = values as Map<String,dynamic>;

                value.forEach((key, value) {

                  if(key=='price') price=value.toString();
                  if(key=='description') description=value;
                  if(key=='number of appereances') number_of_appereance = value.toString();
                  if(key=='size') size=value.toString().split(':')[0].substring(1);
                  if(key=='comments') comments=value;
                  if(key=='time') time=value;
                  if(key!='size'&&key!='price'&&key!='description'&&key!='number of appereances'&&key!='comments'&&key!='payment_state'&&key!='time')
                  extras[key]=value.toString().split(':')[0];
                  // .substring(1)
                  });

                  final orderitem = Orderitem(name: keys,price: price,description: description,
                  number_of_appereance: number_of_appereance,size: size,comments: comments,extras: extras,time: time);
                  
                  widget.order!.items!.add(orderitem);
                  
                }
  
              });
              return ListView.builder(
                itemCount: widget.order!.items!.length,
                itemBuilder: (context, index) {
                  final orderitem = widget.order!.items![index];
                  return    Container(
                    color: orderitem.description=='Unchecked'?Colors.red : orderitem.description=='pending' ? Colors.amber : Colors.green,
                    child: ListTile(title: Text(orderitem.name!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price:'+orderitem.price!),
                        Text('x'+orderitem.number_of_appereance!),
                        Text('time:'+orderitem.time!),
                        if(orderitem.size!.isNotEmpty) Text('Size:'+orderitem.size!),
                        if(orderitem.comments!='') Text('Comments:'+orderitem.comments!),
                        if(orderitem.extras!.isNotEmpty) ...orderitem.extras!.entries.map((e) => Text(e.key+': '+e.value))
                      ],
                    ),
                    leading: orderitem.description=='Unchecked' ?IconButton(onPressed: () => ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).child(orderitem.name!).update({'description':'pending'}),
                          icon:  Icon(Icons.alarm_add) ,) : (orderitem.description=='pending') ? IconButton(onPressed: () => ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).child(orderitem.name!).update({'description':'Done'}),
                          icon:  Icon(Icons.pending_actions) ,) : Icon(Icons.done),
                    trailing: IconButton(onPressed: () => ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).child(orderitem.name!).remove(),
                    icon:  Icon(Icons.delete) ,),
                    onTap: () => showsettingpanel(orderitem)),
                  );
                },);
                  }else{
                    return Container();
                  }
      },)
    );
  }
}

// FutureBuilder<List<Menuitem>>(
//         initialData: items,
//         future: DatabaseManager(displayName: user.displayName,uid: user.uid).getdata(),
//         builder: (context,snapshot) {
//           final data = snapshot.data! as List<Menuitem>;
//           print(data.runtimeType);
//           if(snapshot.hasData){
//             return Column(
//             children: [
              
//               Text(widget.order!.order_ids!),
//               // Tile(list: widget.order,),
//               Column(children: widget.order!.items!.map((e) => ListTile(
//                 onTap: () {if(mounted) setState(() {
//                    ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).update({'t':5});
//                 });},
//                 title: Text(e.name!),trailing: Text(e.price.toString()),)).toList(),)
              
//             ],
//           );
//           }else if(snapshot.connectionState==ConnectionState.waiting){
//             return Center(child: CircularProgressIndicator(),);
//           }else{
//             return Container();
//           }
//         }
//       )
// ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).update({'t':0}),);