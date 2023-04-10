import 'dart:typed_data';
import 'dart:ui';

import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Textwidget.dart';
import 'package:ding_web/Utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:universal_html/html.dart' as html;

class UpdatePanel extends StatefulWidget {
  
  String? name;
  bool check;
  int? tables;
  UpdatePanel({super.key,this.name,required this.check, this.tables,});

  @override
  State<UpdatePanel> createState() => _UpdatePanelState();
}

class _UpdatePanelState extends State<UpdatePanel> {
  late DatabaseReference ref;
  TextEditingController namecontroller = TextEditingController();
  
  TextEditingController number_of_tables = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    ref=FirebaseDatabase.instance.ref().child(widget.name!);
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.name);
    print(widget.tables);
    Size size = MediaQuery.of(context).size;
    final futurefiles = FirebaseStorage.instance.ref().child('${widget.name}/');
    return AlertDialog(
      title: Text('Update tables number'),
      content: Container(
        height: size.height*0.3,
        child: SingleChildScrollView(
          child: Column(children: [
           
            Textwidget(controller: number_of_tables, hinttext: 'Update number of tables', labeltext: 'Number of tables', icon: Icon(Icons.table_bar), color: Colors.black),
            SizedBox(height: size.height*0.05,),
            ElevatedButton.icon(onPressed: () {
              
               DatabaseManager(displayName: widget.name).settabledata(int.parse(number_of_tables.text.trim()));

                createQrcodes();
                resetRTDB();
               
                Utils().showSnackBar('Refresh the tables page and it will show the new number of tables');
                Navigator.pop(context);
                 
              
              
            }, icon: Icon(Icons.update), label: Text('Update'))
          ]),
        ),
      ),
      actions: [
        OutlinedButton(onPressed: () => Navigator.pop(context), child: Text('Close'))
      ],
    );
  }

  void resetRTDB() async{
    final newnum = int.parse(number_of_tables.text.trim());
    if(newnum>widget.tables!){
      for(int i=widget.tables!+1;i<=newnum;i++){
     await ref.child('${i}').update({"payment_state":"None","payment_method":"None",});
    }
    }else{
      for(int i=newnum+1;i<=widget.tables!;i++){
        await ref.child('${i}').remove();
      }
    }
    
  }

  Future<Uint8List> toQrImageData(String text) async {
  try {
    final image = await QrPainter(
      data: text,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    ).toImage(300);
    final a = await image.toByteData(format: ImageByteFormat.png);
    return  a!.buffer.asUint8List();
   

  } catch (e) {
    throw e;
  }
}

Future createQrcodes() async{
  final newnum = int.parse(number_of_tables.text.trim());
  if(newnum>widget.tables!){
    for(int i=widget.tables!+1;i<=newnum;i++){
    final path = '${widget.name!.trim()}/${i}';
    final ref = FirebaseStorage.instance.ref().child(path);

    final file = await toQrImageData(widget.name!.trim().toLowerCase()+' '+'${i}');

    ref.putData(file,SettableMetadata(contentType: 'image/png'));
  
  }
  }else{
    for(int i=newnum+1;i<=widget.tables!;i++){
      final path = '${widget.name!.trim()}/${i}';
      final ref = FirebaseStorage.instance.ref().child(path);
        await ref.delete();
      }
  }
  
  }
}