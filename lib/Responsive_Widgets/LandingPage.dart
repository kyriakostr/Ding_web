

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class LandingPage extends StatelessWidget {
  String? text;
  
  LandingPage({super.key,this.text,});

  List<Widget> pagechildren(double width,double height,BuildContext context){
    return <Widget>[
      Container(
        padding: EdgeInsets.only(left: width*0.02),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.white,fontFamily:'Montserrat' ),),
            SizedBox(height: height*0.07,),
            Text('Take full control of your business or order fast and easy if you are a customer',
            style: TextStyle(fontSize:16,color: Colors.white,fontFamily:'Montserrat'),),
            SizedBox(height: height*0.04,),
            SizedBox(
              height: height*0.06,
              width: 150,
              child: ElevatedButton(onPressed: () => context.goNamed('Authentication'),child: 
              Text('Start now',style: TextStyle(color: Color.fromARGB(255, 192, 7, 75),
              fontFamily: 'SecularOne',fontSize: 15),),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.white12,
                elevation: 10,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              
                    ),),
            )
          ],
        ),
      ),
      Lottie.asset('assets/make-your-order.json',width: width,height: height*0.75 ),
      
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth>800){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ ...pagechildren(constraints.biggest.width/2,size.height,context)] );
        }else{
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pagechildren(constraints.biggest.width,size.height,context) );
        }
        
      },
    );
  }
}