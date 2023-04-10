import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/Animations/ButtonAnimation.dart';
import 'package:ding_web/Animations/DelayedAnimation.dart';
import 'package:ding_web/Screens/HomePages/HomeLoggedin.dart';
import 'package:ding_web/Screens/HomePages/Homenotloggedin.dart';
import 'package:ding_web/Screens/AuthenticatePages/Signin.dart';
import 'package:ding_web/Screens/AuthenticatePages/Signup.dart';
import 'package:ding_web/Textwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  
  const Home({super.key,});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  

  @override
  Widget build(BuildContext context) {
   
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<User?>(

      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return HomeLoggein();
        }else if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }else{
          return Homenotloggedin();
        }
      },
    );
  }
}