import 'dart:async';
import 'dart:html';

import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool check=false;
  final user = FirebaseAuth.instance.currentUser;
@override
  void initState() {
    // TODO: implement initState
    var url = window.location.href;
    print(url);
    WidgetsBinding.instance.addPostFrameCallback((_) {
       Timer(Duration(seconds: 3),() {context.goNamed('BusinessData');
       },);
    exists();
    },);
   
    super.initState();
  }
 Future exists() async{
    check = await DatabaseManager(uid: user!.uid,displayName: user!.displayName).read();
    if(check!=null){
      
      context.goNamed('Authentication');
    }
    }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}