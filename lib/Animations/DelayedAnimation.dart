import 'dart:async';

import 'package:flutter/material.dart';

class DelayedAnimation extends StatefulWidget {

  final Widget? child;
  final int? delayedanimation;
  final double? anioffsetx;
  final double? anioffsety;
  final int? aniduration;


   const DelayedAnimation({ 
     Key? key, 
     this.child,
     this.delayedanimation,
     this.anioffsetx,
     this.anioffsety,
     this.aniduration}) : super(key: key);

  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation> with TickerProviderStateMixin {

AnimationController? controller;
Animation<Offset>? animationoffset;

@override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(vsync: this,duration: Duration(milliseconds: widget.aniduration! ));

    final curve = CurvedAnimation(parent: controller!, curve: Curves.decelerate);
    animationoffset = Tween<Offset>(begin: Offset(widget.anioffsetx!,widget.anioffsety!),end:Offset.zero ).animate(curve);

    if(widget.delayedanimation==null){
      controller!.forward();
    }else{
      Timer(Duration(microseconds:widget.delayedanimation! ),(){
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
    return FadeTransition(
      child: SlideTransition(position: animationoffset!,child: widget.child,),
      opacity: controller!,
    );
  }
}