import 'package:ding_web/models/Statistics/Statitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatsListtile extends StatelessWidget {
  final Statitem statitem;
  final int index;
  ValueChanged<Statitem>? onselected;
  ValueChanged<int>? tappedindex;
  StatsListtile({super.key,required this.statitem,this.onselected,this.tappedindex,required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      onTap:() { 
        tappedindex!(index);
        onselected!(statitem);},
      
      title: Text(statitem.title!,style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontSize: size.width*0.015 )),
      
    );
  }
}