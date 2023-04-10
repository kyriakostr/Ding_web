import 'package:ding_web/Shared/Hovertext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class CustomerInfoPage extends StatelessWidget {
  const CustomerInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    String text = 'Customers can now order without waiting for a waiter/ress.Ordering gets easier with Ding app.'
    'Register in Ding app with email,Facebook or Google and get a full experience of table ordering.Scan the unique QR code'
    ' of the table and order from the menu that will show up.';
    String text_2 = 'See the overview of your order and choose the way you want to pay with cash,card or app\'s POS';
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
         
        height: size.height,
        decoration: BoxDecoration(gradient: LinearGradient(
        colors: [Colors.pink,Colors.pink.shade800],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight),),
        child: SingleChildScrollView(
          child: Column(
             
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                     children: [
                       MouseRegion(
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
                     ],
                   ),
                  Row(
                    
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OnHoveText(builder: (ishovered) => GestureDetector(child: Row(
                          children: [
                            Icon(Icons.arrow_back,color: ishovered?Colors.amber[200]:Colors.white,),
                            Text('Back to info',style: TextStyle(fontFamily: 'Montserrat',color:ishovered?Colors.amber[200]:Colors.white, ),),
                          ],
                        ),onTap: () => context.goNamed('Info'),),),
                      ),
                      ElevatedButton(onPressed: () => context.goNamed('Authentication'), child: Text('Sign up/Sign in',style: TextStyle(fontFamily: 'SecularOne',color: Color.fromARGB(255, 221, 31, 110)),),
                          style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.white12,
                                  elevation: 10,
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                  )
                                
                                ),),
                    ],
                  )
                  
                ],
              ),
              
              Divider(color: Colors.pink.shade600,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:size.width*0.1),
                child: Text(text
                ,style: TextStyle(fontFamily: 'Montserrat',fontSize:20,color: Colors.white ),),
              ),
               Padding(
                padding: EdgeInsets.symmetric(horizontal:size.width*0.1),
                child: Text(text_2
                ,style: TextStyle(fontFamily: 'Montserrat',fontSize:20,color: Colors.white ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}