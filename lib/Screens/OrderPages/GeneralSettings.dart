import 'package:ding_web/Shared/Hovertext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> returnlist(bool ishovered,){
    List<Widget> list = [
        GestureDetector(
          onTap: () => {
            GoRouter.of(context).go('/')
          },
          child: Text( 'Home' ,style: TextStyle(color:ishovered? Colors.amber[200]: Colors.white,
          fontFamily:'Montserrat' ),),
        ),
         
          GestureDetector(
           onTap: () => context.goNamed('Dashboard'),
          child: Text('Go to Dashboard',style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,
          fontFamily:'Montserrat' ),)),
         
          GestureDetector(
           onTap: () => GoRouter.of(context).go('/Info'),
          child: Text('Info',style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,
          fontFamily:'Montserrat' ),)),
          
          GestureDetector(
           onTap: () => signOut(),
          child: Text('Logout',style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,
          fontFamily:'Montserrat' ),)),
  ];
  return list;
  }
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: size.height*0.05,horizontal: size.width*0.02),
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
        ],
      ),
    );
  }
}
Future signOut() async{
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().disconnect();
  await FacebookAuth.instance.logOut();

}