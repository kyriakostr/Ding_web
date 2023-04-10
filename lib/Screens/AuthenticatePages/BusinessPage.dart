
// import 'dart:typed_data';
// import 'dart:ui';
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ding_web/Animations/ButtonAnimation.dart';
// import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
// import 'package:ding_web/Screens/OrderPages/Temp_2.dart';
// import 'package:ding_web/Screens/TablesPage.dart';
// import 'package:ding_web/Screens/OrderPages/Temp.dart';
// import 'package:ding_web/Shared/Hovertext.dart';
// import 'package:ding_web/Textwidget.dart';
// import 'package:ding_web/Utils.dart';
// import 'package:ding_web/models/Categories.dart';
// import 'package:ding_web/models/Menuitem.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_downloader_web/image_downloader_web.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:http/http.dart';

// class BusinessPage extends StatefulWidget {

   
//    BusinessPage({super.key});

//   @override
//   State<BusinessPage> createState() => _BusinessPageState();
// }

// class _BusinessPageState extends State<BusinessPage> {
//     final user = FirebaseAuth.instance.currentUser;
//     late DatabaseReference ref;
//     String temp = '';
//     int count = 0;
//     Map<Categories,List<Menuitem>> map = {};
//     List<TextEditingController> categorycontrollers = [];
//     Map<Categories,List<TextEditingController>> menuitemscontrollers = {};
//     bool? checking;
//     bool state=true;
//     StreamSubscription<DocumentSnapshot>? subscription;
   
//     @override
//   void initState() {
//     ref = FirebaseDatabase.instance.ref().child(user!.displayName!);
//     super.initState();
//     final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!).collection('Menus').doc(user!.uid);
//     print(map);
//    subscription = db.snapshots().listen((event) {
//       if(event.exists){
//         if(mounted){
//           setState(() {
          
//           checking=true;
//         });
//         }
//       }else{
//         if(mounted){
//           setState(() {
//           state = false;
//         });
//         }
        
//       }
//      });
    
//   }
  
//   @override
//   void dispose() {
//     subscription?.cancel();
//     super.dispose();
//   }
 
  
//   final _formkey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final futurefiles = FirebaseStorage.instance.ref().child('${user!.displayName}/').listAll();
    
//     return  (checking!=null) ? Temp() : 
//       (state==true) ? Center(child: CircularProgressIndicator()) :
//      Scaffold(
//       backgroundColor: Colors.amber,
//       body: Form(
//         key: _formkey,
//         child: Column(
//           children: [
//             Row(children: [
//               IconButton(onPressed: (){
//               futurefiles.then((value) => value.items.forEach((element) {download(element);}));
//             }, icon: Icon(Icons.download)),
            
//              IconButton(icon: Icon(Icons.logout,),onPressed:() =>  setState(() {
//               // list_categories.insert(0, Categories(name: 'dde'));
//               signOut();
//             }),),
            
//             ],),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   label: Text('Add a category',style: TextStyle(fontSize: size.width*0.01),),
//                   icon: Icon(Icons.add,size: size.width*0.015,),onPressed:() =>  setState(() {
//                   // list_categories.insert(0, Categories(name: 'dde'));
//                   count = count+1;
//                   map.addAll({Categories():[]});
//                   categorycontrollers.add(TextEditingController());
//                 }),),
//                 SizedBox(
                  
//                   width: 150,
//                   child: ElevatedButton.icon(
//                     icon: Icon(Icons.login,size: 15,),
//                     label: Text('Submit',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
//                     onPressed: (){
                      
//                       if(_formkey.currentState!.validate()){
                         
//                              setMenu();
//                              setdatabase();    
                          
//                       }
                      
//                     },
//                   style: ElevatedButton.styleFrom(
//                     shadowColor: Color.fromARGB(255, 209, 41, 29),
//                     elevation: 10,
//                     primary: Colors.red,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50)
//                     )
                  
//                   ), 
                  
