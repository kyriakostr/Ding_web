import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/PhoneTextwidget.dart';
import 'package:ding_web/Textwidget.dart';
import 'package:ding_web/models/SerciveAccount.dart';
import 'package:ding_web/models/Tabledata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class Bottomsheet extends StatefulWidget {
  bool change;
  String? email;
  String? password;
  String? firstname;
  Bottomsheet({super.key,required this.change,this.email,this.password,this.firstname});

  @override
  State<Bottomsheet> createState() => _BottomsheetState();
}

class _BottomsheetState extends State<Bottomsheet> {
  TextEditingController firstnamecontroller = TextEditingController();

  TextEditingController lastnamecontroller = TextEditingController();

  TextEditingController passcontroller = TextEditingController();

  TextEditingController emailcontroller = TextEditingController();

  TextEditingController dutycontroller = TextEditingController();

  TextEditingController phonenumbercontroller = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  
  final _formkey = GlobalKey<FormState>();
  bool value = false;
  bool check = false;
  bool text = false;
  List<Tabledata> data = [];
  List<Tabledata> selecteddata = [];
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    data = Provider.of<List<Tabledata>>(context);
     Size size = MediaQuery.of(context).size;
    return widget.change ? Container(
      height: size.height*0.65,
      child: widget_update(size),
    ) : Container(
      height: size.height*0.65,
      child: widget_add(size),);
  }

  Widget widget_add(Size size)=>SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(children: [
            Text( 'Add a new member'),
            SizedBox(height: 10,),
            Textwidget(controller: firstnamecontroller, hinttext: 'Enter first name', labeltext: 'First Name', icon: Icon(Icons.person),color: Colors.black,),
            SizedBox(height: 10,),
            Textwidget(controller: lastnamecontroller, hinttext: 'Enter last name', labeltext: 'Last Name', icon: Icon(Icons.person),color: Colors.black,),
            SizedBox(height: 10,),
            Textwidget(controller: emailcontroller, hinttext: 'Enter email', labeltext: 'Email', icon: Icon(Icons.email),color: Colors.black,),
            SizedBox(height: 10,),
            Textwidget(controller: passcontroller, hinttext: 'Enter password', labeltext: 'Password', icon: Icon(Icons.password),color: Colors.black,),
            SizedBox(height: 10,),
            Textwidget(controller: dutycontroller, hinttext: 'Enter the role of your staff', labeltext: 'Role of staff', icon: Icon(Icons.person),color: Colors.black,),
            SizedBox(height: 10,),
            PhoneTextwidget(controller: phonenumbercontroller, hinttext: 'Enter  phone number', labeltext: 'Phone number', icon: Icon(Icons.person),color: Colors.black,),
            SizedBox(height: 10,),
            ElevatedButton.icon(onPressed: () {
              if(_formkey.currentState!.validate())
              DatabaseManager(displayName: user!.displayName).set(firstnamecontroller.text.trim(), 
              lastnamecontroller.text.trim(),emailcontroller.text.trim(), 
              passcontroller.text.trim(),dutycontroller.text.trim(),
              int.parse(phonenumbercontroller.text.trim()));}, 
            icon:widget.change? Icon(Icons.update):Icon(Icons.add), label: widget.change ? Text('Update'):Text('Add') )
            ]),
        ),
      );

  Widget widget_update(Size size){
    
    return Form(
    key: _formkey,
    child: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( 'Change the service accounts data of '),
            Text(widget.firstname!,style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
        SizedBox(height: 10,),
       check==false ? IconButton(onPressed: () => setState(() {
          check = true;
        }) , icon: Icon(Icons.add_box)) : IconButton(onPressed:() =>  setState(() {
          check = false;
        }), icon: Icon(Icons.arrow_circle_up)),
        check ? Column(
          children: [
            Text('Set new password'),
            SizedBox(height:5,),
            Textwidget(controller: passcontroller, hinttext: 'Enter password', labeltext: 'Password', icon: Icon(Icons.password),color: Colors.black,),

          ],
        ):Container(),
        SizedBox(height: 10,),
        Text('Select tables'),
        SizedBox(height: 10,),
        Container(
          
          height: 100,
          width: 100,
          child: GridView.builder(
            // physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5), 
            itemBuilder: (context, index) {
              final current_data = data[index];
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              color: selecteddata.contains(current_data) ? Colors.blue:Colors.transparent,),
              
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => setState(() {
                    selecteddata.contains(current_data)?
                    selecteddata.remove(current_data):
                    selecteddata.add(current_data);
                    
                  }),
                  child: Center(child: Text(current_data.number.toString()))),
              ),
            );
          },),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Empty tables'),
            Checkbox(value: value, onChanged: (value) => setState(() {
              this.value=value!;
            }),)
          ],
        ),
        ElevatedButton.icon(onPressed: () { 
        if(_formkey.currentState!.validate() && selecteddata.length>=1 || value){
           DatabaseManager(displayName: user!.displayName ).update(widget.email!,check?passcontroller.text.trim():widget.password!,selecteddata);
          if(selecteddata.length>=1|| value) Navigator.pop(context);
        }else{
          setState(() {
            text=true;
          });
        }
       }, 
        icon:widget.change? Icon(Icons.update):Icon(Icons.add), label: widget.change ? Text('Update'):Text('Add') ),
        if(text)Text('Please select a table',style: TextStyle(color: Colors.red),)
        ]),
    ),
  );}
}
