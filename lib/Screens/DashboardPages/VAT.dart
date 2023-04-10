import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/DashboardPages/EditVAT.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class VAT extends StatelessWidget {
  String? category;
  User? user;
  VAT({super.key,this.category,this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseManager(category: category,uid: user?.uid,displayName: user?.displayName).VAT,
      builder: (context, snapshot) {
        if(snapshot.hasData){
         
          return Row(
            children: [
              Text('VAT:'+snapshot.data.toString()),
              IconButton(
                onPressed: () => showModalBottomSheet(
                  context: context, 
                  builder: (context) => EditVAT(category: category,),),
                 icon: Icon(Icons.edit))
            ],
          );
        }else{
          return Container();
        }
      },);
  }
}