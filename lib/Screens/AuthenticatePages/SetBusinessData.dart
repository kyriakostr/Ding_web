import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/AuthenticatePages/BusinessPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SetBusinessData extends StatefulWidget {
  const SetBusinessData({super.key});

  @override
  State<SetBusinessData> createState() => _SetBusinessDataState();
}

class _SetBusinessDataState extends State<SetBusinessData> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController tablecontroller = TextEditingController();
  TextEditingController fpacontroller= TextEditingController();
  List<String> list=['cafeteria','restaurant','bar','club'];
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
  int currentStep = 0;
  String? temp;
  final user = FirebaseAuth.instance.currentUser;
  String error='You have not completed all the steps';
  bool? check;
  bool p = false;
  @override
  void initState() {
    // TODO: implement initState
    exists();
    super.initState();
  }
Future exists() async{
    check = await DatabaseManager(uid: user!.uid,displayName: user!.displayName).read();
    if(check!=null){
      setState(() {
        p=true;
      });
      Timer(Duration(seconds: 1), () => context.pop() ,);
    }
    
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
   
   
   
    return p ? Center(child: CircularProgressIndicator(),) :  Scaffold(
      body: 
                
                
                   Stepper(
                      type: StepperType.horizontal,
                      currentStep: currentStep,
                      onStepContinue: () {
                       
                       
                       if(formKeys[currentStep].currentState!.validate()){
                          
                          if(currentStep==2 ){
                          if(formKeys[0].currentState!.validate()&&temp!=null){
                              
                             
                              createbusiness();
                              createQrcodes();
                              setcategory();
                              
                              context.goNamed('Success');
                             
                            
                              
                              
                         
                          }else{
                            return null;
                          }
                          
    
                        }
                        else{
                          setState(() {
                          currentStep=currentStep+1;
                        });
    
                        }
                       }
                       
                        
                        
                      },
                      onStepCancel:currentStep==0 ? null : () {
                        setState(() {
                          currentStep=currentStep-1;
                        });
                      },
                      onStepTapped: (step)=>setState(() {
                        currentStep=step;
                      }),
                      steps: [
                        Step(
                        state: currentStep>0 ? StepState.complete:StepState.indexed,
                        isActive: currentStep>=0,
                        title: Text('Account'),
                         content: Form(
                          key: formKeys[0],
                           child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(controller: namecontroller,validator: (value) {
                                if(value!.isEmpty || value.contains(RegExp(r'(\d+)'))){
                                  return 'Enter a name';
                                }
                              },),
                              SizedBox(height: size.height*0.1,),
                              TextFormField(controller: tablecontroller,
                              validator: (value) {
                                if(value!.isEmpty || !value.contains(RegExp(r'(\d+)'))){
                                  return 'Enter number of tables';
                                }
                              }),
                              
                             
                                
                            ],),
                         ),
                       ),
                       Step(
                        state: currentStep>1 ? StepState.complete:StepState.indexed,
                        isActive: currentStep>=1,
                        title: Text('Category'),
                        content: Form(
                          key: formKeys[1],
                          child: Column(
                            children: [
                              DropdownButtonFormField(
                                value: temp,
                                items: list.map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category))).toList(), 
                                onChanged: (value) {
                                  
                                    temp=value!;
                                
                                },)
                            ],
                          ),
                        ),),
                    
                    Step(
                      state: ( currentStep>2 ) ? StepState.complete: StepState.indexed,
                      isActive: currentStep>=2,
                      title: Text('Complete'), 
                      content: Form(
                        key: formKeys[2],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(namecontroller.text.trim()),
                          SizedBox(height: size.height*0.1,),
                          Text(tablecontroller.text.trim()),
                          SizedBox(height: size.height*0.1,),
                          Text(controll()?error:'You are ready to go')
                        ],),
                      ))
    
                      ]
                       
                    )
                
       
      
      
      
      
      
    ) 
             ;
  }
   Future<DocumentSnapshot<Map<String, dynamic>>> readbusiness() async{
    final doc = FirebaseFirestore.instance.collection('Business').where('email',isEqualTo: user?.email,isNull: false);
    final snapshot = await doc.get();
    
    return snapshot.docs.first;
}
  bool controll(){
    if(namecontroller.text.isEmpty||tablecontroller.text.isEmpty||temp==null
      ||namecontroller.text.contains(RegExp(r'(\d+)'))|| !tablecontroller.text.contains(RegExp(r'(\d+)'))){
                  return true;
                  }else{
                    return false;
                  }
  }
  Future setcategory() async{
    final dbcategory = FirebaseFirestore.instance.collection('Categories').doc('categories');
    final snapshot = await dbcategory.get();
    dbcategory.update({temp!:FieldValue.arrayUnion([namecontroller.text.trim()])});
  }

  Future createbusiness() async{
    final db = FirebaseFirestore.instance.collection('Business').doc(namecontroller.text.toLowerCase().trim());
    setState(() {
       user?.updateDisplayName(namecontroller.text.toLowerCase().trim());
       user?.reload();
    });
  final json={
    'email':user!.email,
    'Number of Tables': int.parse(tablecontroller.text.trim()),
    
  };
  await db.set(json);
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
  
  for(int i=1;i<=int.parse(tablecontroller.text.trim());i++){
    final path = '${namecontroller.text.toLowerCase().trim()}/${i}';
  final ref = FirebaseStorage.instance.ref().child(path);

  final file = await toQrImageData(namecontroller.text.trim().toLowerCase()+' '+'${i}');

  ref.putData(file,SettableMetadata(contentType: 'image/png'));

  }


}

}