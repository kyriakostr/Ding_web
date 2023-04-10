
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/Animations/ButtonAnimation.dart';
import 'package:ding_web/Animations/DelayedAnimation.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/AuthenticatePages/MenuBottomsheet.dart';
import 'package:ding_web/Screens/TablesPage.dart';
import 'package:ding_web/Screens/OrderPages/Temp.dart';
import 'package:ding_web/Shared/Hovertext.dart';
import 'package:ding_web/Textwidget.dart';
import 'package:ding_web/Utils.dart';
import 'package:ding_web/models/Categories.dart';
import 'package:ding_web/models/Menuitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart';






class TempBusinessPage extends StatelessWidget {
  const TempBusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth>1200){
          return DesktopBusiness();
        }else if(constraints.maxWidth>800 && constraints.maxWidth<1200){
          return DesktopBusiness();
        }else{
          return MobileBusiness();
        }
      },
    );
  }
}

class DesktopBusiness extends StatefulWidget {

   
   DesktopBusiness({super.key});

  @override
  State<DesktopBusiness> createState() => _DesktopBusinessState();
}

class _DesktopBusinessState extends State<DesktopBusiness> {
    final user = FirebaseAuth.instance.currentUser;
    late DatabaseReference ref;
    String temp = '';
    int count = 0;
    Map<Categories,List<Menuitem>> map = {};
    List<TextEditingController> categorycontrollers = [];
    List<TextEditingController> vatcontrollers = [];
    List<DropdownButtonFormField> dropdowns  = [];
    Map<Categories,List<TextEditingController>> menuitemscontrollers = {};
    bool? checking;
    bool state=true;
    StreamSubscription<DocumentSnapshot>? subscription;
    List<String> ingredients = [];
    Map<String,dynamic>? sizeitem={};
    List<String> roles = ['kitchen','bar'];
   bool? validate;
    @override
  void initState() {
   
    ref = FirebaseDatabase.instance.ref().child(user!.displayName!);
    super.initState();
    final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!).collection('Menus').doc(user!.uid);
    print(map);
   subscription = db.snapshots().listen((event) {
      if(event.exists){
        if(mounted){
          setState(() {
          
          checking=true;
        });
        }
      }else{
        if(mounted){
          setState(() {
          state = false;
        });
        }
        
      }
     });
    
  }
  
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
 
  
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final futurefiles = FirebaseStorage.instance.ref().child('${user!.displayName}/').listAll();
    
    return  (checking!=null) ? Temp() : 
      (state==true) ? Center(child: CircularProgressIndicator()) :
     Scaffold(
      
      body: Column(
        children: [
          DelayedAnimation(
                  delayedanimation: 700,
                  anioffsetx: 0.35,
                  anioffsety: 0,
                  aniduration: 700,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => context.goNamed('Home'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Text('Ding',style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.pink,
                      fontSize: size.width*0.03,
                      fontFamily: 'Montserrat'
                      ),),
                      Image.asset('assets/Ding_app.png',width: size.width*0.08,height: size.height*0.08,color: Colors.pink,),
                      ],),
                    ),
                  ),
                ),
          DelayedAnimation(
            delayedanimation: 100,
            aniduration: 500,
            anioffsetx: 0.35,
            anioffsety: 0,
            child: Text('Build your menu',style: TextStyle(fontFamily: 'Montserrat',fontSize: size.width*0.02),)),
          DelayedAnimation(
            delayedanimation: 120,
            aniduration: 500,
            anioffsetx: 0.35,
            anioffsety: 0,
            child: Text('To go to tables screen you have to build your menu first',style: TextStyle(fontFamily: 'Montserrat',fontSize: size.width*0.01),)),
          DelayedAnimation(
            delayedanimation: 150,
            aniduration: 500,
            anioffsetx: 0.35,
            anioffsety: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  label: Text('Add a category',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  icon: Icon(Icons.add,size: 15,),onPressed:() =>  setState(() {
                  // list_categories.insert(0, Categories(name: 'dde'));
                  count = count+1;
                  map.addAll({Categories():[]});
                  categorycontrollers.add(TextEditingController());
                  vatcontrollers.add(TextEditingController());
                }),style: ElevatedButton.styleFrom(
                    shadowColor: Colors.pink.shade800,
                    elevation: 10,
                    primary: Colors.pink.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    )
                  
                  ), ),
                SizedBox(
                  
                  width: 150,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login,size: 15,),
                    label: Text('Submit',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    onPressed: (){
                       
                      map.forEach((key, value) {
                        value.forEach((element) {
                          if(element.price!=null) {
                          setState(() {
                            validate=true;
                          });}else{
                            setState(() {
                              validate=false;
                            });
                          }
                        });
                      });
                      if(_formkey.currentState!.validate() && validate==true){
                         
                             setMenu();
                             setdatabase();    
                             DatabaseManager(displayName: user?.displayName,year: DateFormat('yyyy').format(DateTime.now()) ).setyear();
                          
                      }
                      
                    },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.pink.shade800,
                    elevation: 10,
                    primary: Colors.pink.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    )
                  
                  ), 
                  
                ),
              ),
              ],
            ),
          ),
         validate==false ? Text('An item menu or more does not have a price',style: TextStyle(color: Colors.red),):Container(),
          Divider(),

          Form(
            key: _formkey,
            child: Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: map.keys.length,
                itemBuilder: (context, index) {
                  final category_name = map.keys.elementAt(index).name;
                  final category_key = map.keys.elementAt(index);
                  
                  return Column(
                    children: [
                      DelayedAnimation(
                        delayedanimation: 100,
                        aniduration: 500,
                        anioffsetx: 0.35,
                        anioffsety: 0,
                        child: ListTile(title: TextFormField(
                          style: TextStyle(fontSize: size.width*0.02),
                          controller: categorycontrollers[index],
                          decoration: InputDecoration(
                          hintText:'Enter a menu category (e.g. coffee,juices,deserts)',
                          labelText: 'Enter a menu category',
                          labelStyle: TextStyle(color: Colors.black,fontSize: size.width*0.015),
                          hintStyle: TextStyle(color: Colors.black,fontSize: size.width*0.015),
                          prefixIcon: Icon(Icons.menu_book,size: size.width*0.015,),
                          
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
                          errorStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                                
                                if(value!.isEmpty){
                                  return 'Enter an item';
                                }
                              },
                          
                          onChanged: (value) => setState(() {
                          map.keys.elementAt(index).name = value;
                          
                          
                        }),),
                        trailing: IconButton(onPressed: () => setState(() {
                          map.removeWhere((key, value) => key==category_key);
                          print(map);
                          categorycontrollers.remove(categorycontrollers[index]);
                          map.forEach((key, value) {print(key.name);});
                        }), icon: Icon(Icons.delete)),
                                      
                        ),
                      ),
                      DelayedAnimation(
                      delayedanimation: 100,
                      aniduration: 500,
                      anioffsetx: 0.35,
                      anioffsety: 0,
                      child: SizedBox(
                        width: size.width*0.2,
                        child: ListTile(title: TextFormField(
                          style: TextStyle(fontSize: size.width*0.02),
                          controller: vatcontrollers[index],
                          decoration: InputDecoration(
                          hintText:'Enter VAT',
                          labelText: 'Enter VAT',
                          labelStyle: TextStyle(color: Colors.black,fontSize: size.width*0.015),
                          hintStyle: TextStyle(color: Colors.black,fontSize: size.width*0.015),
                          prefixIcon: Icon(Icons.menu_book,size: size.width*0.015,),
                          
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
                          errorStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                                
                                if(value!.isEmpty){
                                  return 'Enter an item';
                                }
                              },
                          
                          onChanged: (value) => setState(() {
                          map.keys.elementAt(index).vat = value;
                          print(map.keys.elementAt(index).vat);
                          
                        }),),
                    
                                      
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: size.width*0.3,
                      child: DropdownButtonFormField(
                          
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          hintText: 'Add another item'),
                          items: roles.map((e) =>DropdownMenuItem(
                            value: e,
                            child: Text(e))).toList(), onChanged: (value) {
                            setState(() {
                              map.keys.elementAt(index).role = value;
                              print(map.keys.map((e) => e.role));
                            });
                            
                        },)),
                      map[category_key]!.isEmpty ?
                      DelayedAnimation(
                        delayedanimation: 150,
                        aniduration: 500,
                        anioffsetx: 0.35,
                        anioffsety: 0,
                        child: Container(
                                padding: EdgeInsets.symmetric(vertical: size.height*0.03),
                                height: size.height*0.12,
                                width: size.width*0.2,
                                child: ElevatedButton.icon(
                                  
                                  label: Text('Add menuitem',style: TextStyle(fontSize: size.width*0.02),),
                                  onPressed: () => setState(() {
                                  map[category_key]!.insert(0, Menuitem(ingredients: [],size: {},categories: {}));
                                  menuitemscontrollers.addAll({category_key:[]});
                                  menuitemscontrollers[category_key]!.insert(0,TextEditingController());
                                }), icon: Icon(Icons.add,size: size.width*0.02,),style: ElevatedButton.styleFrom(
                                shadowColor: Colors.pink.shade800,
                                elevation: 10,
                                primary: Colors.pink.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                )
                              
                                          ), ),
                              ),
                      )
                      :
                      ListView.builder(
                        
                        physics: ClampingScrollPhysics(), 
                        shrinkWrap: true,
                        itemCount: menuitemscontrollers[category_key]!.length ,
                        itemBuilder: (context, index) {
                          final list = map[category_key];
                          ingredients.clear();
                          sizeitem?.clear();
                          return DelayedAnimation(
                            aniduration: 500,
                            delayedanimation: 100,
                            anioffsetx: 0,
                            anioffsety: -0.2,
                            child: ListTile(
                              title: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: size.width*0.35,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: size.width*0.02),
                                        controller: menuitemscontrollers[category_key]![index],
                                        decoration: InputDecoration(
                                        
                                        hintText:'Enter a menu item (e.g. espresso,orange juice,cake)',
                                        labelText: 'Enter a menu item',
                                        labelStyle: TextStyle(color: Colors.black,fontSize: size.width*0.015),
                                        hintStyle: TextStyle(color: Colors.black,fontSize: size.width*0.015),
                                        prefixIcon: Icon(Icons.menu_book,size: size.width*0.015,),
                                        
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
                                        validator: (value) {
                                          if(value!.isEmpty){
                                            return 'Enter an item';
                                          }
                                        },
                                        onChanged: (value) => setState(() {
                                        
                                        list![index].name = value;
                                            
                                      }),),
                                    ),
                                  ),
                                  SizedBox(width: size.width*0.1,),
                                  Column(
                                    children: [
                                      
                                      ElevatedButton.icon(
                                        label:
                                        Text('Add custom settings for this item (e.g. sugars for coffee)',style: TextStyle(fontSize: size.width*0.015),),
                                        onPressed: () => 
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
                                        ),
                                        backgroundColor: Colors.white,
                                        isScrollControlled: true,context: context, 
                                        builder:  (context) => MenuBottomsheet(menuItem: list![index]),), icon: Icon(Icons.add_box)),
                                        IconButton(onPressed: () { 
                                        
                                        
                                        // print(list![index].ingredients);
                                        print(list?[index].size);
                                        print(list?[index].price);
                                        print(list?[index].categories);
                                        
                                        // print( list[index].name);
                                        }, icon: Icon(Icons.print))
                                    ],
                                  )
                                ],
                              ),
                              
                              leading: IconButton(onPressed: () => setState(() {
                                map[category_key]!.remove(list![index]);
                                menuitemscontrollers[category_key]!.remove(menuitemscontrollers[category_key]![index]);
                              }), icon: Icon(Icons.delete)),
                              subtitle:list![index] == map[category_key]!.last ? 
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: size.height*0.03),
                                width: size.width*0.2,
                                child: ElevatedButton.icon(
                                  
                                  label: Text('Add menuitem',style: TextStyle(fontSize: size.width*0.015),),
                                  onPressed: () => setState(() {
                                   
                                   
                                   
                                    
                                  final indexoflist = map[category_key]!.length;
                                  map[category_key]!.insert(indexoflist, Menuitem(ingredients: [],size: {},categories: {}));
                                  menuitemscontrollers[category_key]!.insert(index+1, TextEditingController());
                                }), icon: Icon(Icons.add,size: size.width*0.02,),style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.pink.shade800,
                                                elevation: 10,
                                                primary: Colors.pink.shade400,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50)
                                                )
                                              
                                              ), ),
                              ),
                            ) : Container()
                                                  ),
                          ) ;
                        
                      },)
                      
                      
                      
                      ,
                    ],
                  );
                  
                },),
            ),
          ),
          
          
        ],
      ),
      
    );
  }

  




  