//                 ),
//               ),
//               ],
//             ),
//             Divider(),
//             Flexible(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: map.keys.length,
//                 itemBuilder: (context, index) {
//                   final category_name = map.keys.elementAt(index).name;
//                   final category_key = map.keys.elementAt(index);
//                   return Column(
//                     children: [
//                       ListTile(title: TextFormField(
//                         style: TextStyle(fontSize: size.width*0.02),
//                         controller: categorycontrollers[index],
//                         decoration: InputDecoration(
//                         hintText:'Enter a menu category',
//                         labelText: 'Enter a menu category',
//                         labelStyle: TextStyle(color: Colors.white,fontSize: size.width*0.015),
//                         hintStyle: TextStyle(color: Colors.white,fontSize: size.width*0.015),
//                         prefixIcon: Icon(Icons.menu_book,size: size.width*0.015,),
                        
//                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2),
//                         borderSide: BorderSide(color: Colors.white) ),
//                         border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                                                   borderRadius: BorderRadius.circular(30),
//                                                   borderSide: BorderSide(
//                                                     color: Colors.white)),
//                         errorBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(color: Colors.white),
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                         focusedErrorBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(color: Colors.white),
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                         errorStyle: TextStyle(color: Colors.white),
//                         ),
//                         validator: (value) {
                              
//                               if(value!.isEmpty){
//                                 return 'Enter an item';
//                               }
//                             },
                        
//                         onChanged: (value) => setState(() {
//                         map.keys.elementAt(index).name = value;
                        
                        
//                       }),),
//                       trailing: IconButton(onPressed: () => setState(() {
//                         map.removeWhere((key, value) => key==category_key);
//                         categorycontrollers.remove(categorycontrollers[index]);
//                         map.forEach((key, value) {print(key.name);});
//                       }), icon: Icon(Icons.delete)),
                
//                       ),
//                       map[category_key]!.isEmpty ?
//                       Container(
//                               padding: EdgeInsets.symmetric(vertical: size.height*0.03),
//                               width: size.width*0.1,
//                               child: ElevatedButton.icon(
                                
//                                 label: Text('Add menuitem',style: TextStyle(fontSize: size.width*0.01),),
//                                 onPressed: () => setState(() {
//                                 map[category_key]!.insert(0, Menuitem());
//                                 menuitemscontrollers.addAll({category_key:[]});
//                                 menuitemscontrollers[category_key]!.insert(0,TextEditingController());
//                               }), icon: Icon(Icons.add,size: size.width*0.02,)),
//                             )
//                       :
//                       ListView.builder(
                        
//                         physics: ClampingScrollPhysics(), 
//                         shrinkWrap: true,
//                         itemCount: menuitemscontrollers[category_key]!.length ,
//                         itemBuilder: (context, index) {
//                           final list = map[category_key];
//                           return ListTile(
//                             title: Row(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: SizedBox(
//                                     width: size.width*0.2,
//                                     child: TextFormField(
//                                       style: TextStyle(fontSize: size.width*0.02),
//                                       controller: menuitemscontrollers[category_key]![index],
//                                       decoration: InputDecoration(
                                      
//                                       hintText:'Enter a menu item',
//                                       labelText: 'Enter a menu item',
//                                       labelStyle: TextStyle(color: Colors.white,fontSize: size.width*0.015),
//                                       hintStyle: TextStyle(color: Colors.white,fontSize: size.width*0.015),
//                                       prefixIcon: Icon(Icons.menu_book,size: size.width*0.015,),
                                      
//                                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2),
//                                       borderSide: BorderSide(color: Colors.white) ),
//                                       border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.circular(30),
//                                                                 borderSide: BorderSide(
//                                                                   color: Colors.white)),
//                                       errorBorder: OutlineInputBorder(
//                                                   borderSide: const BorderSide(color: Colors.white),
//                                                   borderRadius: BorderRadius.circular(30),
//                                                 ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                                   borderSide: const BorderSide(color: Colors.white),
//                                                   borderRadius: BorderRadius.circular(30),
//                                                 ),
//                                       errorStyle: TextStyle(color: Colors.white,fontSize: size.width*0.01),
//                                      ),
//                                       validator: (value) {
//                                         if(value!.isEmpty){
//                                           return 'Enter an item';
//                                         }
//                                       },
//                                       onChanged: (value) => setState(() {
                                      
