import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class OnHoveText extends StatefulWidget {
  final Widget Function(bool ishovered) builder;
  const OnHoveText({super.key,required this.builder});

  @override
  State<OnHoveText> createState() => _OnHoveTextState();
}

class _OnHoveTextState extends State<OnHoveText> {
  bool ishovered = false;
  @override
  Widget build(BuildContext context) {
    final hoveredtransform = Matrix4.identity()..translate(0,-8,0);
    final transform= ishovered ? hoveredtransform : Matrix4.identity();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter:(event) =>  onEnter(true),
      onExit: (event) => onEnter(false),
      child: AnimatedContainer(
        
        duration: Duration(milliseconds: 200),
        transform: transform,
        child: widget.builder(ishovered),),
    );
  }

  void onEnter(bool ishovered){
    setState(() {
      this.ishovered=ishovered;
    });
  }
  
}