import 'package:ding_web/Screens/HomePages/Home.dart';
import 'package:ding_web/Screens/AuthenticatePages/AuthenticationPage.dart';
import 'package:ding_web/Screens/AuthenticatePages/VerifyemailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService extends StatefulWidget {
  const AuthenticationService({super.key});

  @override
  State<AuthenticationService> createState() => _AuthenticationServiceState();
}

class _AuthenticationServiceState extends State<AuthenticationService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream:FirebaseAuth.instance.authStateChanges() ,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return VerifyemailPage();
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue) ,);

          }
          else{
            return AuthenticationPage();
          }
        } ) ,


      
    );
  }
}