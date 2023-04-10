import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/Animations/DelayedAnimation.dart';
import 'package:ding_web/Screens/AuthenticatePages/MenuBottomsheet.dart';
import 'package:ding_web/models/Categories.dart';
import 'package:ding_web/models/Menuitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpgradeMenu extends StatefulWidget {
  const UpgradeMenu({super.key});

  @override
  State<UpgradeMenu> createState() => _UpgradeMenuState();
}

class _UpgradeMenuState extends State<UpgradeMenu> {
  final user = FirebaseAuth.instance.currentUser;
  Map<Categories,List<Menuitem>> map = {};
  List<TextEditingController> categorycontrollers = [];
  List<TextEditingController> vatcontrollers = [];
  List<DropdownButtonFormField> dropdowns  = [];
  Map<Categories,List<TextEditingController>> menuitemscontrollers = {};
  Map<String,List<TextEditingController>> editmenuitemscontrollers = {};
  Map<String,List<bool>> menu={};
  List<String> ingredients = [];
   Map<String,dynamic>? sizeitem={};
   final _formkey = GlobalKey<FormState>();
   List<String> roles = ['kitchen','bar'];
   List<String> selectedroles = [];
   bool? validate;
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
                    children: [
                      ElevatedButton.icon(
                          label: Text('Add a category',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          icon: Icon(Icons.add,size: 15,),onPressed:() =>  setState(() {
                          // list_categories.insert(0, Categories(name: 'dde'));
                          // count = count+1;
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
                          SizedBox(width: 10,),
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
                    SizedBox(height: 10,),
             Form(
            key: _formkey,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: map.keys.length,
              itemBuilder: (context, index) {
                final category_name = map.keys.elementAt(index).name;
                final category_key = map.keys.elementAt(index);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        vatcontrollers.remove(vatcontrollers[index]);
                        
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
                      child: Center(
                        child: Container(
                                padding: EdgeInsets.symmetric(vertical: size.height*0.03),
                                height: size.height*0.12,
                                width: size.width*0.1,
                                child: ElevatedButton.icon(
                                  
                                  label: Text('Add menuitem',style: TextStyle(fontSize: size.width*0.01),),
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
                                    width: size.width*0.1,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: size.width*0.01),
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
                              width: size.width*0.1,
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
      ],
    );
            
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
          {'ingredients':FieldValue.arrayUnion(element.ingredients!),'sizes':element.size,
          'price':double.parse(element.price!),'disabled':false},
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
          'disabled':false},
          });
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