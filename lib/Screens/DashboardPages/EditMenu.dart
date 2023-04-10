import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/Animations/DelayedAnimation.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/AuthenticatePages/EditMenuBottomsheet.dart';
import 'package:ding_web/Screens/AuthenticatePages/MenuBottomsheet.dart';
import 'package:ding_web/Screens/DashboardPages/EditVAT.dart';
import 'package:ding_web/Screens/DashboardPages/Edititemprice.dart';
import 'package:ding_web/Screens/DashboardPages/VAT.dart';

import 'package:ding_web/models/Categories.dart';
import 'package:ding_web/models/Menuitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final user = FirebaseAuth.instance.currentUser;
 
  Map<String,List<TextEditingController>> editmenuitemscontrollers = {};
 
   Menuitem item = Menuitem();
  final _formkey = GlobalKey<FormState>();
  
  @override
  // void initState() {
  //   // TODO: implement initState
  
    
  //   // get();
  
    
  // // }
  // // );
  //   super.initState();
  // }
  // void get(){
  //   final doc = FirebaseFirestore.instance.collection('Business').doc(user?.displayName).collection('Menus').doc(user?.uid).snapshots();
  //   subscription=doc.listen((event) {
  //     final map = event.data();
  //   map?.forEach((key, value) {
  //     final temp = value as Map<String,dynamic>;
  //     List<Menuitem> list = [];
  //     temp.forEach((name, details) {
  //       // print(name);
  //       setState(() {
  //         final item = Menuitem(name: name,disabled: false);
  //       print(item.name);
  //       list.add(item);
  //       });
  //     });
  //     setState(() {
  //       menu.addAll({key:[]});
  //     list.sort((a, b) => a.name!.compareTo(b.name!),);
  //     list.forEach((element) {menu[key]?.add(false);});
  //     });
  //   });
  //   // menu.forEach((key, value) {
  //   //   value.forEach((element) {print(element.name);});
  //   // });
  //   setState(() {
  //     menu= Map.fromEntries(menu.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key))); 
  //   });
  //   });
     
  // }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   subscription?.cancel();
  //   super.dispose();
  // }
  
  List<bool>? b;
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    
    return StreamBuilder<Map<String, List<Menuitem>>>(
      stream: DatabaseManager(displayName: user?.displayName,uid: user?.uid).menuitem,
      builder: (context, snapshot) {
        
        if(snapshot.hasData){
         if(editmenuitemscontrollers.isEmpty)
        snapshot.data?.entries.forEach((element) {
          
          editmenuitemscontrollers[element.key] = [];
          
        },);
          return 
          Column(
            
            children: [
              
              SizedBox(height: 10,),
              ...snapshot.data!.entries.map((e) {
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(e.key,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      IconButton(onPressed: () async{
                            showDialog(context: context, builder: 
                            (context) => AlertDialog(
                              title: Text('Attention'),
                              content: Text('Are you sure you want to delete this Category?'),
                              actions: [
                                OutlinedButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: Text('No')),
                                 OutlinedButton(onPressed: () async{
                                  await  FirebaseFirestore.instance.collection('Business').doc(user?.displayName).
                            collection('Menus').doc(user?.uid).update({'${e.key}':FieldValue.delete()});
                            Navigator.pop(context);
                                }, child: Text('Yes'))
                              ],
                            ),);
                          }, icon: Icon(Icons.delete)),
                         
                          
                    ],
                  ),
                  VAT(user: user,category: e.key,),
                  SizedBox(height: 10,),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: e.value.length,
                    itemBuilder: (context, index) {
                      
                      final current_item = e.value[index];
                     
                      return Row(
                        children: [
                          
                          Text(current_item.name!,),
                          SizedBox(width: 10,),
                          Text('PRICE:'+current_item.price!),
                          Switch(value: current_item.disabled! , onChanged:(value) async{
                            
  
                            await  FirebaseFirestore.instance.collection('Business').doc(user?.displayName).
                            collection('Menus').doc(user?.uid).update({'${e.key}.${current_item.name}.disabled':value});
                            print(current_item.disabled);
                            

                           
                          },  ),
                          IconButton(onPressed: () {
                            showDialog(context: context, builder: 
                            (context) => AlertDialog(
                              title: Text('Attention'),
                              content: Text('Are you sure you want to delete this menu item?'),
                              actions: [
                                OutlinedButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: Text('No')),
                                 OutlinedButton(onPressed: () async{
                                  await  FirebaseFirestore.instance.collection('Business').doc(user?.displayName).
                            collection('Menus').doc(user?.uid).update({'${e.key}.${current_item.name}':FieldValue.delete()});
                            Navigator.pop(context);
                                }, child: Text('Yes'))
                              ],
                            ),);
                          }, icon: Icon(Icons.delete)),
                           IconButton(onPressed: () => showModalBottomSheet(context: context, builder:
                           (context) => Edititemprice(current_item: current_item,category: e.key,) ,), icon: Icon(Icons.edit))
                        ],
                      );
                    },),
                    
                    editmenuitemscontrollers[e.key]!.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: editmenuitemscontrollers[e.key]!.length,
                      itemBuilder: (context, index) {
                       
                        return Column(
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: size.width*0.2,
                                    child: TextFormField(
                                      controller: editmenuitemscontrollers[e.key]![index],
                                       decoration: InputDecoration(
                                              
                                        hintText:'Enter a menu item (e.g. espresso,orange juice,cake)',
                                        labelText: 'Enter a menu item',
                                        labelStyle: TextStyle(color: Colors.black,fontSize: size.width*0.015),
                                        hintStyle: TextStyle(color: Colors.black,fontSize: size.width*0.015),
                                        prefixIcon: Icon(Icons.menu_book,size: size.width*0.015,),
                                        
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2),
                                        borderSide: BorderSide(color: Colors.black) ),
                                        border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  borderSide: BorderSide(
                                                                    color: Colors.black)),
                                        errorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Colors.black),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                        focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Colors.black),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                        errorStyle: TextStyle(color: Colors.black,fontSize: size.width*0.01),
                                        ),
                                        onChanged: (value) => setState(() {
                                          item.name=value;
                                          item.disabled = false;
                                          
                                        }),
                                      
                                    ),
                                  ),
                                ),
                                SizedBox(width:10 ,),
                                ElevatedButton(onPressed: () {
                                   showModalBottomSheet(shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
                                      ),
                                      backgroundColor: Colors.white,
                                      isScrollControlled: true,context: context, builder: (context) => EditMenuBottomsheet(
                                    menuitem: item,
                                    category: e.key,
                                    user: user,
                                   ),);
                                }, child: Text('Edit item')),
                                IconButton(onPressed: () => setState(() {
                                  editmenuitemscontrollers[e.key]?.removeAt(index);
                                }), icon: Icon(Icons.delete))
                              ],
                            ),
                            SizedBox(height: 10,),
                          editmenuitemscontrollers[e.key]?[index]==editmenuitemscontrollers[e.key]?.last ?  ElevatedButton(onPressed: () {
                      setState(() {
                        editmenuitemscontrollers[e.key]?.add(TextEditingController());
                      });
                    }, child: Text('Add item')) : Container()
                          ],
                        );
                      },) : ElevatedButton(onPressed: () {
                      setState(() {
                        editmenuitemscontrollers.addAll({e.key:[TextEditingController()]});
                        print(editmenuitemscontrollers[e.key]?.length);
                      });
                    }, child: Text('Add item')),
                ],
              );}
          )
          ]);
        
        }else if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          return Container();
        }}
  );
      }
     
      
      
      }

      

      