//                                       list![index].name = value;
                                          
//                                     }),),
//                                   ),
//                                 ),
//                                 SizedBox(width: size.width*0.1,),
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Container(
                                                              
//                                   width: size.width*0.2,
//                                   child: TextFormField(
//                                   style: TextStyle(fontSize: size.width*0.02),
//                                   decoration: InputDecoration(
                                  
//                                   hintText:'Enter a menu price',
//                                   labelText: 'Enter a menu price',
//                                   labelStyle: TextStyle(color: Colors.white,fontSize: size.width*0.015),
//                                   hintStyle: TextStyle(color: Colors.white,fontSize: size.width*0.015),
//                                   prefixIcon: Icon(Icons.menu_book,size: size.width*0.015),
                                  
//                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2),
//                                   borderSide: BorderSide(color: Colors.white) ),
//                                   border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                                             borderRadius: BorderRadius.circular(30),
//                                                             borderSide: BorderSide(
//                                                               color: Colors.white)),
//                                   errorBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(color: Colors.white),
//                                               borderRadius: BorderRadius.circular(30),
//                                             ),
//                                   focusedErrorBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(color: Colors.white),
//                                               borderRadius: BorderRadius.circular(30),
//                                             ),
//                                   errorStyle: TextStyle(color: Colors.white,fontSize: size.width*0.01),
//                                                                ),
//                                   validator: (value) {
//                                     if(value!.isEmpty || value.contains(',')){
//                                       return 'Enter item';
//                                     }
//                                   },
//                                   onChanged: (value) => setState(() {
//                                     list![index].price=value;
//                                   }),
//                                                               )),
//                                 ),
//                               ],
//                             ),
                            
//                             leading: IconButton(onPressed: () => setState(() {
//                               map[category_key]!.remove(list![index]);
//                               menuitemscontrollers[category_key]!.remove(menuitemscontrollers[category_key]![index]);
//                             }), icon: Icon(Icons.delete)),
//                             subtitle:list![index] == map[category_key]!.last ? 
//                           Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Container(
//                               padding: EdgeInsets.symmetric(vertical: size.height*0.03),
//                               width: size.width*0.2,
//                               child: ElevatedButton.icon(
                                
//                                 label: Text('Add menuitem',style: TextStyle(fontSize: size.width*0.01),),
//                                 onPressed: () => setState(() {
//                                 final indexoflist = map[category_key]!.length;
//                                 map[category_key]!.insert(indexoflist, Menuitem());
//                                  menuitemscontrollers[category_key]!.insert(index+1, TextEditingController());
//                               }), icon: Icon(Icons.add,size: size.width*0.02,)),
//                             ),
//                           ) : Container()
//                         ) ;
                        
//                       },)
                      
                      
                      
//                       ,
//                     ],
//                   );
                  
//                 },),
//             ),
            
            
//           ],
//         ),
//       ),
      
//     );
//   }


  
// Future setdatabase() async{
//     final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!);
//     final snapshot = await db.get();
//     final data = snapshot.data()!['Number of Tables'] ;
//     // print(data);
    
//     ref.onValue.listen((event) {
//       if(!event.snapshot.exists){
//         for(int i=1;i<=data;i++){
          
//           // ref.child('${i}').push().set({"No${i}":"${i}"});
//           ref.child('${i}').set({"payment_state":"None","payment_method":"None",});
          
          
//     }
//       }
      
//     });
    
    
//   }
 

 

//   Future download(Reference ref) async{
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
//           json.addAll({element.name!.trim():int.parse(element.price!)});
//         });
//       db.update({key.name!.trim():json});
//     });
//   }else{
//     map.forEach((key, value) {
//       Map json = {};
//       value.forEach((element) {
//           json.addAll({element.name!.trim():int.parse(element.price!)});
//         });
//       db.set({key.name!.trim():json});
//     });
//   }
    
  

 
  
// }

   
// }
// Future signOut() async{
//    await FirebaseAuth.instance.signOut();

// }


