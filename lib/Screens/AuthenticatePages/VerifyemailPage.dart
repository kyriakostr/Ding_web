import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/ChooseMode_temp.dart';
import 'package:ding_web/Screens/HomePages/Home.dart';
import 'package:ding_web/Screens/ChooseMode.dart';
import 'package:ding_web/Screens/TablesPage.dart';
import 'package:ding_web/Utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class VerifyemailPage extends StatefulWidget {
  const VerifyemailPage({ Key? key }) : super(key: key);

  @override
  State<VerifyemailPage> createState() => _VerifyemailPageState();
}

class _VerifyemailPageState extends State<VerifyemailPage> {
  // final user = FirebaseAuth.instance.currentUser;
  bool isEmailVerified = false;

  Timer? timer;
  int count = 0;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendemailverification();
      timer = Timer.periodic(Duration(seconds: 3), (timer) { 
        checkemailverified();
        count = count + 1;
        if(count>20){
          FirebaseAuth.instance.currentUser!.delete();
        }
      });
    }
    
  }

  
  
  Future checkemailverified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      
    });
    if(isEmailVerified) timer?.cancel();
  }

  Future sendemailverification() async{
      try{
        final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      }on FirebaseAuthException catch(e){
        Utils().showSnackBar(e.toString());
      }
    } 

    @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;

    return isEmailVerified ?   ChooseTemp() 
    : Scaffold(
      appBar: AppBar(title: Text('Verify email')),
      body: Column(
        children: [
          Text('If you didn\t receive your email.Check in your spams'),
          Center(child: FloatingActionButton(onPressed: () {
            FirebaseAuth.instance.signOut();
            FirebaseAuth.instance.currentUser!.delete();
          } ,),),
        ],
      ),
    );
  }

 
}