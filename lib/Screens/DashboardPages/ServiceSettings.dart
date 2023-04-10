import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/DashboardPages/Bottomsheet.dart';
import 'package:ding_web/Screens/DashboardPages/ListofServiceAccounts.dart';
import 'package:ding_web/models/SerciveAccount.dart';
import 'package:ding_web/models/Tabledata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ServiceSettings extends StatelessWidget {
  const ServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    void showpannel(){
      showModalBottomSheet(
        isScrollControlled: true,
        context: context, builder: (context) => 
          StreamProvider<List<Tabledata>>.value(
            initialData: [],
            value: DatabaseManager(displayName: user!.displayName).tabledata,
            child: Bottomsheet(change: false,))
      );
      
    }
    return StreamProvider<List<ServiceAccount>?>.value(
      initialData: [],
      value: DatabaseManager(displayName:user!.displayName,uid:user.uid ).Servicedata,
      child: 
         SingleChildScrollView(
          child: Column(
            children: [
              Row(children: [
                ElevatedButton.icon(onPressed: () => showpannel() , icon: Icon(Icons.add), label: Text('Add Service'))
              ],),
              ListofService(),
            ],
          ),
        )
      
    );
  }
}