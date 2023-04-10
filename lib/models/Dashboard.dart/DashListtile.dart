import 'package:ding_web/models/Dashboard.dart/Dahsitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DashListtile extends StatelessWidget {
  final Dashitem dashitem;
  final int index;
  ValueChanged<Dashitem>? onselected;
  ValueChanged<int>? tappedindex;
  DashListtile({super.key,required this.dashitem,this.onselected,this.tappedindex,required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      onTap:() { 
        tappedindex!(index);
        onselected!(dashitem);},
      leading: Icon(dashitem.icon,size: size.width*0.02,color: Colors.white,),
      title: Text(dashitem.title!,style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontSize: size.width*0.015 )),
      
    );
  }
}