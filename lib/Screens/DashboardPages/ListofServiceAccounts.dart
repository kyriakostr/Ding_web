import 'dart:math';

import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/DashboardPages/Bottomsheet.dart';
import 'package:ding_web/models/SerciveAccount.dart';
import 'package:ding_web/models/Tabledata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ListofService extends StatelessWidget {
  const ListofService({super.key});

  @override
  Widget build(BuildContext context) {
    final listofService = Provider.of<List<ServiceAccount>?>(context);
    final user = FirebaseAuth.instance.currentUser;   
 void showpannel(String email,String name,String password,String firstname){
      showModalBottomSheet(context: context, builder: (context) => 
          StreamProvider<List<Tabledata>>.value(
            initialData: [],
            value: DatabaseManager(displayName: user!.displayName).tabledata,
            child: Bottomsheet(change: true,email: email,password: password,firstname: firstname,))
      );
    }
    
    return Column(
      children:listofService!.isEmpty ? [Text('No Data')] :  listofService.map((e) => Card(
        child: ListTile(
        onTap: ()=>showpannel(e.email!,user!.displayName!,e.password!,e.firstname!) ,
        title: Text(e.firstname!+' '+e.lastname!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password: '+e.password.toString() ),
            Text('Staff role:'+e.duty.toString()),
            Text('Phone:'+e.phonenumber.toString()),
            Text('Email:'+e.email!)
          ],
        ) ,
        trailing: IconButton(icon: Icon(Icons.delete),onPressed:()=>DatabaseManager(displayName: user!.displayName).delete( e.email!),),),
        elevation: 2,
      )).toList(),
    );
  }
}