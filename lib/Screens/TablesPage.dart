import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final current_user = FirebaseAuth.instance.currentUser;
  late DatabaseReference ref;
  late StreamSubscription subscription;
  int count =0 ;
  
  @override
  void initState() {
    // TODO: implement initState
    ref = FirebaseDatabase.instance.ref().child(current_user!.displayName!);
  
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    Size size = MediaQuery.of(context).size;
    
     
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Business').doc(user!.displayName).snapshots(),
      builder: (context,snapshot) {

        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        final length = snapshot.data!.data()!['Number of Tables'];
        return Column(
          children: [

            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                GestureDetector(
                  onTap: () => {
                    GoRouter.of(context).go('/')
                  },
                  child: Text( 'Home' ,style: TextStyle(color: Colors.black,
                  fontSize: size.height*0.02,fontWeight:FontWeight.bold,
                  fontFamily:'AlfaSlabOne' ),),
                ),
                SizedBox(width: size.width*0.05,),
                GestureDetector(
                  onTap: () => {
                    GoRouter.of(context).go('/Info')
                  },
                  child: Text('Info',style: TextStyle(color: Colors.black,
                  fontSize: size.height*0.02,fontWeight:FontWeight.bold,
                  fontFamily:'AlfaSlabOne' ),),
                )
              ],),
              SizedBox(height: size.height*0.1,),
            //  Expanded(
            //    child: ListView.builder(
            //     itemCount: list.length,
            //     itemBuilder: (context, index) {
            //       return Column(children: list,);
            //     },
            //    ),
            //  ),
             StreamBuilder(
                  stream: ref.child('${1}').orderByKey().limitToLast(10).onValue,
                  builder: (context, snapshot) {
                    List<ListTile> tiles = [];
                    if(snapshot.hasData &&
                      snapshot.data != null &&
                      (snapshot.data! as DatabaseEvent).snapshot.value !=
                          null
                    ){
                      final myorders = snapshot.data!.snapshot.value as Map<dynamic,dynamic>?;
                      myorders!.forEach((key, value) {
                        final nextorder = Map<dynamic,dynamic>.from(value);
                        final ordertile=ListTile(
                          subtitle: IconButton(onPressed: () => ref.child('${1}').push().set({'value':'${1}'}), icon: Icon(Icons.add)),
                          title: Text(nextorder['value']),
                        );
                        tiles.add(ordertile);
                      });
                      return Flexible(
                        child: ListView(
                          children: tiles,
                        ),
                      );
                      
                    }else{
                      return Text('Empty');
                    }
                   
                  },),
            
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
              
             ref.child('${1}').push().set({'value':'${count}'});
              count +=1;
        } ,),
            FloatingActionButton(
              heroTag: 'p',
              onPressed: () {
          signOut();
          
        } ,),
          ],
        );
      }
    );
  }

}

Future signOut() async{
  FirebaseAuth.instance.signOut();

}