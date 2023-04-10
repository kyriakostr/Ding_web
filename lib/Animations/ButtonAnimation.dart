import 'package:flutter/material.dart';
import 'dart:async';

class ButtonAnimation extends StatefulWidget {
  final Widget? child;
 
  final int? delayanimation;

  const ButtonAnimation({ Key? key,this.delayanimation,this.child}) : super(key: key);

  @override
  State<ButtonAnimation> createState() => _ButtonAnimationState();
}

class _ButtonAnimationState extends State<ButtonAnimation> with TickerProviderStateMixin {

  AnimationController? controller;
  Animation<Offset>? animation;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(vsync: this,duration: Duration(milliseconds: 1000 ));
    
    if(widget.delayanimation==null){
      controller!.forward();
    }else{
      Timer(Duration(milliseconds: widget.delayanimation!), (){
        controller!.forward();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(curve: Interval(0.0, 0.9,curve: Curves.elasticOut),parent: controller!,),
      child: widget.child,
      
    );
  }
}