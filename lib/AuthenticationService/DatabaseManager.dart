

import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/Screens/OrderPages/Temp.dart';
import 'package:ding_web/Screens/Statistics/YearStats.dart';
import 'package:ding_web/Utils.dart';
import 'package:ding_web/models/Business.dart';

import 'package:ding_web/models/Menuitem.dart';

import 'package:ding_web/models/SerciveAccount.dart';
import 'package:ding_web/models/Statistics/CompareStats.dart';
import 'package:ding_web/models/Statistics/DayStatistics.dart';
import 'package:ding_web/models/Statistics/MonthStatistics.dart';
import 'package:ding_web/models/Statistics/YearStats.dart';
import 'package:ding_web/models/Tabledata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';



class DatabaseManager{
  String? year;
  String? month;
  String? displayName;
  String? uid;
  String? category;
  DatabaseManager({this.displayName,this.uid,this.year,this.month,this.category});

  CollectionReference collection = FirebaseFirestore.instance.collection('Business');

  
  late DatabaseReference ref;
String setmonth(String date){
  switch(date){
    case '01':
    return 'January';
    case '02':
    return 'February';
    case '03':
    return 'March';
    case '04':
    return 'April';
    case '05':
    return 'May';
    case '06':
    return 'June';
    case '07':
    return 'July';
    case '08':
    return 'August';
    case '09':
    return 'September';
    case '10':
    return 'October';
    case '11':
    return 'November';
    case '12':
    return 'December';
    default:
    return '0';
  }
}
  Future update(String email,String password,List<Tabledata> data )async{
    final id =  collection.doc(displayName).collection('Services').where('email',isEqualTo: email );
    final k = await id.get();
    final referenceid = k.docs.first.reference.id;
    await collection.doc(displayName).collection('Services').doc(referenceid).update({'password':password,});
    await collection.doc(displayName).collection('Services').doc(referenceid).update({'tables':[]});
    data.sort(((a, b) => a.number.compareTo(b.number)));
    data.forEach((element) async{
      await collection.doc(displayName).collection('Services').doc(referenceid).update({'tables':FieldValue.arrayUnion([element.number])});
    });
  }

  Future set(String firstname,String lastname,String email,String password,String duty,int phonenumber) async{
    await collection.doc(displayName).collection('Services').doc().set({
      'first name':firstname,
      'last name':lastname,
      'email': email,
      'duty':duty,
      'password':password,
      'phone':phonenumber
    });
    
  }

