import 'package:ding_web/Responsive_Widgets/LandingPage.dart';
import 'package:ding_web/Responsive_Widgets/LoggedNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeLoggein extends StatefulWidget {
  const HomeLoggein({super.key});

  @override
  State<HomeLoggein> createState() => _HomeLoggeinState();
}

class _HomeLoggeinState extends State<HomeLoggein> {
  @override
  Widget build(BuildContext context) {
     final user =  FirebaseAuth.instance.currentUser;
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
            LoggedNavBar(),
           user?.displayName==null ? LandingPage(
            text: 'Welcome',
           ): LandingPage(text: 'Welcome back ${user!.displayName!.toUpperCase()}',)
          ],),
        ),
      ) ,);
  }
}
