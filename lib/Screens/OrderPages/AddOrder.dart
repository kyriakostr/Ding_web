import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/models/Orders/List.dart';
import 'package:ding_web/models/Menuitem.dart';
import 'package:ding_web/models/Orders/Order.dart';
import 'package:ding_web/models/Orders/Orderitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddOrder extends StatefulWidget {
  Order? order;
  
  AddOrder({super.key,this.order,});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final user = FirebaseAuth.instance.currentUser;
   late DatabaseReference ref;
   int num=1;
   String? name;
   String? price;
   double temp_price=0;
   bool checksize = false;
   bool checkextra = false;
   Map<String,dynamic> itemselectedcategory = {};
   Map<String,dynamic> itemselectedcategory_2 = {};
   List<String> itemselectedsize = [];
   Map<String,dynamic> itemselectedsizemap = {};
   TextEditingController commentcontroller=TextEditingController();
  @override
  void initState() {
    final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!).collection('Menus').doc(user!.uid);
    ref = FirebaseDatabase.instance.ref().child(user!.displayName!);
    db.snapshots().listen((event) {
       final data = event.data() as Map<String,dynamic>;
    items.clear();
    data.forEach((key, value) {
      
      final g = value as Map<String,dynamic>;
      g.forEach((k, v) {
        final temp = v as Map<String,dynamic>;
        Map<String, dynamic> size = {};
        Map<String, List<dynamic>> extracategories = {};
        double? price;
        temp.forEach((key, value) {
          if(key=='sizes') size = temp['sizes'];
          if(key!='sizes' &&key!='price'&&key!='ingredients'){
            
            extracategories[key]=value;
          }
          if(key=='price') price=value;
        });
      
       size = Map.fromEntries(size.entries.toList()..sort((a, b) => a.value.toString().compareTo(b.value.toString()),));
       
        final item = Menuitem(name: k,price: price.toString(),size: size,selectedcategory: extracategories);
        print(extracategories.entries);
        setState(() {
          items.add(item);
        });
      });
      
    });
   
    },);
   
    
    // TODO: implement initState
    
    super.initState();
  }
  void increase(){
    setState(() {
      num+=1;
      
    });
  }
  void decrease(){
    setState(() {
      num-=1;
      if(num<1)num=1;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    
     Size size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        height: size.height*0.6,
        width: size.width*0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: size.height*0.03),
                width: size.width*0.4,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: 'Add another item'),
                  items: items.map((e) =>DropdownMenuItem(
                    value: e,
                    child: Text(e.name!))).toList(), onChanged: (value) {
                      if(value!.size!.isNotEmpty) setState(() {
                        checksize = true;
                        itemselectedsize = value.size!.entries.map((e) => e.key+' '+e.value).toList();
                        
                      });
                      if(value.selectedcategory!.isNotEmpty) setState(() {
                        checkextra=true;
                        itemselectedcategory = value.selectedcategory!;
                      });
                   setState(() {
                     name = value.name;
                     price = value.price;
                    
                   });
                },),
              ),
              checksize?Container(
                padding: EdgeInsets.only(top: size.height*0.03),
                width: size.width*0.4,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: 'Add size'),
                  items: itemselectedsize.map((e) =>DropdownMenuItem(
                    value: e,
                    child: Text(e))).toList(), onChanged: (value) {
        
                      setState(() {
                        if(itemselectedsizemap.isNotEmpty){
                          itemselectedsizemap.clear();
                          price=value?.split(' ')[1];
                          itemselectedsizemap.addAll({value!.split(' ')[0]:int.parse(value.split(' ')[1])});
                        }else{
                          price=value?.split(' ')[1];
                          itemselectedsizemap.addAll({value!.split(' ')[0]:int.parse(value.split(' ')[1])});
                        }
                        
                      });
                   
                },),
              ):Container(),
              checkextra? Column(
                children: itemselectedcategory.entries.map((e) {
                  final list = e.value as List<dynamic>;
                  return Container(
                padding: EdgeInsets.only(top: size.height*0.03),
                width: size.width*0.4,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: 'Add ${e.key}'),
                  items: list.map((e) =>DropdownMenuItem(
                    value: e,
                    child: Text(e))).toList(), onChanged: (value) {
        
                      setState(() {
                       itemselectedcategory_2[e.key]={value.toString().split(' ')[0]:double.parse(value.toString().split(' ')[1])};
                      });
                   
                },),
              );}).toList(),
              ) : Container(),
              TextFormField(
                controller: commentcontroller,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),),
                maxLines: 4,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: size.width*0.03,child: FloatingActionButton(onPressed:() => decrease() ,child: Icon(Icons.remove),)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.01),
                    height: 20,
                    width: 20,
                    child: Text(num.toString()),
                  ),
                  Container(width: size.width*0.03,child: FloatingActionButton(onPressed: () => increase() ,child: Icon(Icons.add),)),
                  
                ],
              ),
              ElevatedButton.icon(onPressed: () {
                bool check = false;
                ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).child(name!+' '+DateFormat('yyyy-MM-dd KK:mm:ss').format(DateTime.now())).remove(); 
                widget.order!.items!.forEach((element) {
                  if(element.name==name && element.price==price){
                    setState(() {
                      check = true;
                    });
                  }
                });
                
                itemselectedcategory_2.forEach((key, value) 
                 {
                  final k = value.toString().split(':');
                  temp_price+=double.parse(k[1].substring(0,k[1].length-1));
                  ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).
                  child(name!+' '+DateFormat('yyyy-MM-dd KK:mm:ss').format(DateTime.now())).update({
                    key:value
                  });
                 });
                
                temp_price+=double.parse(price!);
                
                ref.child(widget.order!.number_of_table.toString()).child(widget.order!.order_ids!).child(name!+' '+DateFormat('yyyy-MM-dd KK:mm:ss').format(DateTime.now())).
                update({'price':temp_price,'description':'pending',
                'number of appereances': num ,
                'size':itemselectedsizemap,'comments': commentcontroller.text.trim()
                });
                print(itemselectedcategory_2);
                Navigator.pop(context);
                }
              , icon: Icon(Icons.update), label: Text('Add'))
            ],
          ),
        ),
      ),
    );
    
  }
}