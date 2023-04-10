import 'package:ding_web/Animations/ButtonAnimation.dart';
import 'package:ding_web/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Animations/DelayedAnimation.dart';
import '../../Textwidget.dart';

class Signup extends StatefulWidget {
  final Function? toggle;
  Signup({super.key,this.toggle});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Form(
          key: _formkey,
          child: Column(children: [
                
                DelayedAnimation(aniduration: 700,
                  anioffsetx: 0,
                  anioffsety: 0.35,
                  delayedanimation: 70,
                  child:Text('Sign up',style: TextStyle(color: Color.fromARGB(255, 221, 31, 110),fontSize: 20),),),
                SizedBox(height: size.height*0.04,),
                DelayedAnimation(aniduration: 700,
                  anioffsetx: 0,
                  anioffsety: 0.35,
                  delayedanimation: 100,
                  child:Textwidget(controller: emailcontroller,hinttext: 'User@email.com',labeltext: 'Email',
                  icon: Icon(Icons.email_rounded,color: Color.fromARGB(255, 221, 31, 110)),color: Color.fromARGB(255, 221, 31, 110),)),
                  SizedBox(height: size.height*0.07,),
                DelayedAnimation(aniduration: 700,
                  anioffsetx: 0,
                  anioffsety: 0.35,
                  delayedanimation: 200,
                  child:Textwidget(controller: passcontroller,hinttext: '123456',labeltext: 'Password',
                  icon: Icon(Icons.vpn_key,color: Color.fromARGB(255, 221, 31, 110),),color: Color.fromARGB(255, 221, 31, 110),)),
                  SizedBox(height: size.height*0.07,),
                DelayedAnimation(aniduration: 700,
                  anioffsetx: 0,
                  anioffsety: 0.35,
                  delayedanimation: 250,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Already have an acoount?',style: TextStyle(color: Colors.pink[200]),),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => widget.toggle!(),
                        child: Text('Sign in here.',style: TextStyle(color: Color.fromARGB(255, 192, 7, 75))),),
                    )],
                  )),
                SizedBox(height: size.height*0.07,),
                ButtonAnimation(
                    delayanimation: 700,
                    child: SizedBox(
                          height: size.height*0.06,
                          width: size.width*0.2,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.email,size: size.width*0.03,color: Colors.pink,),
                            label: Text('Sign up',style: TextStyle(fontSize: size.width*0.02,fontWeight: FontWeight.bold,color: Colors.pink),),
                            onPressed: (){
                              
                              if(_formkey.currentState!.validate()){
                                  signup(emailcontroller, passcontroller);
                                  
                              }
                              
                            },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Color.fromARGB(255, 221, 31, 110),
                            elevation: 10,
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                            )
                          
                          ), 
                          
                        ),
                      ),
                        ),
                  
                
            
              ],),
        
      );
    
  }
}
Future signup(TextEditingController email,TextEditingController password) async{
  try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());
    // await FirebaseAuth.instance.currentUser!.updateDisplayName('testUser');
  }on FirebaseAuthException catch(e){
    print(e);
    Utils().showSnackBar(e.message);
  }

}