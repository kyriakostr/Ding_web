import 'package:flutter/material.dart';

class PhoneTextwidget extends StatefulWidget {
  final Icon icon;
  TextEditingController controller;
  String hinttext;
  String labeltext;
  Color color;
  PhoneTextwidget({super.key,required this.controller,required this.hinttext,required this.labeltext,required this.icon
  ,required this.color});

  @override
  State<PhoneTextwidget> createState() => _PhoneTextwidgetState();
}

class _PhoneTextwidgetState extends State<PhoneTextwidget> {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TextFormField(
      enableIMEPersonalizedLearning: true,
      enableSuggestions: true,
      controller: widget.controller,
      style: TextStyle(color: widget.color),
      validator: (value){
          if(value!.isEmpty || value.length<10||value.length>10 || !value.contains(RegExp(r'[0-9]'))){
            return 'Enter a correct ${widget.labeltext}';
          }
        },
      decoration: InputDecoration(
      
       hintText: widget.hinttext,
      labelText: widget.labeltext,
      labelStyle: TextStyle(color: widget.color),
      hintStyle: TextStyle(color: widget.color),
      prefixIcon: widget.icon,
       
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2),
      borderSide: BorderSide(color: widget.color) ),
      border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
      ),
      focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: widget.color)),
      errorBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: widget.color),
                  borderRadius: BorderRadius.circular(30),
                ),
      focusedErrorBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: widget.color),
                  borderRadius: BorderRadius.circular(30),
                ),
      errorStyle: TextStyle(color: widget.color),
      constraints: BoxConstraints(maxWidth: size.width*0.3)),
      );
  }
}