import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthSideScreen extends StatelessWidget {
  const AuthSideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: size.width*0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset('assets/Restaurant-Management.png',height: size.height*0.4,width: size.width*0.5,)),
          SizedBox(height: size.height*0.2,),
          Center(child: Text('Manage and boost your own business and orders with these simple steps.',textAlign: TextAlign.center,style: TextStyle(fontSize:size.width*0.01,fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,decoration: TextDecoration.underline,color: Colors.white))),
          Center(child: Text('Sign up with your email or with other credentials',style: TextStyle(fontSize:size.width*0.01,fontFamily: 'Montserrat',color: Colors.white ),)),

          Center(child: Text('Enter your business data(e.g. name,category etc.)',style: TextStyle(fontSize:size.width*0.01,fontFamily: 'Montserrat',color: Colors.white ))),

          Center(child: Text('Build your menu.',style: TextStyle(fontSize:size.width*0.01,fontFamily: 'Montserrat',color: Colors.white ))),
          
          Center(child: Text('Manage the orders of every table.',style: TextStyle(fontSize:size.width*0.01,fontFamily: 'Montserrat',color: Colors.white)))
        ],
      ),
    );
  }
}