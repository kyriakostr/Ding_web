import 'package:ding_web/Shared/Hovertext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoggedNavBar extends StatelessWidget {
  LoggedNavBar({super.key});
  

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth>1200){
          return DesktopNavBar();
        }else if(constraints.maxWidth>800 && constraints.maxWidth<1200){
          return DesktopNavBar();
        }else{
          return MobileNavBar();
        }
      },
    );
  }
}

class DesktopNavBar extends StatelessWidget {
   DesktopNavBar({super.key});
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

  List<Widget> returnlist(bool ishovered,){
    List<Widget> list = [
                  
                  GestureDetector(onTap: () => GoRouter.of(context).go('/Authentication'),child: 
                  user?.displayName!=null?
                  Text(user!.displayName!.toUpperCase(),style: TextStyle(
                    color:ishovered? Colors.amber[200]: Colors.white ,fontFamily: 'Montserrat'),):Text('Profile',style: TextStyle(
                    color:ishovered? Colors.amber[200]: Colors.white ,fontFamily: 'Montserrat'))),
                  // SizedBox(width: size.width*0.06,),
                  if(user?.displayName!=null)
                  GestureDetector(
                  onTap: () => context.goNamed('Dashboard'),
                  child: Text('Go to Dashboard',style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,
                  fontFamily:'Montserrat' ),)),
                  // SizedBox(width: size.width*0.06,),
                  GestureDetector(onTap: () => GoRouter.of(context).go('/Info'),child: Text('About us',style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,fontFamily: 'Montserrat'),)),
                  // SizedBox(width: size.width*0.06,),
                  GestureDetector(onTap: () => signOut(),child: Text('Logout',
                  style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,fontFamily: 'Montserrat',),)),
  ];
  return list;
  }
   
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: size.height*0.05,horizontal: size.width*0.02),
      child: Container(
        constraints: BoxConstraints(maxWidth: 1366),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Text('Ding',style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: size.width*0.05,
              fontFamily: 'Montserrat'
            ),),
            Image.asset('assets/Ding_app.png',width: size.width*0.1,height: size.height*0.15,color: Colors.white,),
            ],),
            Container(
              height: size.height*0.1,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: returnlist(false).length,
                separatorBuilder: (context, index) => Divider(indent: size.width*0.03,),
                itemBuilder: (context, index) {
                 
                  return OnHoveText(builder: (ishovered) => returnlist(ishovered)[index],);
                },),
            )

            // Row(
            //   children: [
                
            //     GestureDetector(onTap: () => GoRouter.of(context).go('/Authentication'),child: Text(user!.displayName!.toUpperCase(),
            //     style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),)),
            //     SizedBox(width: size.width*0.06,),
            //     GestureDetector(
            //     onTap: () => context.goNamed('Dashboard'),
            //     child: Text('Go to Dashboard',style: TextStyle(color: Colors.white,
            //     fontFamily:'Montserrat' ),)),
            //     SizedBox(width: size.width*0.06,),
            //     GestureDetector(onTap: () => GoRouter.of(context).go('/Info'),child: Text('About us',
            //     style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),)),
            //     SizedBox(width: size.width*0.06,),
            //     GestureDetector(onTap: () => signOut(),child: Text('Logout',
            //     style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),)),
                
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

class MobileNavBar extends StatelessWidget {
   MobileNavBar({super.key});
final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> returnlist(bool ishovered,){
    List<Widget> list = [
                  if(user?.displayName!=null)
                  GestureDetector(onTap: () => GoRouter.of(context).go('/Authentication'),child: Text(user!.displayName!.toUpperCase(),style: TextStyle(
                    color:ishovered? Colors.amber[200]: Colors.white ,fontFamily: 'Montserrat'),)),
                  // SizedBox(width: size.width*0.06,),
                  if(user?.displayName!=null)
                  GestureDetector(
                  onTap: () => context.goNamed('Dashboard'),
                  child: Text('Go to Dashboard',style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,
                  fontFamily:'Montserrat' ),)),
                  // SizedBox(width: size.width*0.06,),
                  GestureDetector(onTap: () => GoRouter.of(context).go('/Info'),child: Text('About us',style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,fontFamily: 'Montserrat'),)),
                  // SizedBox(width: size.width*0.06,),
                  GestureDetector(onTap: () => signOut(),child: Text('Logout',
                  style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,fontFamily: 'Montserrat',),)),
  ];
  return list;
  }
    return Container(
      child: Column(children: [
         Text('Ding',style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30
            ),),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: 
              Container(
              height: size.height*0.1,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: returnlist(false).length,
                separatorBuilder: (context, index) => Divider(indent: size.width*0.03,),
                itemBuilder: (context, index) {
                 
                  return OnHoveText(builder: (ishovered) => returnlist(ishovered)[index],);
                },),
            )
              
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     GestureDetector(onTap: () => GoRouter.of(context).go('/Authentication'),child: Text(user!.displayName!.toUpperCase(),style: TextStyle(color: Colors.white,fontFamily: 'Montserrat'),)),
              //     SizedBox(width: size.width*0.06,),
              //     GestureDetector(
              //     onTap: () => context.goNamed('Dashboard'),
              //     child: Text('Go to Dashboard',style: TextStyle(color: Colors.white,
              //     fontFamily:'Montserrat' ),)),
              //     SizedBox(width: size.width*0.06,),
              //     GestureDetector(onTap: () => GoRouter.of(context).go('/Info'),child: Text('About us',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat'),)),
              //     SizedBox(width: size.width*0.06,),
              //     GestureDetector(onTap: () => signOut(),child: Text('Logout',
              //   style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),)),
              //   ],
              // ),
            )
      ]),
    );
  }
}
Future signOut() async{
  
   await FirebaseAuth.instance.signOut();
  await GoogleSignIn().disconnect();
   await FacebookAuth.instance.logOut();
   

}