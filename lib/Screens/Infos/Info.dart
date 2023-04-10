import 'dart:async';

import 'package:ding_web/Responsive_Widgets/InfoLayout.dart';
import 'package:ding_web/Responsive_Widgets/Temp_InfoLayout.dart';
import 'package:ding_web/Shared/Hovertext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  
  @override
  Widget build(BuildContext context) {
    final user =  FirebaseAuth.instance.currentUser;
    Size size = MediaQuery.of(context).size;
    
    
    List<Widget> returnlist(bool ishovered,User? user){
    List<Widget> list = [
      GestureDetector(
        onTap: () => {
          GoRouter.of(context).go('/')
        },
        child: Text( 'Home' ,style: TextStyle(color: ishovered? Colors.amber[200]: Colors.pink,
        fontFamily:'Montserrat' ),),
      ),
      GestureDetector(
        onTap: () => {
          GoRouter.of(context).go('/Authentication')
        },
        child: Text(user==null ? 'Sign up/Sign in':user.displayName==null? '' : user.displayName!.toUpperCase(),style: TextStyle(color:ishovered? Colors.amber[200]: Colors.pink,
        fontFamily:'Montserrat' ),),
      ),
      if(user!=null) GestureDetector(
        onTap: () => {
          signOut()
        },
        child: Text('Logout',style: TextStyle(color:ishovered? Colors.amber[200]: Colors.pink,
        fontFamily:'Montserrat' ),),
      ),
                  
  ];
  return list;
  }
  
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          
          return Scaffold(
        
        body: Container(
          height: size.height,
          color: Colors.white,
          // decoration: BoxDecoration(gradient: LinearGradient(
          //   colors: [Colors.pink,Colors.pink.shade800],
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight)),
          child: SingleChildScrollView(
            child: Column(
              
              children: [
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.04),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
          
                      Container(
                  height: size.height*0.04,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: returnlist(false,snapshot.data).length,
                    separatorBuilder: (context, index) => Divider(indent: size.width*0.03,),
                    itemBuilder: (context, index) {
                     
                      return OnHoveText(builder: (ishovered) => returnlist(ishovered,snapshot.data)[index],);
                    },),
              ),
             
                      // GestureDetector(
                      //   onTap: () => {
                      //     GoRouter.of(context).go('/')
                      //   },
                      //   child: Text( 'Home' ,style: TextStyle(color: Colors.black,
                      //   fontSize: size.height*0.02,fontWeight:FontWeight.bold,
                      //   fontFamily:'AlfaSlabOne' ),),
                      // ),
                      // SizedBox(width: size.width*0.05,),
                      // GestureDetector(
                      //   onTap: () => {
                      //     GoRouter.of(context).go('/Authentication')
                      //   },
                      //   child: Text('Sign up/Sign in',style: TextStyle(color: Colors.black,
                      //   fontSize: size.height*0.02,fontWeight:FontWeight.bold,
                      //   fontFamily:'AlfaSlabOne' ),),
                      // ),
                      
                    ],),
                ),
                
               Divider(),
                Row(
                  children: [
                    Expanded(child: Container(
                      height: size.height,
                      width: size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Welcome to Ding',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),
                            Text('Make your your business faster and minimize order turnovers.\nBoost and maximize '
                            'your business profit.',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w100),),
                            Image.network('https://cdni.iconscout.com/illustration/premium/thumb/online-food-delivery-app-5515023-4609250.png')
                          ],
                        ),
                      ),
                    )),
                    Expanded(child: Temp_InfoLayout()),
                  ],
                )
                
              ],
            ),
          ),
        ),
      );
        }else if(snapshot.connectionState==ConnectionState.waiting){
          Center(child: CircularProgressIndicator(),);
        }
        else{
        
          return Scaffold(
        
        body: Container(
          height: size.height,
          color: Colors.white,
          // decoration: BoxDecoration(gradient: LinearGradient(
          //   colors: [Colors.pink,Colors.pink.shade800],
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight)),
          child: SingleChildScrollView(
            child: Column(
              
              children: [
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.04),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
          
                      Container(
                  height: size.height*0.04,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: returnlist(false,snapshot.data).length,
                    separatorBuilder: (context, index) => Divider(indent: size.width*0.03,),
                    itemBuilder: (context, index) {
                     
                      return OnHoveText(builder: (ishovered) => returnlist(ishovered,snapshot.data)[index],);
                    },),
              ),
             
                      // GestureDetector(
                      //   onTap: () => {
                      //     GoRouter.of(context).go('/')
                      //   },
                      //   child: Text( 'Home' ,style: TextStyle(color: Colors.black,
                      //   fontSize: size.height*0.02,fontWeight:FontWeight.bold,
                      //   fontFamily:'AlfaSlabOne' ),),
                      // ),
                      // SizedBox(width: size.width*0.05,),
                      // GestureDetector(
                      //   onTap: () => {
                      //     GoRouter.of(context).go('/Authentication')
                      //   },
                      //   child: Text('Sign up/Sign in',style: TextStyle(color: Colors.black,
                      //   fontSize: size.height*0.02,fontWeight:FontWeight.bold,
                      //   fontFamily:'AlfaSlabOne' ),),
                      // ),
                      
                    ],),
                ),
                
               Divider(),
                Row(
                  children: [
                    Expanded(child: Container(
                      height: size.height,
                      width: size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Welcome to Ding',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),
                            Text('Make your your business faster and minimize order turnovers.\nBoost and maximize '
                            'your business profit.',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w100),),
                            Image.network('https://cdni.iconscout.com/illustration/premium/thumb/online-food-delivery-app-5515023-4609250.png')
                          ],
                        ),
                      ),
                    )),
                    Expanded(child: Temp_InfoLayout()),
                  ],
                )
                
              ],
            ),
          ),
        ),
      );
        }
        return Container();
      }, 
    );
  }
}
Future signOut() async{
   await FirebaseAuth.instance.signOut();

}