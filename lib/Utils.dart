import 'package:flutter/material.dart';

class Utils{
  static final messengerkey = GlobalKey<ScaffoldMessengerState>();
   showSnackBar(String? text){
    if(text==null) return;
    final snackbar = SnackBar(content: Text(text,style: TextStyle(color: Colors.pink,fontSize: 20),),backgroundColor: Colors.white,);

     messengerkey.currentState!..removeCurrentSnackBar()..showSnackBar(snackbar);
  }
}