Future setdatabase() async{
    final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!);
    final snapshot = await db.get();
    final data = snapshot.data()!['Number of Tables'] ;
    // print(data);
    
    ref.onValue.listen((event) {
      if(!event.snapshot.exists){
        for(int i=1;i<=data;i++){
          
          // ref.child('${i}').push().set({"No${i}":"${i}"});
          ref.child('${i}').set({"payment_state":"None","payment_method":"None",});
          
          
    }
      }
      
    });
    
    
  }
 

 

  Future download(Reference ref) async{
    final url =await ref.getDownloadURL();
    final WebImageDownloader _webImageDownloader = WebImageDownloader();
    await _webImageDownloader.downloadImageFromWeb(url);
    Utils().showSnackBar('Download files');
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
Future setMenu() async{
  final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!).collection('Menus').doc(user!.uid);
  final snapshot = await db.get();
  final data = snapshot.data() ;

  if(snapshot.exists){
    map.forEach((key, value) {
      Map json = {};
      value.forEach((element) {
          
         
          json.addAll({element.name!.trim():
          {'ingredients':FieldValue.arrayUnion(element.ingredients!),'sizes':element.size,'price':double.parse(element.price!),
          'disabled':false},
          });
          element.categories?.forEach((key, value) {
            json[element.name?.trim()][key]=FieldValue.arrayUnion(value);
          });
          
        });
        json.addAll({'VAT':double.parse(key.vat!),'role':key.role});
      db.set({key.name!.trim():json},SetOptions(merge: true));
    });
  }else{
    db.set({});
    map.forEach((key, value) {
      Map json = {};
      value.forEach((element) {
         
        
          
          
          json.addAll({element.name!.trim():
          {'ingredients':FieldValue.arrayUnion(element.ingredients!),'sizes':element.size,'price':double.parse(element.price!),
          'disabled':false}});
          element.categories?.forEach((key, value) {
            json[element.name?.trim()][key]=FieldValue.arrayUnion(value);
          });
          
        
        
          
        });
          json.addAll({'VAT':double.parse(key.vat!),'role':key.role});
          db.update({key.name!.trim():json});
        
      
    });
  }
    
  
}


   
}

