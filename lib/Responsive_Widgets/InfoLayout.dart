import 'dart:js';

import 'package:ding_web/Animations/DelayedAnimation.dart';
import 'package:ding_web/Shared/Hovertext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class InfoLayout extends StatefulWidget {
  const InfoLayout({super.key});

  @override
  State<InfoLayout> createState() => _InfoLayoutState();
}
final text = [
      'About us',
      'Order fast and easy!',
      'Take the control of your business one step ahead',
      'Our Packages'
    ];
class _InfoLayoutState extends State<InfoLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth>1200){
          return DesktopInfo();
        }else if(constraints.maxWidth>800 && constraints.maxWidth<1200){
          return MobileInfo();
        }else{
          return MobileInfo();
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
      padding:  EdgeInsets.symmetric(horizontal: size.width*0.1),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,
        mainAxisSpacing: 100,
        crossAxisSpacing: 50,
       childAspectRatio: (2 / 1)),
        itemCount: text.length,
        itemBuilder: (context, index) {
          final item = text[index];
          
          return DelayedAnimation(
            delayedanimation: 100,
            aniduration: 700,
            anioffsetx: 0.35,
            anioffsety: 0,
            child: OnHoveText(
              builder:(ishovered) =>  GestureDetector(
                onTap: () {
                  chooseinfo(index, context);
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  child: Container(
                    
                    width: size.width*0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(item,style: TextStyle(fontFamily: 'SecularOne',fontSize: size.width*0.01,color: Colors.pink.shade900,fontWeight: FontWeight.w600),)
                    ],) ),
                ),
              ),
            ),
          );
        },),
    );
  }
}

class MobileInfo extends StatelessWidget {
  const MobileInfo({super.key});

  @override
  Widget build(BuildContext context) {
   Size size = MediaQuery.of(context).size;
    
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: size.width*0.1),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,
        crossAxisSpacing: 50,
        mainAxisSpacing: 100,
       childAspectRatio: (2 / 1)),
        itemCount: text.length,
        itemBuilder: (context, index) {
          final item = text[index];
      
          return DelayedAnimation(
            delayedanimation: 100,
            aniduration: 700,
            anioffsetx: 0,
            anioffsety: 0.35,
            child: OnHoveText(
              builder:(ishovered) =>  GestureDetector(
                onTap: () {
                  chooseinfo(index, context);
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  child: Container(
                    
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(item,style: TextStyle(fontFamily: 'SecularOne',fontSize: size.width*0.05,fontWeight: FontWeight.w600,color: Colors.pink.shade900),)
                    ],) ),
                ),
              ),
            ),
          );
        },),
    );
  }
}
DecorationImage getimage(int index){
  switch(index){
    case 0:
      return DecorationImage(image: AssetImage('business-team-cartoon-characters-vector.jpg'),fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.pink.withOpacity(0.3), BlendMode.darken)
      );
    case 1:
      return DecorationImage(image: AssetImage('food-delivery-app-mobile-phone-restaurant-order-online-hand-holding-smartphone.jpg',),
      fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.pink.withOpacity(0.3), BlendMode.darken));
    case 2:
      return DecorationImage(image: AssetImage('11018-scaled.jpg',),
      fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.pink.withOpacity(0.3), BlendMode.darken));
    case 3:
      return DecorationImage(image: AssetImage('hosting-package-price-list-campaign-free-vector.jpg',),
      fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.pink.withOpacity(0.3), BlendMode.darken));
    default:
      return DecorationImage(image: AssetImage('Order.jpg'),fit: BoxFit.cover);
  }
}

void chooseinfo(int index,BuildContext context){
  switch(index){
    case 0:
      context.goNamed('Aboutus');
      break;
    default:
      print('clicked');

  }
}
