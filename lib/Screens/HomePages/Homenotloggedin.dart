import 'package:ding_web/Responsive_Widgets/LandingPage.dart';
import 'package:ding_web/Responsive_Widgets/NotLoggedNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Homenotloggedin extends StatefulWidget {
  const Homenotloggedin({super.key});

  @override
  State<Homenotloggedin> createState() => _Homenotloggedin();
}

class _Homenotloggedin extends State<Homenotloggedin> {
  @override
  Widget build(BuildContext context) {
    //  final user = Provider.of<User?>(context);
        Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          
          gradient: LinearGradient(
            colors: [Colors.pink,Colors.pink.shade800],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight)
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            NotLoggedNavBar(),
            LandingPage(text: 'Order with ease!',),
           
            
          ],),
        ),
      ) ,);
  }
}