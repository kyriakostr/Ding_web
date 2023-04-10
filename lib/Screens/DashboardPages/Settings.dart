import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/DashboardPages/UpdateFPAPanel.dart';
import 'package:ding_web/Screens/DashboardPages/UpdatePanel.dart';
import 'package:ding_web/models/Business.dart';
import 'package:ding_web/models/SerciveAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';


class Settings extends StatefulWidget  {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>  {
  bool check = false;
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(check==true)setState(() {
      
    });
    final user = FirebaseAuth.instance.currentUser;
    void showpannel(String name,int tables){
      showDialog(context: context, builder: (context) => 
           UpdatePanel(name: name,check:check,tables: tables,)
      );
    }
     void showfpapannel(String name,){
      showDialog(context: context, builder: (context) => 
           UpdateFPA(name: name,)
      );
    }
    return StreamBuilder<Business?>(
    
      stream: DatabaseManager(displayName: user!.displayName).Businessdata,
      builder: (context, snapshot) {
          final data = snapshot.data;
          
        if(snapshot.hasData){
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Row(
                  children: [
                    Text('Business Name:  '+user.displayName!,style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontSize: size.width*0.015 ),),
                    
                  ],
                ),
                
                SizedBox(height: size.height*0.1,),
                Text('Business email: '+data!.email!,style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontSize: size.width*0.015 )),
                SizedBox(height: size.height*0.1,),
                Row(
                  children: [
                    Text('Number of tables: '+data.number_of_tables.toString(),style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontSize: size.width*0.015 )),
                    IconButton(onPressed: () => showpannel(user.displayName!,data.number_of_tables!), icon: Icon(Icons.edit,color: Colors.white,))
                  ],
                ),
                SizedBox(height: size.height*0.1,),
                // Row(
                //   children: [
                //     Text('Business ΦΠΑ: '+data.fpa!.toStringAsFixed(2),style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontSize: size.width*0.015 )),
                //     IconButton(onPressed: () => showfpapannel(user.displayName!), icon: Icon(Icons.edit,color: Colors.white,))
                //   ],
                // ),
              ]
                
            ),
          );
        }else if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          return Container();
        }
       
         
        
        
       
      },);
  }
}