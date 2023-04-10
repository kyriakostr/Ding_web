import 'package:ding_web/Shared/Hovertext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class AboutusPage extends StatelessWidget {
  const AboutusPage({super.key});

  @override
  Widget build(BuildContext context) {

    String text = 'We give the opportunity to dining businesses such as restaurants,cafeterias,bars to go one step further using technology.'
    'We are a small team with the goal to make your business faster and more efficient.'
                  'We let you take the full control of your business.Our system consists of web app for'
                  ' the business owners and an application(Android,IOS) for the customers and the service of your business.\n'
                  'Customers scan a specific QR code from their table and are able to go through your menu inside our app and choose and order from the table without waiting '
                  'the waiter.Reduce order turnovers to avoid situations like this.';
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
              Image.asset('assets/qEH.gif',height: size.height*0.6,),
              Padding(padding: EdgeInsets.symmetric(horizontal:size.width*0.1),
              child: Text('The staff of your business will also check the table orders with the mobile app.Customers will be able to pay with cash,card or '
                  'through application.'
                ,style: TextStyle(fontFamily: 'Montserrat',fontSize:20,color: Colors.white),),)
            ],
          ),
        ),
      ),
    );
  }
}