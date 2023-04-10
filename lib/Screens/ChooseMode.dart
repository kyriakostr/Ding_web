
// import 'dart:io';
// import 'dart:ui';
// import 'package:ding_web/Animations/ButtonAnimation.dart';
// import 'package:ding_web/Utils.dart';
// import 'package:ding_web/models/Categories.dart';
// import 'package:ding_web/models/Menuitem.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image_downloader_web/image_downloader_web.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:ui' as ui;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ding_web/Screens/AuthenticatePages/BusinessPage.dart';
// import 'package:ding_web/Screens/CustomerPage.dart';
// import 'package:ding_web/Textwidget.dart';
// import 'package:ding_web/models/Customer.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class ChooseMode extends StatefulWidget {
//   const ChooseMode({super.key});

//   @override
//   State<ChooseMode> createState() => _ChooseModeState();
// }

// class _ChooseModeState extends State<ChooseMode> {
//   bool button = false;
//   bool business = false;
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController tablecontroller = TextEditingController();
//   TextEditingController controller = TextEditingController();
//   String? temp;
//   String error='You have not completed all the steps';
//   Map<Categories,List<Menuitem>> map = {};
//   List<TextEditingController> categorycontrollers = [];
//   Map<Categories,List<TextEditingController>> menuitemscontrollers = {};
//   List<String> list=['cafeteria','restaurant','bar','club'];


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
 
//     read();
//     readbusiness();
//   }
//   final user = FirebaseAuth.instance.currentUser;

//  int currentStep = 0;
  
//   List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
//   @override
//   Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
//    final userProvider = Provider.of<User?>(context);
//    final futurefiles = FirebaseStorage.instance.ref().child('${user!.displayName}/').listAll();
   
  
//     return Scaffold(
//       backgroundColor: Colors.amber,
//       body: FutureBuilder(
//               future: readbusiness(),
//               builder: (context, snapshot) {
                
//                 if(snapshot.hasData){
//                   return BusinessPage();
//                 }else if(snapshot.connectionState==ConnectionState.waiting){
//                   return Center(child: CircularProgressIndicator(),);
//                 }
                
//                 else {

//             return StreamBuilder<Customer>(
//               stream: read(),
//               builder: (context, snapshot) {
//                 if(snapshot.hasData){
//                   return CustomerPage();
                
//                 }else{
//                   return button ? Stepper(
//                     type: StepperType.horizontal,
//                     currentStep: currentStep,
//                     onStepContinue: () {
                     
                     
//                      if(formKeys[currentStep].currentState!.validate()){
                        
//                         if(currentStep==2 ){
//                         if(formKeys[0].currentState!.validate()&&temp!=null){

//                             setState(() {
//                             createbusiness();
//                             createQrcodes();
//                             setcategory();
                            
//                           });
//                         }else{
//                           return null;
//                         }
                        

//                       }
//                       else{
//                         setState(() {
//                         currentStep=currentStep+1;
//                       });

//                       }
//                      }
                     
                      
                      
//                     },
//                     onStepCancel:currentStep==0 ? null : () {
//                       setState(() {
//                         currentStep=currentStep-1;
//                       });
//                     },
//                     onStepTapped: (step)=>setState(() {
//                       currentStep=step;
//                     }),
//                     steps: [
//                       Step(
//                       state: currentStep>0 ? StepState.complete:StepState.indexed,
//                       isActive: currentStep>=0,
//                       title: Text('Account'),
//                        content: Form(
//                         key: formKeys[0],
//                          child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             TextFormField(controller: namecontroller,validator: (value) {
//                               if(value!.isEmpty || value.contains(RegExp(r'(\d+)'))){
//                                 return 'Enter a name';
//                               }
//                             },),
//                             SizedBox(height: size.height*0.1,),
//                             TextFormField(controller: tablecontroller,
//                             validator: (value) {
//                               if(value!.isEmpty || !value.contains(RegExp(r'(\d+)'))){
//                                 return 'Enter number of tables';
//                               }
//                             })
                              
//                           ],),
//                        ),
//                      ),
//                      Step(
//                       state: currentStep>1 ? StepState.complete:StepState.indexed,
//                       isActive: currentStep>=1,
//                       title: Text('Menu'),
//                       content: Form(
//                         key: formKeys[1],
//                         child: Column(
//                           children: [
//                             DropdownButtonFormField(
//                               value: temp,
//                               items: list.map((category) => DropdownMenuItem(
//                                 value: category,
//                                 child: Text(category))).toList(), 
//                               onChanged: (value) {
                                
//                                   temp=value!;
                              
//                               },)
//                           ],
//                         ),
//                       ),),
                  