  Stream<Map<String,List<Menuitem>>> get menuitem => collection.doc(displayName).
  collection('Menus').doc(uid).snapshots().map((event) {
    Map<String,List<Menuitem>> menu={};
    final map = event.data();
    map?.forEach((key, value) {
      final temp = value as Map<String,dynamic>;
      List<Menuitem> list = [];
      temp.forEach((name, details) {
        // print(name);
       if(name!='VAT' && name!='role'){
         final item = Menuitem(name: name,disabled: details['disabled'],price: details['price'].toString(),VAT: value['VAT']);
        // print(item.name);
        list.add(item);
       }
      });
      menu.addAll({key:[]});
      list.sort((a, b) => a.name!.compareTo(b.name!),);
      list.forEach((element) {menu[key]?.add(element);});
    });
    // menu.forEach((key, value) {
    //   value.forEach((element) {print(element.name);});
    // });
    menu= Map.fromEntries(menu.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    return menu;
  }
  );
  Stream<double> get VAT => collection.doc(displayName).
  collection('Menus').doc(uid).snapshots().map((event) {
    
    final map = event.data()?[category];
    return double.parse(map['VAT'].toString());
   
  }
  );

  Future delete(String email,) async{
    final id =  collection.doc(displayName).collection('Services').where('email',isEqualTo: email );
    final k = await id.get();
    final referenceid = k.docs.first.reference.id;
    await collection.doc(displayName).collection('Services').doc(referenceid).delete();
    
  }
  Future setyear() async{
     
    final business = await FirebaseFirestore.instance.collection('Business').doc(displayName).get();
    
    final doc = collection.doc(displayName).collection('Logistics').doc(year);
    final k = await doc.get();
    print(k.data());
    if(!k.exists){
      collection.doc(displayName).collection('Logistics').doc(year).set({
      setmonth(DateFormat('MM').format(DateTime.now())):
        {
          DateFormat('dd-MM-yyyy').format(DateTime.now()):{
            'tziros':0,
            'category preferences':{},
            'item preferences':{},
            
          }
        }
        
      
    });
    }else if(k.data()==null || k.data()!.isEmpty){
       collection.doc(displayName).collection('Logistics').doc(year).set({
      setmonth(DateFormat('MM').format(DateTime.now())):
        {
          DateFormat('dd-MM-yyyy').format(DateTime.now()):{
            'tziros':0,
            'category preferences':{},
            'item preferences':{},
            
          }
        }

    },SetOptions(merge: true));
    }
    else if(k.data()?[setmonth(DateFormat('MM').format(DateTime.now()))]==null || 
    k.data()?[setmonth(DateFormat('MM').format(DateTime.now()))][DateFormat('dd-MM-yyyy').format(DateTime.now())]==null ){
       collection.doc(displayName).collection('Logistics').doc(year).set({
      setmonth(DateFormat('MM').format(DateTime.now())):
        {
          DateFormat('dd-MM-yyyy').format(DateTime.now()):{
            'tziros':0,
           'category preferences':{},
            'item preferences':{},
            
          }
        }

    },SetOptions(merge: true));
    }
    
    
  }
  
  
  Future settabledata(int table) async{
    await collection.doc(displayName).update({'Number of Tables':table});
  }
  Future setFPA(double fpa) async{
    await collection.doc(displayName).update({'fpa':fpa});
    await collection.doc(displayName).collection('Logistics').doc(DateFormat('yyyy').format(DateTime.now())).
    update({
      '${setmonth(DateFormat('MM').format(DateTime.now()))}.${DateFormat('dd-MM-yyyy').format(DateTime.now())}.fpa':
      
        fpa
      
    });
  }
  Future<bool> read() async{
     final db = FirebaseFirestore.instance.collection('Business').doc(displayName!);
     final snapshot = await db.get();
     print(snapshot.data());
     return snapshot.data()!.isNotEmpty;
  }

   Stream<List<ServiceAccount>?> get Servicedata{
    final db = collection.doc(displayName).collection('Services').snapshots();
    return db.map((snapshot) => snapshot.docs.map((doc) => ServiceAccount.fromJson(doc.data())).toList());
  }

  Stream<Business> get Businessdata=>collection.doc(displayName).snapshots().map((event) =>
  Business(email: event.get('email'),number_of_tables: event.get('Number of Tables'),));

  Stream<List<Tabledata>> get tabledata => FirebaseDatabase.instance.ref().child(displayName!).onValue.
  map((event) => event.snapshot.children.map((e) => Tabledata(number:int.parse(e.key.toString()))).toList());

  
  Future signinwithFacebook()async{
  try{
    final LoginResult result = await FacebookAuth.instance.login();
    
    final OAuthCredential facebookauthcredential = FacebookAuthProvider.credential(result.accessToken!.token);
    FacebookAuthProvider().setCustomParameters({"consent":"select_account"});
    
    await FirebaseAuth.instance.signInWithCredential(facebookauthcredential);
  }on FirebaseAuthException catch(e){
    Utils().showSnackBar(e.message);
   await FacebookAuth.instance.logOut();
  }
}
Future setLogistics(String year,String month,String datetime)async{
  final db = collection.doc(displayName).collection('Logistics').doc(year);
  db.set({month:{datetime:{}}});
  
}
Stream<List<String>> get years{
  return collection.doc(displayName).collection('Logistics').snapshots().map((event) => 
  event.docs.map((e) => e.id).toList());
}
Stream<List<String>> get months{
  return collection.doc(displayName).collection('Logistics').doc(DateFormat('yyyy').
  format(DateTime.now())).snapshots().map((event) {
    final data = event.data();
    return data!.keys.toList();
  });
}
Stream<Daystatistics> get daystatistics{
  return collection.doc(displayName).collection('Logistics').doc(DateFormat('yyyy').
  format(DateTime.now())).snapshots().map((event) {
    final data = event.data();
    String income = '';
    data?.forEach((month, value) {
      final temp = value as Map<String,dynamic>;
      
      temp.forEach((key_2, dayincome) {
        if(key_2==DateFormat('dd-MM-yyyy').
            format(DateTime.now())){
          final temp = dayincome as Map<String,dynamic>;
          income = temp['tziros'].toString();
        }
      });
    });
    return Daystatistics(income: double.parse(income));
  });
}
Stream<List<CompareYearStats>> get compareyear{
  return collection.doc(displayName).collection('Logistics').snapshots().
  map((event) =>
    
     event.docs.map((e) {
  
   final data = e.data();
   double yearincome = 0;
   double yearincome_with_fpa = 0;
   
   double fpa = 0;
     data.forEach((month, value) {
      final temp = value as Map<String,dynamic>;
      double monthincome = 0;
      double monthincomewithfpa = 0 ;
      temp.forEach((key_2, dayincome) {
        // final text = dayincome.toString().split(':').last;
        // final income = text.split('}').first;
        //  fpa = double.parse(dayincome['fpa'].toString());
       
        monthincome+=double.parse(dayincome['tziros'].toString());
        
        // print(monthincomewithfpa);
        
      });
      
     yearincome+=monthincome;
     
    });
   
    final compstats = CompareYearStats(year: e.id,income: yearincome,);
    
  return compstats;
  }).toList()
  
  );
}
Stream<List<SearchYearStats>> get yearstats{
 return collection.doc(displayName).collection('Logistics').snapshots().
  map((event) =>
    
     event.docs.map((e) {
   
   
   final data = e.data();
   
     data.forEach((month, value) {
      final temp = value as Map<String,dynamic>;
      List<Daystatistics> daystatistics = [];
      temp.forEach((key_2, dayincome) {
        final text = dayincome['tziros'].toString();
        final income = double.parse(text);
        final daystat = Daystatistics(date: key_2,income: income);
        daystatistics.add(daystat);

      });

     
    });
    final current_year = SearchYearStats(year: e.id,);
    return current_year;
  }).toList()
  
  );
}
Stream<List<MonthStatistics>> get yearstatistics{
  List<String> dates = [
      'January','February','March','April','May','June','July',
      'August','September','October','November','December'
    ];
  return collection.doc(displayName).collection('Logistics').
  doc(year).snapshots().map((event) {
    final data = event.data();
    List<MonthStatistics> monthstatistics = [];
    data?.forEach((month, value) {
      final temp = value as Map<String,dynamic>;
      double monthincome = 0;
      temp.forEach((key_2, dayincome) {
       
        final income = dayincome['tziros'];
        monthincome+=double.parse(income.toString());
      });
      final indexofmonth = dates.indexOf(month);
      final monthstats = MonthStatistics(month: month,income: monthincome,indexofmonth: indexofmonth+1);
      monthstatistics.add(monthstats);
    });
    monthstatistics.sort((a, b) => a.indexofmonth!.compareTo(b.indexofmonth!),);
    return monthstatistics;
  });
}
Stream<List<Daystatistics>> get monthstatistics{
  
  return collection.doc(displayName).collection('Logistics').doc(DateFormat('yyyy').
  format(DateTime.now())).snapshots().map((event) {
    final data = event.data()?[month];
    
    List<Daystatistics> day = [];
    data?.forEach((key, value) {
      
      
     
      final income = double.parse(value['tziros'].toString());
      final stats = Daystatistics(date: key,income:income);
      
      day.add(stats);
      day.sort((a, b) => a.date!.compareTo(b.date!),);
     
      
    });
    return day;
    });
}
Stream<List<Daystatistics>> get searchmonthstatistics{
  
  return collection.doc(displayName).collection('Logistics').doc(year).snapshots().map((event) {
    final data = event.data()?[month];
    
    List<Daystatistics> day = [];
    double monthincome = 0;
  
    data?.forEach((date, value) {
      final income = value['tziros'];
      
      
    
      final stats = Daystatistics(date: date,income:double.parse(income.toString()),);
      
      day.add(stats);
      day.sort((a, b) => a.date!.compareTo(b.date!),);
     
      
    });
    return day;
    });
}
Stream<Map<String,double>> get monthpiechart{
  return collection.doc(displayName).collection('Logistics').doc(year).snapshots().map((event) {
    final data = event.data()?[month];
    
    
    
    Map<String,double> preferences={};
    data?.forEach((date, value) {
     
      
      if(value['category preferences']==null) return;
      else{
         final dbpreferences = value['category preferences'] as Map<String,dynamic>;
      
        dbpreferences.forEach((key, price) {
          double income = double.parse(price.toString());
          if(preferences[key.trim()]==null) preferences[key]=income;
          else
          preferences.update(key.trim(), (double) => preferences[key.trim()]! + income);
        });
       
      }
     
      
     print(preferences);
      
     
      
    });
    return preferences;
    });
}
Stream<Map<String,double>> get monthpiechart_2{
  return collection.doc(displayName).collection('Logistics').doc(year).snapshots().map((event) {
    final data = event.data()?[month];
    
    
    
    Map<String,double> preferences={};
    data?.forEach((date, value) {
     
      
      if(value['item preferences']==null) return;
      else{
         final dbpreferences = value['item preferences'] as Map<String,dynamic>;
      
        dbpreferences.forEach((key, price) {
          double income = double.parse(price.toString());
          if(preferences[key.trim()]==null) preferences[key]=income;
          else
          preferences.update(key.trim(), (double) => preferences[key.trim()]! + income);
        });
       
      }
     
      
     print(preferences);
      
     
      
    });
    return preferences;
    });
}

Stream<Map<String,double>> get yearpiechart{
  return collection.doc(displayName).collection('Logistics').doc(year).snapshots().map((event) {
    final data = event.data();
    
    
    
    Map<String,double> preferences={};
    data?.forEach((month, value) {
     final temp = value as Map<String,dynamic>;
      print(month);
      temp.forEach((key, value) {
        if(value['category preferences']==null) return;
      else{
         final dbpreferences = value['category preferences'] as Map<String,dynamic>;
      
        dbpreferences.forEach((key, price) {
          double income = double.parse(price.toString());
          if(preferences[key.trim()]==null) preferences[key]=income;
          else
          preferences.update(key.trim(), (double) => preferences[key.trim()]! + income);
        });
       
      }
      },);
       
      
     
      
     print(preferences);
      
     
      
    });
    return preferences;
    });
}

Stream<Map<String,double>> get yearpiechart_2{
  return collection.doc(displayName).collection('Logistics').doc(year).snapshots().map((event) {
    final data = event.data();
    
    
    
    Map<String,double> preferences={};
    data?.forEach((month, value) {
     final temp = value as Map<String,dynamic>;
      print(month);
      temp.forEach((key, value) {
        if(value['item preferences']==null) return;
      else{
         final dbpreferences = value['item preferences'] as Map<String,dynamic>;
      
        dbpreferences.forEach((key, price) {
          double income = double.parse(price.toString());
          if(preferences[key.trim()]==null) preferences[key]=income;
          else
          preferences.update(key.trim(), (double) => preferences[key.trim()]! + income);
        });
       
      }
      },);
       
      
     
      
     print(preferences);
      
     
      
    });
    return preferences;
    });
}
  
  Future googlesignin() async{
  try{

    final googlesignin = GoogleSignIn();
  GoogleSignInAccount? user;
  
  final googleuser = await googlesignin.signIn();
  if(googleuser==null) return;
  user = googleuser;

  final googleauth = await googleuser.authentication;

  final credential = GoogleAuthProvider.credential(idToken: googleauth.idToken,accessToken: googleauth.accessToken);
  await FirebaseAuth.instance.signInWithCredential(credential);

  final doc=FirebaseFirestore.instance.collection('Business').where('email',isEqualTo:googleuser.email);
  final snapshot = await doc.get();
  if(snapshot.docs.isNotEmpty) {
    final id = snapshot.docs.first.reference.id;
    
    await FirebaseAuth.instance.currentUser?.updateDisplayName(id);
  }
  




  }on FirebaseAuthException catch(e){
    Utils().showSnackBar(e.message);
  }
  
  


}
  }