class MobileBusiness extends StatefulWidget {

   
   MobileBusiness({super.key});

  @override
  State<MobileBusiness> createState() => _MobileBusinessState();
}

class _MobileBusinessState extends State<MobileBusiness> {
    final user = FirebaseAuth.instance.currentUser;
    late DatabaseReference ref;
    String temp = '';
    int count = 0;
    Map<Categories,List<Menuitem>> map = {};
    List<TextEditingController> categorycontrollers = [];
    List<TextEditingController> vatcontrollers = [];
    Map<Categories,List<TextEditingController>> menuitemscontrollers = {};
    bool? checking;
    bool state=true;
    StreamSubscription<DocumentSnapshot>? subscription;
   List<String> ingredients = [];
   Map<String,dynamic>? sizeitem={};
    bool? validate;
    @override
  void initState() {
    ref = FirebaseDatabase.instance.ref().child(user!.displayName!);
    super.initState();
    final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!).collection('Menus').doc(user!.uid);
    print(map);
   subscription = db.snapshots().listen((event) {
      if(event.exists){
        if(mounted){
          setState(() {
          
          checking=true;
        });
        }
      }else{
        if(mounted){
          setState(() {
          state = false;
        });
        }
        
      }
     });
    
  }
  
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
 
  
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final futurefiles = FirebaseStorage.instance.ref().child('${user!.displayName}/').listAll();
    
    return  (checking!=null) ? Temp() : 
      (state==true) ? Center(child: CircularProgressIndicator()) :
     Scaffold(
      
      body: Column(
        
        children: [
          DelayedAnimation(
                  delayedanimation: 700,
                  anioffsetx: 0.35,
                  anioffsety: 0,
                  aniduration: 700,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => context.goNamed('Home'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text('Ding',style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.pink,
                      fontSize: size.width*0.03,
                      fontFamily: 'Montserrat'
                      ),),
                      Image.asset('assets/Ding_app.png',width: size.width*0.08,height: size.height*0.08,color: Colors.pink,),
                      ],),
                    ),
                  ),
                ),
          // Row(children: [
          //   IconButton(onPressed: (){
          //   futurefiles.then((value) => value.items.forEach((element) {download(element);}));
          // }, icon: Icon(Icons.download)),
          
          //  IconButton(icon: Icon(Icons.logout,),onPressed:() =>  setState(() {
          //   // list_categories.insert(0, Categories(name: 'dde'));
          //   signOut();
          // }),),
          
          // ],),
          DelayedAnimation(
            aniduration: 500,
            anioffsetx: 0.35,
            anioffsety: 0,
            delayedanimation: 100,
            child: Text('Build your menu',style: TextStyle(fontFamily: 'Montserrat',fontSize: size.width*0.03),)),
          
          DelayedAnimation(
            aniduration: 500,
            anioffsetx: 0.35,
            anioffsety: 0,
            delayedanimation: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  label: Text('Add a category',style: TextStyle(fontSize: 10),),
                  icon: Icon(Icons.add,size:10),onPressed:() =>  setState(() {
                  // list_categories.insert(0, Categories(name: 'dde'));
                  count = count+1;
                  map.addAll({Categories():[]});
                  categorycontrollers.add(TextEditingController());
                }),style: ElevatedButton.styleFrom(
                  shadowColor: Colors.pink.shade800,
                  elevation: 10,
                  primary: Colors.pink.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  )
                
                ), ),
                SizedBox(
                  
                  width: size.width*0.15,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login,size: 10,),
                    label: Text('Submit',style: TextStyle(fontSize:10,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    onPressed: (){
                     
                      map.forEach((key, value) {
                        value.forEach((element) {
                          if(element.price!=null)
                          { setState(() {
                            validate=true;
                          });}else{
                            setState(() {
                              validate=false;
                            });
                          }
                        });
                      });
                      if(_formkey.currentState!.validate() && validate==true){
                         
                             setMenu();
                             setdatabase();    
                             DatabaseManager(displayName: user?.displayName,year: DateFormat('yyyy').format(DateTime.now()) ).setyear();
                      }
                      
                    },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.pink.shade800,
                    elevation: 10,
                    primary: Colors.pink.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    )
                  
                  ), 
                  
                ),
              ),
              ],
            ),
          ),
          validate==false ? Text('An item menu or more does not have a price',style: TextStyle(
            color: Colors.red,fontSize: 10),):Container(),
          Divider(),
          Form( //arxi kai singlescroll kai xvris to flexible
            key: _formkey,
            child: Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: map.keys.length,
                itemBuilder: (context, index) {
                  final category_name = map.keys.elementAt(index).name;
                  final category_key = map.keys.elementAt(index);
                  return Column(
                    children: [
                      DelayedAnimation(
                        aniduration: 500,
                        delayedanimation: 100,
                        anioffsetx: 0.35,
                        anioffsety: 0,
                        child: ListTile(title: TextFormField(
                          style: TextStyle(fontSize: size.width*0.03),
                          controller: categorycontrollers[index],
                          decoration: InputDecoration(
                          hintText:'Enter a menu category (e.g. coffee,juices,deserts)',
                          labelText: 'Enter a menu category',
                          labelStyle: TextStyle(color: Colors.black,fontSize: size.width*0.02),
                          hintStyle: TextStyle(color: Colors.black,fontSize: size.width*0.02),
                          prefixIcon: Icon(Icons.menu_book,size: size.width*0.02,),
                          
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
                          errorStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                                
                                if(value!.isEmpty){
                                  return 'Enter an item';
                                }
                              },
                          
                          onChanged: (value) => setState(() {
                          map.keys.elementAt(index).name = value;
                          
                          
                        }),),
                        trailing: IconButton(onPressed: () => setState(() {
                          map.removeWhere((key, value) => key==category_key);
                          print(map);
                          categorycontrollers.remove(categorycontrollers[index]);
                          map.forEach((key, value) {print(key.name);});
                        }), icon: Icon(Icons.delete)),
                                      
                        ),
                      ),
                      map[category_key]!.isEmpty ?
                      DelayedAnimation(
                        delayedanimation: 150,
                        aniduration: 500,
                        anioffsetx: 0.35,
                        anioffsety: 0,
                        child: Container(
                                padding: EdgeInsets.symmetric(vertical: size.height*0.03),
                                height: size.height*0.12,
                                width: size.width*0.3,
                                child: ElevatedButton.icon(
                                  
                                  label: Text('Add menuitem',style: TextStyle(fontSize: size.width*0.02),),
                                  onPressed: () => setState(() {
                                  map[category_key]!.insert(0, Menuitem(ingredients: [],size: {},categories: {}));
                                  menuitemscontrollers.addAll({category_key:[]});
                                  menuitemscontrollers[category_key]!.insert(0,TextEditingController());
                                }), icon: Icon(Icons.add,size: size.width*0.02,),style: ElevatedButton.styleFrom(
                                shadowColor: Colors.pink.shade800,
                                elevation: 10,
                                primary: Colors.pink.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                )
                                          
                                          ), ),
                              ),
                      )
                      :
                      ListView.builder(
                        
                        physics: ClampingScrollPhysics(), 
                        shrinkWrap: true,
                        itemCount: menuitemscontrollers[category_key]!.length ,
                        itemBuilder: (context, index) {
                          final list = map[category_key];
                          ingredients.clear();
                          sizeitem?.clear();
                          return DelayedAnimation(
                            aniduration: 500,
                            delayedanimation: 100,
                            anioffsetx: 0,
                            anioffsety: -0.2,
                            child: ListTile(
                              title: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: size.width*0.35,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: size.width*0.02),
                                        controller: menuitemscontrollers[category_key]![index],
                                        decoration: InputDecoration(
                                        
                                        hintText:'Enter a menu item (e.g. espresso,orange juice,cake)',
                                        labelText: 'Enter a menu item',
                                        labelStyle: TextStyle(color: Colors.black,fontSize: size.width*0.02),
                                        hintStyle: TextStyle(color: Colors.black,fontSize: size.width*0.02),
                                        prefixIcon: Icon(Icons.menu_book,size: size.width*0.02,),
                                        
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
                                        validator: (value) {
                                          if(value!.isEmpty){
                                            return 'Enter an item';
                                          }
                                        },
                                        onChanged: (value) => setState(() {
                                        
                                        list![index].name = value;
                                            
                                      }),),
                                    ),
                                  ),
                                  SizedBox(width: size.width*0.1,),
                                  Column(
                                   
                                    children: [
                                      
                                      Container(
                                        width: size.width*0.3,
                                        child: ElevatedButton.icon(
                                          label: Text('Add custom settings for this item (e.g. sugars for coffee)',
                                        style: TextStyle(fontSize: size.width*0.015),),
                                          onPressed: () => 
                                        showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
                                          ),
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,context: context, 
                                          builder:  (context) => MenuBottomsheet(menuItem: list![index]),), icon: Icon(Icons.add_box,size: size.width*0.04,)),
                                      ),
                                        // IconButton(onPressed: () { 
                                        
                                        
                                        // // print(list![index].ingredients);
                                        // print(list?[index].size);
                                       
                                        // print(list?[index].price);
                                        // print(list?[index].categories);
                                        
                                        // // print( list[index].name);
                                        // }, icon: Icon(Icons.print))
                                    ],
                                  )
                                ],
                              ),
                              
                              leading: IconButton(onPressed: () => setState(() {
                                map[category_key]!.remove(list![index]);
                                menuitemscontrollers[category_key]!.remove(menuitemscontrollers[category_key]![index]);
                              }), icon: Icon(Icons.delete,size: size.width*0.04,)),
                              subtitle:list![index] == map[category_key]!.last ? 
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: size.height*0.03),
                                width: size.width*0.2,
                                child: ElevatedButton.icon(
                                  
                                  label: Text('Add menuitem',style: TextStyle(fontSize: size.width*0.015),),
                                  onPressed: () => setState(() {
                                   
                                   
                                   
                                    
                                  final indexoflist = map[category_key]!.length;
                                  map[category_key]!.insert(indexoflist, Menuitem(ingredients: [],size: {},categories: {}));
                                  menuitemscontrollers[category_key]!.insert(index+1, TextEditingController());
                                }), icon: Icon(Icons.add,size: size.width*0.02,),style: ElevatedButton.styleFrom(
                                shadowColor: Colors.pink.shade800,
                                elevation: 10,
                                primary: Colors.pink.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                )
                              
                              ), ),
                              ),
                            ) : Container()
                                                  ),
                          ) ;
                        
                      },)
                      
                      
                      
                      ,
                    ],
                  );
                  
                },),
            ),
          ),
          
          
        ],
      ),
      
    );
  }

  




  
