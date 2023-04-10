import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/Animations/DelayedAnimation.dart';
import 'package:ding_web/Host.dart';
import 'package:ding_web/Screens/AuthenticatePages/BusinessPage.dart';
import 'package:ding_web/Screens/AuthenticatePages/SetBusinessData.dart';
import 'package:ding_web/Screens/AuthenticatePages/Temp_BusinessPage.dart';
import 'package:ding_web/Screens/CustomerPage.dart';
import 'package:ding_web/models/Customer.dart';
import 'package:ding_web/stripe_checkout_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class ChooseTemp extends StatefulWidget {
  const ChooseTemp({super.key});

  @override
  State<ChooseTemp> createState() => _ChooseTempState();
}

class _ChooseTempState extends State<ChooseTemp> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.pink,
      body: FutureBuilder(
              future: readbusiness(),
              builder: (context, snapshot) {
                
                if(snapshot.hasData){
                  return TempBusinessPage();
                }else if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                
                else {

            return StreamBuilder<Customer>(
              stream: read(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return CustomerPage();
                
                }else if(snapshot.connectionState==ConnectionState.waiting){
                  Center(child: CircularProgressIndicator(),);
                }
                else{
                  return 
             Column(
               children: [
                Text('Choose Between Customer and Business',
                style: TextStyle(fontFamily: 'Montserrat',
                fontSize: size.width*0.02,color: Colors.white,fontWeight: FontWeight.bold),),
                SizedBox(height: size.height*0.2,),
                 Center(
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                    DelayedAnimation(
                      delayedanimation: 50,
                      aniduration: 700,
                      anioffsetx: 0.35,
                      anioffsety: 0,
                      child: GestureDetector(
                        
                        onTap: () => context.goNamed('BusinessData'),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: size.height*0.5,
                              width: size.width*0.2,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: size.width*0.01),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Business',style: TextStyle(fontFamily: 'Montserrat',color: Colors.pink,fontWeight: FontWeight.w700,fontSize: size.width*0.02),),
                                        SizedBox(height: size.height*0.12,),
                                        Text('Get the opportunity to have the organization of your business in your hands',
                                        style: TextStyle(color: Colors.pink,fontSize:size.width*0.015,fontWeight: FontWeight.w600  ),)
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width*0.1,),
                    DelayedAnimation(
                      delayedanimation: 100,
                      aniduration: 700,
                      anioffsetx: 0.35,
                      anioffsety: 0,
                      child: GestureDetector(
                        
                        onTap: () => createcustomer(),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: size.height*0.5,
                              width: size.width*0.2,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: size.width*0.01),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Customer',style: TextStyle(fontFamily: 'Montserrat',color: Colors.pink,fontWeight: FontWeight.w700,fontSize: size.width*0.02),),
                                        SizedBox(height: size.height*0.12,),
                                        Text('Get the experience of ordering easy and fast.',
                                        style: TextStyle(color: Colors.pink,fontSize:size.width*0.015,fontWeight: FontWeight.w600  ),)
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],),
                 ),
               ],
             );

                }
                return Container();
              },);
            

          }
          
        } ,
        
      ) ,
    );
  }
Stream<Customer> read(){
  final db = FirebaseFirestore.instance.collection('Customers').doc(user!.uid).snapshots();
  
  return db.map((doc) => Customer.fromJson(doc.data()!));
}
  Future<DocumentSnapshot<Map<String, dynamic>>> readbusiness() async{
    final doc = FirebaseFirestore.instance.collection('Business').where('email',isEqualTo: user?.email,isNull: false);
    final snapshot = await doc.get();
    
    return snapshot.docs.first;
}
Future createcustomer() async{
  final db = FirebaseFirestore.instance.collection('Customers').doc(user!.uid);
  final json = {
    'service':false,
    'email':user!.email
  };
  await db.set(json);
}
}