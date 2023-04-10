import 'dart:async';

import 'package:ding_web/Screens/DashboardPages/Documents.dart';
import 'package:ding_web/Screens/DashboardPages/EditMenu.dart';
import 'package:ding_web/Screens/DashboardPages/ServiceSettings.dart';
import 'package:ding_web/Screens/DashboardPages/Settings.dart';
import 'package:ding_web/Screens/DashboardPages/Statistics.dart';
import 'package:ding_web/Screens/DashboardPages/Upgrademenu.dart';
import 'package:ding_web/Shared/Hovertext.dart';
import 'package:ding_web/models/Dashboard.dart/DahsItems.dart';
import 'package:ding_web/models/Dashboard.dart/Dahsitem.dart';
import 'package:ding_web/models/Dashboard.dart/DashListtile.dart';
import 'package:ding_web/models/Dashboard.dart/MenuController.dart';
import 'package:ding_web/models/Responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {

  Dashboard({super.key,});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int tappedIndex;
  Dashitem item = Dashitems().dashitems.first;
  StreamSubscription? subscription;
 String name='';
  @override
  void initState() {
    // TODO: implement initState
    
    tappedIndex=0;
    
  subscription =FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user != null) {
    setState(() {
      this.name = user.displayName!;
    });
      
  
   
  } else {
    this.name = "Unknown";
  }
  });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    subscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> returnlist(bool ishovered,){
    List<Widget> list = [
                  GestureDetector(
                  onTap: () => {
                    GoRouter.of(context).go('/Authentication')
                  },
                  child: Text(name.toUpperCase() ,style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,
                  fontFamily:'Montserrat' ),),
              ),
                  GestureDetector(
                  onTap: () => {
                    GoRouter.of(context).go('/')
                  },
                  child: Text('Home' ,style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,
                  fontFamily:'Montserrat' ),),
              ),
                  
                  
                  GestureDetector(
                  onTap: () => GoRouter.of(context).go('/Info'),
                  child: Text('Info',style: TextStyle(color:ishovered? Colors.amber[200]: Colors.white,
                  fontFamily:'Montserrat' ),)),
                
                  GestureDetector(
                  onTap: () { 
                    context.pop();
                    signOut();
                    },
                  child: Text('Logout',style: TextStyle(color:ishovered? Colors.amber[200]: Colors.white,
                  fontFamily:'Montserrat' ),)),
  ];
  return list;
  }
    return Scaffold(
     key: context.read<MenuController>().scaffoldkey,
     drawer: Drawer(
      backgroundColor: Colors.blue.shade800,
       child: Column(
         children: [
           Flexible(child: DrawerHeader(child: Image.asset('assets/Ding_app.png',width: size.width*0.1,
           color: Colors.white,))),
       
           Flexible(
           child: ListView.builder(
             
             shrinkWrap: true,
             itemCount: Dashitems().dashitems.length,
             itemBuilder: (context, index) {
               final current_item = Dashitems().dashitems[index];
               return Container(
                 decoration: BoxDecoration(borderRadius:BorderRadius.circular(30),color: tappedIndex==index?Colors.orange[800]:Colors.transparent,),  
                 child: DashListtile(dashitem: current_item,index: index,onselected: (item){
                   setState(() {
                     this.item=item;
                   });
                 },tappedindex: (value) {
                   setState(() {
                     this.tappedIndex = value;
                   });
                 },),
               );
             },)
         )
         ],
       ),
     ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(
          colors: [Colors.blue.shade800,Colors.blue.shade500],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(Responsive.isDesktop(context))
            Expanded(child: 
            Column(
              children: [
                Flexible(child: DrawerHeader(child: Image.asset('assets/Ding_app.png',width: size.width*0.1,
                color: Colors.white,))),
            
                Flexible(
                child: ListView.builder(
                  
                  shrinkWrap: true,
                  itemCount: Dashitems().dashitems.length,
                  itemBuilder: (context, index) {
                    final current_item = Dashitems().dashitems[index];
                    return Container(
                      decoration: BoxDecoration(borderRadius:BorderRadius.circular(30),color: tappedIndex==index?Colors.orange[800]:Colors.transparent,),  
                      child: DashListtile(dashitem: current_item,index: index,onselected: (item){
                        setState(() {
                          this.item=item;
                        });
                      },tappedindex: (value) {
                        setState(() {
                          this.tappedIndex = value;
                        });
                      },),
                    );
                  },)
              )
              ],
            )),
            
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  
                  children: [
                  if(Responsive.isMobile(context)||Responsive.isTablet(context)) Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(onPressed: context.read<MenuController>().controlMenu, icon: Icon(Icons.menu,color: Colors.white,)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.05,horizontal: size.width*0.02),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    Container(
                    height: size.height*0.05,
                    child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: returnlist(false).length,
                  separatorBuilder: (context, index) => Divider(indent: size.width*0.03,),
                  itemBuilder: (context, index) {
                   
                    return OnHoveText(builder: (ishovered) => returnlist(ishovered)[index],);
                  },),
                          )
                //     GestureDetector(
                //     onTap: () => {
                //       GoRouter.of(context).go('/Authentication')
                //     },
                //     child: Text(name.toUpperCase() ,style: TextStyle(color: Colors.white,
                //     fontFamily:'Montserrat' ),),
                // ),
                //     SizedBox(width: size.width*0.05,),
                //     GestureDetector(
                //     onTap: () => {
                //       GoRouter.of(context).go('/')
                //     },
                //     child: Text('Home' ,style: TextStyle(color: Colors.white,
                //     fontFamily:'Montserrat' ),),
                // ),
                //     SizedBox(width: size.width*0.05,),
                    
                //     GestureDetector(
                //     onTap: () => GoRouter.of(context).go('/Info'),
                //     child: Text('Info',style: TextStyle(color: Colors.white,
                //     fontFamily:'Montserrat' ),)),
                //     SizedBox(width: size.width*0.05,),
                //     GestureDetector(
                //     onTap: () { 
                //       context.pop();
                //       signOut();
                //       },
                //     child: Text('Logout',style: TextStyle(color: Colors.white,
                //     fontFamily:'Montserrat' ),)),
                        ],
                      ),
                  ),
                    selectitem(item),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget selectitem(Dashitem item){
    switch(item){
      // case Dashitems.Data_analysis:
      //   return Text('Data analysis');
      case Dashitems.UpgradeMenu:
        return UpgradeMenu();
      case Dashitems.Documents:
        return Documents();
      case Dashitems.Service:
        return ServiceSettings();
      case Dashitems.Settings:
        return Settings();
      case Dashitems.EditMenu:
        return Padding(
          padding:  EdgeInsets.only(left:8.0),
          child: EditMenu(),
        );
      case Dashitems.Statistics:
        return Statistics();
      default:
       return Text('data');
    }
  }
}
Future signOut() async{
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().disconnect();
   await FacebookAuth.instance.logOut();
   
   

}