Future setdatabase() async{
    final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!);
    final snapshot = await db.get();
    final data = snapshot.data()!['Number of Tables'] ;
    // print(data);
    
    ref.onValue.listen((event) {
      if(!event.snapshot.exists){
        for(int i=1;i<=data;i++){
          
          // ref.child('${i}').push().set({"No${i}":"${i}"});
          ref.child('${i}').set({"payment_state":"None","payment_method":"None",});
          
          
    }
      }
      
    });
    
    
  }

  
 

 

  Future download(Reference ref) async{
    final url =await ref.getDownloadURL();
    final WebImageDownloader _webImageDownloader = WebImageDownloader();
    await _webImageDownloader.downloadImageFromWeb(url);
    Utils().showSnackBar('Download files');
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
Future setMenu() async{
  final db = FirebaseFirestore.instance.collection('Business').doc(user!.displayName!).collection('Menus').doc(user!.uid);
  final snapshot = await db.get();
  final data = snapshot.data() ;

  if(snapshot.exists){
    map.forEach((key, value) {
      Map json = {};
      value.forEach((element) {
          
          json.addAll({element.name!.trim():int.parse(element.price!)});
        });
      db.update({key.name!.trim():json});
    });
  }else{
    map.forEach((key, value) {
      Map json = {};
      value.forEach((element) {
         
        if((element.ingredients!.isNotEmpty||element.size!.isNotEmpty)&&element.price!=null){
          
          bool checking = element.price==null;
          json.addAll({element.name!.trim():
          {'ingredients':FieldValue.arrayUnion(element.ingredients!),'sizes':element.size,'price':int.parse(element.price!),'disabled':false},
          });
          element.categories?.forEach((key, value) {
            json[element.name?.trim()][key]=FieldValue.arrayUnion(value);
          });
          
        }else{
          json.addAll({element.name!.trim():{'ingredients':FieldValue.arrayUnion(element.ingredients!),'sizes':element.size,'disabled':false}});
        }
        
          
        });
      db.set({key.name!.trim():json});
    });
  }
    
  

 
  
}
}

Future signOut() async{
  await FacebookAuth.instance.logOut();
   await FirebaseAuth.instance.signOut();
   
   await GoogleSignIn().disconnect();

}


