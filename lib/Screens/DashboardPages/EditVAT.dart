import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditVAT extends StatefulWidget {
  String? category;
  EditVAT({super.key,this.category});

  @override
  State<EditVAT> createState() => _EditVATState();
}

class _EditVATState extends State<EditVAT> {
  String vat='';
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
              height: size.height*0.4,
              child: Column(children: [
                Container(
                   height: 50,
                   width: 100,
                  child: TextFormField(
                    onChanged: (value) => setState(() {
              vat=value;
            }),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2),
                    borderSide: BorderSide(color: Colors.black) ),
                    border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                    ),
                    focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                color: Colors.black)),
                    errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30),
                              ),
                    focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30),
                              ),
                    errorStyle: TextStyle(color: Colors.black,fontSize: size.width*0.01),
            ),
           
                  ),
                ),
                SizedBox(height: 10,),
        ElevatedButton(onPressed: () async{
            await  FirebaseFirestore.instance.collection('Business').doc(user?.displayName).
                              collection('Menus').doc(user?.uid).update({'${widget.category}.VAT':
                              double.parse(vat)});
                              Navigator.pop(context);
        }, child: Text('Change VAT'))
              ]),
            ),
    );
  }
}