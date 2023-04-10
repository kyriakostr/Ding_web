import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/Animations/ButtonAnimation.dart';
import 'package:ding_web/Animations/DelayedAnimation.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/AuthenticatePages/AuthSideScreen.dart';
import 'package:ding_web/Screens/AuthenticatePages/Signin.dart';
import 'package:ding_web/Screens/AuthenticatePages/Signup.dart';
import 'package:ding_web/Shared/Hovertext.dart';
import 'package:ding_web/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool signup = true;

  void toggle(){
    setState(() {
      signup = !signup;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    Size size = MediaQuery.of(context).size;
    List<Widget> returnlist(bool ishovered,){
    List<Widget> list = [
                   GestureDetector(
                      onTap: () => {
                        GoRouter.of(context).go('/')
                      },
                      child: Text(user==null ? 'Home' : '${user.email}',style: TextStyle(color: ishovered? Colors.pink: Colors.pink[200],fontFamily: 'Montserrat',),),
                    ),
                    
                    GestureDetector(
                      onTap: () => {
                        GoRouter.of(context).go('/Info')
                      },
                      child: Text('Info',style: TextStyle(color: ishovered? Color.fromARGB(255, 190, 15, 74): Colors.pink[200],fontFamily: 'Montserrat',),),
                    )
  ];
  return list;
  }

    return Scaffold(
      body: Container(
        height: size.height,
        
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  
                  height: size.height,
                  
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:  EdgeInsets.only(top: size.height*0.08),
                      child: Column(children: [
                           
                            signup ?
                            Signup(toggle: toggle,):
                            Signin(toggle: toggle,),
                            SizedBox(height: size.height*0.04,),
                            ButtonAnimation(
                              delayanimation: 1000,
                              child: SizedBox(
                                    height: size.height*0.06,
                                    width: size.width*0.2,
                                    child: ElevatedButton.icon(
                                      icon: Icon(Icons.facebook,size:size.width*0.02,),
                                      label: Text('Facebook',style: TextStyle(fontSize: size.width*0.02,fontWeight: FontWeight.bold),),
                                      onPressed: (){
                                        DatabaseManager().signinwithFacebook();
                                      },
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Color.fromARGB(255,66 ,103, 178),
                                      elevation: 10,
                                      primary: Color.fromARGB(255, 1, 132, 192),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50)
                                      )
                                    
                                    ), 
                                   
                                  ),
                                ),
                            ),
                            SizedBox(height: size.height*0.04,),
                            ButtonAnimation(
                            delayanimation: 1200,
                            child: SizedBox(
                                height: size.height*0.06,
                                width: size.width*0.2,
                                child: ElevatedButton.icon(
                                  icon: FaIcon(FontAwesomeIcons.google,size: size.width*0.02,),
                                  label: Text('Google',style: TextStyle(fontSize: size.width*0.02,fontWeight: FontWeight.bold),),
                                  onPressed: (){
                                    DatabaseManager().googlesignin();
                                  },
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Color.fromARGB(255, 219 ,68 ,55),
                                  elevation: 10,
                                  primary: Color.fromARGB(255, 219 ,68 ,55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                  )
                                
                                ), 
                               
                              ),
                            ),
                                ),
                              SizedBox(height: size.height*0.05,),
                              Text('Contact us:dingsupport@gmail.com',style: TextStyle(color: Color.fromARGB(255, 247, 52, 117),fontSize: size.width*0.015),)
                            ],),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: size.height,
                  decoration: BoxDecoration(gradient: LinearGradient(
                  colors: [Colors.pink,Colors.pink.shade800],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30))),
                  
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DelayedAnimation(
                          delayedanimation: 700,
                          anioffsetx: 0.35,
                          anioffsety: 0,
                          aniduration: 700,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => context.goNamed('Home'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                              Text('Ding',style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: size.width*0.03,
                              fontFamily: 'Montserrat'
                              ),),
                              Image.asset('assets/Ding_app.png',width: size.width*0.08,height: size.height*0.08,color: Colors.white,),
                              ],),
                            ),
                          ),
                        ),
                        // Padding(
                        //      padding:  EdgeInsets.symmetric(vertical: size.height*0.05,horizontal: size.width*0.1),
                        //      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //     height: size.height*0.07,
                        //     child: ListView.separated(
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: returnlist(false).length,
                        //     separatorBuilder: (context, index) => Divider(indent: size.width*0.05,),
                        //     itemBuilder: (context, index) {
                             
                        //       return OnHoveText(builder: (ishovered) => returnlist(ishovered)[index],);
                        //     },),
                        // )
                                
                        //       ],),
                        //    ),
                        SizedBox(height: size.height*0.1,),
                        AuthSideScreen()
                      ],
                    ),
                  ),
                ),
              )
              
            ],
          ),
        ),
      ),
    );
    
  }
}