//                   Step(
//                     state: ( currentStep>2 ) ? StepState.complete: StepState.indexed,
//                     isActive: currentStep>=2,
//                     title: Text('Complete'), 
//                     content: Form(
//                       key: formKeys[2],
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                         Text(namecontroller.text.trim()),
//                         SizedBox(height: size.height*0.1,),
//                         Text(tablecontroller.text.trim()),
//                         SizedBox(height: size.height*0.1,),
//                         Text(controll()?error:'You are ready to go')
//                       ],),
//                     ))

//                     ]
                     
//                   ) 
             
//              : 
//              Column(children: [
//               FloatingActionButton(
//                 heroTag: 'button',
//                 child: Text('Business'),
//                 onPressed: (){
//                   setState(() {
//                     button = true;
//                   });
//               }),
//               SizedBox(height: size.height*0.1,),
//               FloatingActionButton(
//                 heroTag: 'button2',
//                 child: Text('Customer'),
//                 onPressed: (){
//                   createcustomer();
//               })
//             ],);

//                 }
//               },);
            

//           }
          
//         } ,
        
//       ) ,
//     );
    
  
//   }

  

//   bool controll(){
//     if(namecontroller.text.isEmpty||tablecontroller.text.isEmpty||temp==null
//       ||namecontroller.text.contains(RegExp(r'(\d+)'))|| !tablecontroller.text.contains(RegExp(r'(\d+)'))){
//                   return true;
//                   }else{
//                     return false;
//                   }
//   }
//   Future setcategory() async{
//     final dbcategory = FirebaseFirestore.instance.collection('Categories').doc('categories');
//     final snapshot = await dbcategory.get();
//     dbcategory.update({temp!:FieldValue.arrayUnion([namecontroller.text.trim()])});
//   }

  
//     Future download(Reference ref) async{
//     final url =await ref.getDownloadURL();
//     final WebImageDownloader _webImageDownloader = WebImageDownloader();
//     await _webImageDownloader.downloadImageFromWeb(url);
//     Utils().showSnackBar('Download files');
//   }

//   Future<Uint8List> toQrImageData(String text) async {
//   try {
//     final image = await QrPainter(
//       data: text,
//       version: QrVersions.auto,
//       gapless: false,
//       color: Colors.black,
//       emptyColor: Colors.white,
//     ).toImage(300);
//     final a = await image.toByteData(format: ImageByteFormat.png);
//     return  a!.buffer.asUint8List();
   

//   } catch (e) {
//     throw e;
//   }
// }
// Future setMenu() async{
//   final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!).collection('Menus').doc(user!.uid);
//   final snapshot = await db.get();
//   final data = snapshot.data() ;

//   if(snapshot.exists){
//     map.forEach((key, value) {
//       Map json = {};
//       value.forEach((element) {
//           json.addAll({element.name:element.price});
//         });
//       db.update({key.name!:json});
//     });
//   }else{
//     map.forEach((key, value) {
//       Map json = {};
//       value.forEach((element) {
//           json.addAll({element.name:element.price});
//         });
//       db.set({key.name!:json});
//     });
//   }
    
  
// }
// Future signOut() async{
//    await FirebaseAuth.instance.signOut();

// }

  
//   Stream<Customer> read(){
//   final db = FirebaseFirestore.instance.collection('Customers').doc(user!.uid).snapshots();
  
//   return db.map((doc) => Customer.fromJson(doc.data()!));
// }
// Future createcustomer() async{
//   final db = FirebaseFirestore.instance.collection('Customers').doc(user!.uid);
//   final json = {
//     'active':'yes',
//     'email':user!.email
//   };
//   await db.set(json);
// }
// Future createbusiness() async{
//     final db = FirebaseFirestore.instance.collection('Business').doc(namecontroller.text.trim().toLowerCase());
//     setState(() {
//       FirebaseAuth.instance.currentUser!.updateDisplayName(namecontroller.text.trim());
//     });
//   final json={
//     'email':user!.email,
//     'Number of Tables': int.parse(tablecontroller.text.trim())
//   };
//   await db.set(json);
// }
// Future createQrcodes() async{
  
//   for(int i=1;i<=int.parse(tablecontroller.text.trim());i++){
//     final path = '${namecontroller.text.trim()}/${i}';
//   final ref = FirebaseStorage.instance.ref().child(path);

//   final file = await toQrImageData(namecontroller.text.trim().toLowerCase()+' '+'${i}');

//   ref.putData(file,SettableMetadata(contentType: 'image/png'));

//   }
  
  


// }
// Future<DocumentSnapshot<Map<String, dynamic>>> readbusiness() async{
//     final doc = FirebaseFirestore.instance.collection('Business').where('email',isEqualTo: user?.email,isNull: false);
//     final snapshot = await doc.get();
    
//     return snapshot.docs.first;
// }





   
// }




  




