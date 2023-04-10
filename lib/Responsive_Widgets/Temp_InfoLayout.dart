import 'package:ding_web/Shared/InfoTiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class Temp_InfoLayout extends StatefulWidget {
  const Temp_InfoLayout({super.key});

  @override
  State<Temp_InfoLayout> createState() => _Temp_InfoLayoutState();
}

final text = [
      'What we do',
      'Customers',
      'Businesses',
      'Our Packages'
    ];

class _Temp_InfoLayoutState extends State<Temp_InfoLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth>1200){
          return DesktopInfo();
        }else if(constraints.maxWidth>800 && constraints.maxWidth<1200){
          return DesktopInfo();
        }else{
          return DesktopInfo();
        }
      },
    );
  }
}

class DesktopInfo extends StatelessWidget {
  const DesktopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.only(bottom:size.height*0.1),
      child: GridView.builder(
        shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
          mainAxisSpacing: size.height*0.08,
          crossAxisSpacing: size.width*0.03,
          mainAxisExtent: size.height*.4
        ),
          itemCount: text.length,
          itemBuilder: (context, index){
            return Card(
              elevation: 6,
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.only(left: size.width*0.01,top: size.height*0.01),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chooseicon(index),
                      SizedBox(height: size.height*0.03,),
                      Text(text[index],style: TextStyle(fontSize: size.height*0.019,fontWeight: FontWeight.w600),),
                      SizedBox(height: size.height*0.03,),
                      choosetext(index,size.height,context)
                    ],
                  ),
                )),
            );
          }
      ),
    );
  }
}

Widget chooseicon(int index){
  switch(index){
    case 0:
      return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pink),
      child: Icon(Icons.question_mark,color: Colors.white,));
    case 1:
      return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pink),
      child: Icon(Icons.people,color: Colors.white,)); 
    case 2:
      return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pink),
      child: Icon(Icons.business_center,color: Colors.white,)); 
    case 3:
      return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pink),
      child: Icon(Icons.attach_money_sharp,color: Colors.white,));
    default:
      return Icon(Icons.abc);
  }
}
Widget choosetext(int index,double height,BuildContext context){
  switch(index){
    case 0:
      return InfoTiles(height: height, context: context, 
      text: 'We give the opportunity to dining businesses such as restaurants,cafeterias,'
      'bars to go one step further using technology',redirect: 'Aboutus',);
    case 1:
      return InfoTiles(height: height, context: context, 
      text: 'Customers can now order without waiting for a waiter/ress.Ordering gets easier with Ding app.', 
      redirect: 'CustomerInfo');
    case 2:
      return InfoTiles(height: height, context: context, 
      text: 'Businesses can now make their own menu  and manage the orders with the web app',
       redirect: 'BusinessInfo');
    default:
      return Column(
        children: [
          Text('Check  out our packages and choose the best for your business'),
          SizedBox(height:height*0.03,),
          MouseRegion(cursor: SystemMouseCursors.click,child: GestureDetector(child: Row(
            children: [
              Text('Read more',style: TextStyle(fontFamily: 'Montserrat'),),
              Icon(Icons.arrow_forward)
            ],
          ),))
        ],
      );
  }
}