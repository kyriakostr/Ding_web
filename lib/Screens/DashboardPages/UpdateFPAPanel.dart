import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateFPA extends StatefulWidget {
  String? name;
   UpdateFPA({super.key,this.name});

  @override
  State<UpdateFPA> createState() => _UpdateFPAState();
}

class _UpdateFPAState extends State<UpdateFPA> {
   TextEditingController fpacontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text('Update ΦΠΑ'),
      content: Container(
        height: size.height*0.3,
        child: SingleChildScrollView(
          child: Column(children: [
           
            Textwidget(controller: fpacontroller, hinttext: 'Update ΦΠΑ', labeltext: 'ΦΠΑ', icon: Icon(Icons.table_bar), color: Colors.black),
            SizedBox(height: size.height*0.05,),
            ElevatedButton.icon(onPressed: () {
              
               DatabaseManager(displayName: widget.name).setFPA(double.parse(fpacontroller.text.trim()));

              
                Navigator.pop(context);
                 
              
              
            }, icon: Icon(Icons.update), label: Text('Update'))
          ]),
        ),),
      actions: [
        OutlinedButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text('Close'))
      ],
    );
  }
}