
import 'dart:async';
import 'dart:html';
import 'dart:js_util';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/Host.dart';
import 'package:ding_web/Screens/OrderPages/GeneralSettings.dart';
import 'package:ding_web/models/Orders/List.dart';
import 'package:ding_web/Screens/OrderPages/OrderSettings.dart';
import 'package:ding_web/Textwidget.dart';
import 'package:ding_web/models/Orders/Order.dart';
import 'package:ding_web/models/Orders/Orderitem.dart';
import 'package:ding_web/models/Orders/Orderlist.dart';
import 'package:ding_web/models/Orders/Tempdetails.dart';
import 'package:ding_web/stripe_checkout_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Temp extends StatefulWidget  {
   Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
    late DatabaseReference ref;
    final current_user = FirebaseAuth.instance.currentUser;
 
    List<int> temp_length = [];
  
    late StreamSubscription subscription;
    int count = 0;
    
    @override
  void initState() {
    // TODO: implement initState
    ref = FirebaseDatabase.instance.ref().child(current_user!.displayName!);
   
    
    super.initState();
  }
 
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(
          colors: [Colors.pink,Colors.pink.shade800],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight)),
        child: StreamBuilder(
            stream: ref.onValue,
            builder: (context, snapshot) {
              if(
                snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data! as DatabaseEvent).snapshot.children !=
                    null){
                List<Orderlist> listorder = [];
                
                

                final myorders = snapshot.data!.snapshot.children;
                
                
                myorders.forEach((numoftable) {
                  count+=1;
                
                  String payment_state = '';
                  String payment_method = '';
               
                  List<Order> orders=[];

                    final number_of_orders = numoftable.children.length;

                    numoftable.children.forEach((order) {

                    if(order.key=='payment_state') payment_state=order.value.toString();
                    if(order.key=='payment_method') payment_method=order.value.toString();
                    
                    List<Orderitem> orderitems = [];
                    final order_id = order.key.toString();
                    // print(order_id);

                    

                    if(order_id.length<=3){
                      
                      final node = order.value as Map<dynamic,dynamic>?;


                      String temp_pending='';
                      String temp_payment='';
                      String customer_uid='';
                      node!.forEach((keys,values) {
                        // orderitem.name = element;
                        
                        if(keys!='description' && keys!='customer_uid' && keys!='payment_state'){
                          final value = values as Map<String,dynamic>;
                          String price='';
                          String description='';
                          String number_of_appereance='';
                          String comments = '';
                          String itemsize = '';
                          value.forEach((key, value) {
                            
                            if(key=='price') price=value.toString();
                            if(key=='description') description=value;
                            if(key=='number of appereances') number_of_appereance = value.toString();
                            if(key=='comments') comments = value;
                            if(key=='size') {
                              final temp = value as Map;
                              temp.forEach((key, value) {
                                itemsize=key;
                              });
                            }
                          });
                          final orderitem = Orderitem(name: keys,price: price,description: description,
                          number_of_appereance: number_of_appereance,comments: comments,size: itemsize);
                          orderitems.add(orderitem);
                        }
                        
                       if(keys=='description'){
                         temp_pending = values.toString();
                       }
                       if(keys=='customer_uid'){
                         customer_uid=values.toString();
                       }
                      if(keys=='payment_state'){
                         temp_payment=values.toString();
                       }
                       
                      },);
                      

                      final nextorder = Order(number_of_table: int.tryParse(numoftable.key.toString()),
                      items: orderitems,order_ids: order_id,customer_uid: customer_uid,
                      pending: temp_pending,payment_state: temp_payment);

                      
                      orders.add(nextorder);

                      
                      
                    }


                  });
                  // final current_index = int.parse(numoftable.key.toString())-1;
                  
                  //   if(current_index+1>temp_length.length){
                  //     temp_length.insert(current_index, 0);
                  //   }
                  
                  //    if(temp_length.isEmpty || count<=myorders.length){
                      
                  //      temp_length.insert(current_index, orders.length);
                      
                  //    }
                  //    else if(temp_length[current_index]<orders.length ){
                          
                  //         temp_length[current_index]= orders.length;
                          
                  //         ref.child(numoftable.key.toString()).update({'payment_state':'Not payed'});
                  //         ref.child(numoftable.key.toString()).update({'payment_method':'Cash'});
                  //     }else if(temp_length[current_index]>orders.length){
                  //       temp_length[current_index]=0;
                  //       ref.child(numoftable.key.toString()).update({'payment_state':'None'});
                  //       ref.child(numoftable.key.toString()).update({'payment_method':'None'});
                  //     }
                    int pay=0;
                    if(orders.isNotEmpty){
                     orders.forEach((element) {
                      if(element.payment_state=='Not payed'){
                         pay+=1;
                      }
                     });
                     if(pay>=1){
                      
                      ref.child(numoftable.key.toString()).update({'payment_state':'Not payed'});
                     }else{
                      ref.child(numoftable.key.toString()).update({'payment_state':'Payed'});
                     }
                    }else{
                      ref.child(numoftable.key.toString()).update({'payment_state':'None'});
                      ref.child(numoftable.key.toString()).update({'payment_method':'None'});
                    }
                      
                    final nextorderlist = Orderlist(
                      orderlist: orders,
                      number_of_table: numoftable.key.toString(),
                      payment_state: payment_state,
                      payment_method: payment_method,
                      number_of_orders: number_of_orders);
                    // print(nextorder.order_ids);
                    
                    listorder.add(nextorderlist);
                    
                  // ref.child(numoftable.key.toString()).update({'check':'false'});
                },
                
                );
                
                return Column(
                  children: [
                    
                    GeneralSettings(),
                    
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: listorder.length ,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          
                          
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: _listoforders(listorder, index,size.width,size.height));
                        },
                      ),
                    ),
                  ],
                );
                
              }else if(snapshot.connectionState==ConnectionState.waiting){
                Center(child: CircularProgressIndicator(),);
              } 
              else {
                return Text('Error');
              }
              return Container();
              
            }
            ),
      ),
    );
}
Widget _listoforders(List<Orderlist> listoforders,int index,double width,double height) {


  return GestureDetector(
  onTap: (){ 
    orders.clear();
    listoforders[index].orderlist!.forEach((element) { orders.add(element); });
    
    context.goNamed('Details');
    },
  child:   Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 10,
    clipBehavior: Clip.antiAlias,
    child: Container(
    
      color:listoforders[index].payment_state=='None' ? Colors.lightBlue : (listoforders[index].payment_state=='Not payed') ? Colors.red : Colors.green,
    
      child:   Column(
    
        children: [
          ListTile(title: Text(listoforders[index].number_of_table.toString(),style: TextStyle(fontSize: width*0.015),),
          subtitle: listoforders[index].payment_state=='None' ? Icon(Icons.no_food,size: width*0.02) : listoforders[index].payment_state=='Not payed' ? 
          Text('Not payed',style: TextStyle(fontSize: width*0.015 ),) : Text('Payed',style: TextStyle(fontSize: width*0.015),),
          trailing: IconButton(onPressed: () { 
            listoforders[index].orderlist!.forEach((element) { 
              setState(() {
              // temp_length[index]=0;
              ref.child(listoforders[index].number_of_table.toString()).child(element.order_ids!).remove();
              ref.child(listoforders[index].number_of_table.toString()).update({'payment_state':'None'});
              ref.child(listoforders[index].number_of_table.toString()).update({'payment_method':'None'});
              delete(element.customer_uid!);
              });
  
            });
            
          }, icon: Icon(Icons.delete,size: width*0.02,)),
          leading: (listoforders[index].payment_method=='None' ) ? Text('No payment method',style: TextStyle(fontSize: width*0.015),) : (listoforders[index].payment_method=='With card' )  ? 
          Text('With card',style: TextStyle(fontSize: width*0.015),) :  Text('With cash',style: TextStyle(fontSize: width*0.015),),),
  
          Flexible(
            child: ListView.builder(
            
              physics: ClampingScrollPhysics(),
            
              shrinkWrap: true,
            
              itemCount: listoforders[index].orderlist!.length,
            
              itemBuilder: (context, current_index) {
            
               
            
              final current_order = listoforders[index].orderlist![current_index];
            
            
            
                return Container(
                  
                  color: current_order.pending=='Unchecked' ? Colors.red : (current_order.pending=='pending') ? Colors.amber : Colors.green,
            
                  child: ListTile(
            
            
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderSettings(order: current_order))),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(current_order.order_ids!,style: TextStyle(fontSize: width*0.015)),
                        
                      ],
                    ),
            
                    subtitle: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(current_order.pending!,style: TextStyle(fontSize: width*0.012),),
                          SizedBox(width: 5,),
                          Text(current_order.payment_state!,style: TextStyle(fontSize: width*0.012),),
                          SizedBox(width: 5,),
                          IconButton(onPressed: () => setState(() {
            
                          ref.child(current_order.number_of_table.toString()).child(current_order.order_ids!).update({"payment_state":"Payed"});
                
                        }) , icon: Icon(Icons.done_all,size: width*0.02))
                        ],
                      ),
                    ),
            
                    trailing: current_order.pending=='Unchecked' ? IconButton(onPressed: () => setState(() {
            
                      ref.child(current_order.number_of_table.toString()).child(current_order.order_ids!).update({"description":"pending"});
            
                    }) , icon: Icon(Icons.alarm_add,size: width*0.02)) : 
            
                    current_order.pending=='pending' ? IconButton(onPressed: () => setState(() {
            
                      ref.child(current_order.number_of_table.toString()).child(current_order.order_ids!).update({"description":"Done"});
            
                    }) , icon: Icon(Icons.pending_actions,size: width*0.02)) : Icon(Icons.check,size: width*0.02),
                    leading: IconButton(onPressed:() {
                      
                      ref.child(current_order.number_of_table.toString()).child(current_order.order_ids!).remove();
                      } ,
                    icon:Icon(Icons.delete,size: width*0.02) ,),
            
                  ),
            
                );
            
  
              },),
          ),
    
        ],
    
      ),
    
    ),
  ),
);}
}
Future delete(String uid) async{
  final doc = FirebaseFirestore.instance.collection('Customers').doc(uid);
  await doc.update({'order':''});
}
