import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class InfoTiles extends StatefulWidget {
  double height;
  BuildContext context;
  String text;
  String redirect;
  InfoTiles({super.key,required this.height,required this.context,required this.text,required this.redirect});

  @override
  State<InfoTiles> createState() => _InfoTilesState();
}

class _InfoTilesState extends State<InfoTiles> {
  bool ishovered = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
        children: [
          Text(widget.text,style: TextStyle(fontFamily: 'Montserrat',fontSize:size.height*0.019 )),
          SizedBox(height:widget.height*0.03,),
          MouseRegion(cursor: SystemMouseCursors.click,
          onEnter: (event) => setState(() {
            ishovered = true;
          }),
          onExit: (event) => setState(() {
            this.ishovered=false;
          }),
          child: GestureDetector(
            onTap: () => context.goNamed(widget.redirect),
            child: Row(
            children: [
              Text('Read more',style: TextStyle(fontSize: size.height*0.02,
                fontFamily: 'Montserrat',decoration: ishovered? TextDecoration.underline :null),),
              Icon(Icons.arrow_forward)
            ],
          ),))
        ],
      );
  }
}