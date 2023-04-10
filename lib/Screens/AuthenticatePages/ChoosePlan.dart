import 'dart:async';

import 'package:ding_web/Animations/DelayedAnimation.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Host.dart';
import 'package:ding_web/models/Product_Plans.dart';
import 'package:ding_web/stripe_checkout_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class ChoosePlan extends StatefulWidget {
  const ChoosePlan({super.key});

  @override
  State<ChoosePlan> createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  bool? check;
  final user = FirebaseAuth.instance.currentUser;
   bool p = false;
   @override
  void initState() {
    // TODO: implement initState
    exists();
    super.initState();
  }
  Future exists() async{
    check = await DatabaseManager(uid: user!.uid,displayName: user!.displayName).read();
    if(check!=null){
     if(mounted) setState(() {
        p=true;
      });
      Timer(Duration(seconds: 2), () => context.pop() ,);
    }
    
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return p ? Center(child: CircularProgressIndicator(),) : Scaffold(
      
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter,end: Alignment.topCenter,
        colors: [Color.fromARGB(255, 46, 114, 214),Color.fromARGB(255, 55, 132, 248)])),
        child: DelayedAnimation(
          delayedanimation: 200,
          aniduration: 700,
          anioffsetx: 0,
          anioffsety: 0.35,
          child: Column(
            children: [
              Text('Choose your plan',style: TextStyle(color: Colors.white,fontSize: size.height*0.05,fontFamily: 'SecularOne'),),
              SizedBox(height: size.height*0.1,),
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                 
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: size.height*0.55,
                  crossAxisSpacing: size.width*0.04), 
                  
                  itemBuilder: (context, index) {
                    final item = products[index];
                    final itemtext = text(index);
                    final itemprice = price(index);
                    return Container(
                     
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(size.width*0.1),topLeft:Radius.circular(size.width*0.05),topRight: Radius.circular(size.width*0.05) ),
                      
                      gradient: LinearGradient(begin: Alignment.bottomCenter,end: Alignment.topCenter,
                        colors: [Color.fromARGB(255, 34, 144, 235),Color.fromARGB(255, 255, 255, 255)])),
                      child: Column(
                        children: [
                          Text(itemprice,style: TextStyle(color: Colors.blue,fontSize: size.height*0.05,fontFamily: 'Montserrat',fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                          SizedBox(height: size.height*0.1,),
                          Text(itemtext,style: TextStyle(color: Colors.blue,fontSize: size.height*0.03,fontFamily: 'SecularOne',),textAlign: TextAlign.center,),
                          SizedBox(height: size.height*0.2,),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Color.fromARGB(255, 8, 143, 184),
                              elevation: 10,
                              primary: Color.fromARGB(255, 43, 157, 192),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                              )
                            
                            ),
                            onPressed: () {
                            redirectToCheckout(context, url, item);
                                              context.pop();
                          }, icon: Icon(Icons.subscriptions_sharp), label: Text('Choose Plan'))
                        ],
                      ),
                    );
                  },),
              ),
            ],
          ),
        ),
      )
    );
  }
}

String price(int index){
  String producttext = '';
  switch(index){
    case 0:
      producttext='10 Euros';
      break;
    case 1:
      producttext='30 Euros';
      break;
    case 2:
      producttext='60 Euros';
      break;
    case 3:
      producttext='100 Euros';
      break;
  }
 return producttext;
}
String text(int index){
  String producttext = '';
  switch(index){
    case 0:
      producttext='Apply for a monthly subscription';
      break;
    case 1:
      producttext='Apply for a three months subscription';
      break;
    case 2:
      producttext='Apply for a six months subscription';
      break;
    case 3:
      producttext='Apply for a year subscription';
      break;
  }
 return producttext;
}