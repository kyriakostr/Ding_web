import 'package:ding_web/Shared/Hovertext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> returnlist(bool ishovered,){
    List<Widget> list = [
      GestureDetector(
        onTap: () => {
          GoRouter.of(context).go('/')
        },
        child: Text( 'Home' ,style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,
        fontFamily:'Montserrat' ),),
      ),
      GestureDetector(onTap: () => GoRouter.of(context).go('/Info'),child: Text('About us',style: TextStyle(color: ishovered? Colors.amber[200]: Colors.white,fontFamily: 'Montserrat'),)),
      GestureDetector(
        onTap: () => {
          signOut()
        },
        child: Text('Logout',style: TextStyle(color:ishovered? Colors.amber[200]: Colors.white,
        fontFamily:'Montserrat' ),),
      ),
                  
  ];
  return list;
  }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:  Container(
        height: size.height,
          decoration: BoxDecoration(gradient: LinearGradient(
            colors: [Colors.pink,Colors.pink.shade800],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight)),
        child: Column(
          children: [
            Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height*0.05,horizontal: size.width*0.04),
                        child: Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                
                            Container(
                        height: size.height*0.1,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: returnlist(false,).length,
                          separatorBuilder: (context, index) => Divider(indent: size.width*0.03,),
                          itemBuilder: (context, index) {
                           
                            return OnHoveText(builder: (ishovered) => returnlist(ishovered,)[index],);
                          },),
                    ),])),
            Text('This email is being used for customer purposes.\nYou can experience customers\' services with the mobile app'),
            
          ],
        ),
      ));
  }
}
Future signOut() async{
  FirebaseAuth.instance.signOut();

}