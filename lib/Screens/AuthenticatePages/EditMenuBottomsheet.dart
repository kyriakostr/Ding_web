import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/models/Categories.dart';
import 'package:ding_web/models/Menuitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditMenuBottomsheet extends StatefulWidget {
  Menuitem? menuitem;
  String? category;
  User? user;
  EditMenuBottomsheet({super.key,this.menuitem,this.category,this.user});

  @override
  State<EditMenuBottomsheet> createState() => _EditMenuBottomsheetState();
}

class _EditMenuBottomsheetState extends State<EditMenuBottomsheet> {
  TextEditingController pricecontroller = TextEditingController();
   List<String> customsize =[];
   List<String> customsizeprice = [];
   List<String> category = [];
   List<String> extraitem=[];
   List<String> extraitemprice=[];
   List<TextEditingController> ingredientscontroller = [];
   List<TextEditingController> categorycontroller= [];
   Map<Categories,List<TextEditingController>> extraitemcontroller = {};
   Map<Categories,List<TextEditingController>> extraitempricecontroller = {};
   final _formkey = GlobalKey<FormState>();
   String errortext = '';
   bool value = false;

   @override
  void initState() {
    // TODO: implement initState
    setState(() {
       
       widget.menuitem?.ingredients=[];
       widget.menuitem?.size={};
       widget.menuitem?.categories={};
       widget.menuitem?.price=null;
    });
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
   
    return Container(
      height: size.height*0.8,
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(children: [
            Text('Add extra information about the product',style: TextStyle(fontFamily: 'Montserrat'),),
            
            
            ingredientscontroller.isEmpty?
            ElevatedButton.icon(
              label:Text('Add ingredients',style: TextStyle(fontWeight: FontWeight.w600)),
              onPressed: () => setState(() {
              ingredientscontroller.insert(0, TextEditingController());
              widget.menuitem?.ingredients?.insert(0, '');
              
            }), icon: Icon(Icons.add_box)):
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: ingredientscontroller.length,
              itemBuilder: (context, index) {
     
               return SingleChildScrollView(
                 child: Column(
                   children: [
                    
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Align(child: Container(width: size.width*0.4,child: TextFormField(
                          onChanged: (value) => setState(() {
                           widget.menuitem?.ingredients?[index]=value;
                            
                            
                          }),
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Enter an item';
                            }
                          },
                          controller: ingredientscontroller[index],decoration: InputDecoration(
                          border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                          ),),))),
                         IconButton(onPressed: () => setState(() {
                           ingredientscontroller.remove(ingredientscontroller[index]);
                           widget.menuitem?.ingredients?.removeAt(index);
                        
                         }), icon: Icon(Icons.delete))
                       ],
                     ),
                    SizedBox(height: size.height*0.02,),
                   ingredientscontroller[index] == ingredientscontroller.last ? IconButton(onPressed: () => 
                     setState(() {
                       ingredientscontroller.insert(index+1, TextEditingController());
                        widget.menuitem?.ingredients?.insert(index+1, '');
               
                     }), icon: Icon(Icons.add_box)) : Container()
                   ],
                 ),
               );
              },),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch.adaptive(value: value, onChanged: (value) => setState(() {
                    this.value=value;
                  }),),
                  Text('If you want to add more sizes on the product turn on the switch',style: TextStyle(fontFamily: 'Montserrat'))
                ],
              ),
              value ? 
              Column(children: [
                Text('Add size (optional)',style: TextStyle(fontWeight: FontWeight.bold)),
            customsize.isEmpty ?
            IconButton(onPressed: () => setState(() {
              
              customsize.insert(0, '0');
              customsizeprice.insert(0, '0');

            }), icon: Icon(Icons.add_box)):
            ListView.builder(
              shrinkWrap: true,
              itemCount: customsize.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
              
                return Column(
                  children: [
                    Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Align(child: Container(width: size.width*0.4,child: TextFormField(
                             onChanged: (value) => setState(() {
                               customsize[index]=value;
                             }),
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Enter an item';
                                }
                              },
                              decoration: InputDecoration(
                              border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                              ),),))),
                              SizedBox(width: size.width*0.07,),
                              Align(child: Container(width: size.width*0.2,child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  // widget.menuItem?.size?.addAll({sizecontroller[index].text.trim():value});
                                  customsizeprice[index]=value;
                                  print(customsizeprice[index]);
                                });
                                
                              },
                              validator: (value) {
                                if(value!.isEmpty){
                                  return 'Enter an item';
                                }
                              },
                             decoration: InputDecoration(
                              border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                              ),),))),
                             IconButton(onPressed: () => setState(() {
                              //  widget.menuItem?.size?.removeWhere((key, value) => key== sizecontroller[index].text);
                               
                               customsize.removeAt(index);
                               customsizeprice.removeAt(index);
                             }), icon: Icon(Icons.delete))
                           ],
                         ),
                         SizedBox(height: size.height*0.02,),
                   customsize[index] == customsize.last ? IconButton(onPressed: () => 
                     setState(() {
                      
                       
                       customsize.add('element${index+1}');
                       customsizeprice.add('element${index+1}');
                       print(customsize.length);
                       print(customsizeprice.length);
                     }), icon: Icon(Icons.add_box)) : Container()
                  ],
                );
              },),
              ],):Align(child: Container(width: size.width*0.4,child: TextFormField(
                              controller: pricecontroller,
                              onChanged: (value) {
                                widget.menuitem?.price=value;
                               
                              },
                              validator: (value) {
                                if(value!.isEmpty || value.contains(RegExp(r'[A-Z]')) || value.contains(',')){
                                  return 'Enter a price(i.e. 2.3)';
                                }
                              },
                              decoration: InputDecoration(
                              labelText: '',
                              border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                              ),),))),
              Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                
                ElevatedButton.icon(
                  label: Text('Add other categories(optional)',style: TextStyle(fontWeight: FontWeight.w600)),
                  onPressed: () => setState(() {
                  category.add('value');
                  categorycontroller.add( TextEditingController());
                  extraitemcontroller.addAll({Categories():[]});
                  extraitempricecontroller.addAll({Categories():[]});
                }), icon: Icon(Icons.add_box)),
                
              ],
            ),
            SizedBox(height: size.height*0.02,),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: categorycontroller.length,
              itemBuilder: (context, index) {
               
                return Column(
                  children: [
                    SizedBox(height: size.height*0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width*0.4,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Enter a category',
                              hintText: '(e.g. sugars,extra ingredients)',
                              border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                              ),),
                            controller: categorycontroller[index],
                            onChanged: (value) { setState(() {
                              category[index]=value.trim();
                              extraitemcontroller.keys.elementAt(index).name=value.trim();
                              extraitempricecontroller.keys.elementAt(index).name=value.trim();
                              
                            });},
                            
                          ),
                        ),
                        IconButton(onPressed: () => setState(() {
                          categorycontroller.removeAt(index);
                          extraitemcontroller.removeWhere((key, value) => key==extraitemcontroller.keys.elementAt(index));
                          extraitempricecontroller.removeWhere((key, value) => key==extraitempricecontroller.keys.elementAt(index));
                          category.removeAt(index);
                        }), icon: Icon(Icons.delete))
                      ],
                    ),
                    SizedBox(height: size.height*0.02,),
                    extraitemcontroller[extraitemcontroller.keys.elementAt(index)]!.isEmpty?
                    ElevatedButton.icon(
                      label: Text('Add items(e.g. sugars)',style: TextStyle(fontWeight: FontWeight.w600)),
                      onPressed: () => setState(() {
                    extraitem.insert(0, 'element0');
                    extraitemprice.insert(0, 'element0');
                     extraitemcontroller[extraitemcontroller.keys.elementAt(index)]!.insert(0, TextEditingController());
                     extraitempricecontroller[extraitempricecontroller.keys.elementAt(index)]!.insert(0, TextEditingController());
                    }), icon: Icon(Icons.add_box))
                    :
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: extraitemcontroller[extraitemcontroller.keys.elementAt(index)]!.length,
                      itemBuilder: (context, currentindex) {
                        return Column(
                          children: [
                            SizedBox(height: size.height*0.02,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width*0.3,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                              labelText: 'Enter extra item',
                              hintText: '(e.g. 2 sugars,extra cheese )',
                              border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                              ),),
                                    controller: extraitemcontroller[extraitemcontroller.keys.elementAt(index)]![currentindex],
                                    onChanged: (value) => setState(() {
                                      extraitem[currentindex]=value.trim();
                                      print(extraitem[currentindex]);
                                    }),
                                  ),
                                ),
                                SizedBox(width: size.width*0.1,),
                                Container(
                                  width: size.width*0.2,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Enter price for extra item',
                                      
                              border:OutlineInputBorder(borderRadius: BorderRadius.circular(size.width*0.2)
                              ),),
                                    controller: extraitempricecontroller[extraitempricecontroller.keys.elementAt(index)]![currentindex] ,
                                    onChanged: (value) => setState(() {
                                      extraitemprice[currentindex]=value.trim();
                                      print(extraitemprice[currentindex]);
                                     
                                      //  widget.menuItem?.categories?[widget.menuItem?.categories?.keys.elementAt(index)]?.add(value);
                                      // final item =  widget.menuItem?.categories?[widget.menuItem?.categories?.keys.elementAt(index)]?[currentindex];
                                      // widget.menuItem?.categories?[widget.menuItem?.categories?.keys.elementAt(index)]?.add(item!+' '+value);
                                    }),
                                  ),
                                ),
                                Text('(Optional)',style: TextStyle(fontFamily: 'Montserrat'),),
                                Row(
                                  children: [
                                    IconButton(onPressed: () => setState(() {
                                    extraitemcontroller[extraitemcontroller.keys.elementAt(index)]?.removeAt(currentindex);
                                    extraitempricecontroller[extraitempricecontroller.keys.elementAt(index)]?.removeAt(currentindex);
                                    extraitem.removeAt(currentindex);
                                    extraitemprice.removeAt(currentindex);
                              }), icon: Icon(Icons.delete)),
                              IconButton(onPressed: () => setState(() {
                                    print(widget.menuitem?.categories?.keys);
                              }), icon: Icon(Icons.print)),
                                  ],
                                ),
                              ],
                            ),
                            
                            extraitemcontroller[ extraitemcontroller.keys.elementAt(index)]![currentindex]==extraitemcontroller[ extraitemcontroller.keys.elementAt(index)]!.last?
                            ElevatedButton.icon(
                              label: Text('Add more items'),
                              onPressed: () => setState(() {
                              extraitemcontroller[extraitemcontroller.keys.elementAt(index)]!.insert(currentindex+1, TextEditingController());
                              extraitempricecontroller[extraitempricecontroller.keys.elementAt(index)]!.insert(currentindex+1, TextEditingController());
                              extraitem.insert(currentindex+1, 'element${currentindex+1}');
                              extraitemprice.insert(currentindex+1, 'element${currentindex+1}');
                            }), icon: Icon(Icons.add_circle_sharp),style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                            ) : Container(height: size.height*0.03,)
                          ],
                        );
                      },)
                  ],
                );
              },),
           
              Divider(),
            Container(width: size.width*0.5,child: TextFormField(
              maxLines: 6,
              
              decoration: InputDecoration(
                          hintText: 'Tell some information about the product  (country potaton in the oven etc.)',
                          border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)
              ),),)),
              SizedBox(height: size.height*0.08,),
              // IconButton(onPressed: () => setState(() {
              //   print(extraitem);
              //   print(extraitemprice);
              // }), icon: Icon(Icons.print)),
              Container(
                    padding: EdgeInsets.only(bottom: 10),
                    width: 150,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.login,size: 15,),
                      label: Text('Apply',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      onPressed: () async{
                        
                        if(_formkey.currentState!.validate()){
                          int count =0;
                          
                           customsize.forEach((element) {
                            if(count==0&&widget.menuitem?.price==null)widget.menuitem?.price=customsizeprice[count];
                            widget.menuitem?.size?.addAll({element:customsizeprice[count]});
                            count+=1;
                            print(count);
                           });
                           final list=[];
                           extraitempricecontroller.forEach((key, value) {
                            value.forEach((element) {list.add(element.text.trim());});
                           });
                           extraitemcontroller.forEach((key, value) {
                            widget.menuitem?.categories?.addAll({key.name!:[]});
                            
                            int index=0;
                            value.forEach((element) {
                              if(list[index]!='')
                              widget.menuitem?.categories?[key.name]?.add(element.text.trim()+' '+list[index]);
                              else widget.menuitem?.categories?[key.name]?.add(element.text.trim());
                              index+=1;
                            });
                            
                           });
                           print(widget.category);
                           print(widget.menuitem?.name);
                           print(widget.menuitem?.disabled);
                           print(widget.user?.uid);
                           print(widget.menuitem?.ingredients);
                          //  print(widget.menuitem?.price);
                          //  print(widget.menuitem?.categories);
                            Map json = {};

                            json.addAll(
                          { widget.menuitem?.name:
                            {'sizes':widget.menuitem?.size ?? {},
                            'price':double.parse(widget.menuitem!.price!),
                            'disabled':false
                            }
                          },
                          );
                          if(widget.menuitem?.ingredients!=null) 
                          json[widget.menuitem?.name]['ingredients']=FieldValue.arrayUnion(widget.menuitem!.ingredients!);
                          
                          if(widget.menuitem?.categories!=null)
                          widget.menuitem?.categories?.forEach((key, value) {
                            json[widget.menuitem?.name][key]=FieldValue.arrayUnion(value);
                          });
                          print(json);
          
                           await  FirebaseFirestore.instance.collection('Business').doc(widget.user?.displayName).
                            collection('Menus').doc(widget.user?.uid).set({widget.category!:
                            
                              json
                            },
                            SetOptions(merge: true));

                                      
                            Navigator.pop(context);  
                          
                              
                            
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
               
          ]),
        ),
      ),
    );
  }
}