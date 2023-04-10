import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/Statistics/Searchmonth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> years = [];
  List<String> months = [
      'January','February','March','April','May','June','July',
      'August','September','October','November','December'
    ];
  String? year;
  String? month;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: DatabaseManager(displayName: user?.displayName).yearstats,
      builder:(context, snapshot) {
        snapshot.data?.forEach((element) {
          print(element.year);
          if(!years.contains(element.year))
          years.add(element.year!);
          
        },);
        return Container(
        child: Column(
          children: [
            
            years.length>1 ?
            DropdownButtonFormField(
                        value: year,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: 'Year'),
                        items: years.map((e) =>DropdownMenuItem(
                          value: e,
                          child: Text(e))).toList(), onChanged: (value) {
                            setState(() {
                              year = value;
                              
                            });
                         
                      },) : DropdownButtonFormField(
                        value: year,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: 'Year'),
                        items: years.map((e) =>DropdownMenuItem(
                          value: e,
                          child: Text(e))).toList(), onChanged: (value) {
                            setState(() {
                              year = value;
                              
                            });
                         
                      },),
          SizedBox(height: 50,),
          months.length>1 ?
          DropdownButtonFormField(
                        value: month,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: 'Month'),
                        items: months.map((e) =>DropdownMenuItem(
                          value: e,
                          child: Text(e))).toList(), onChanged: (value) {
                            setState(() {
                              month = value;
                              
                            });
                         
                      },) : Container(),
                      SearchMonth(month: month,year: year,user: user,)

        ]),
      );
      }
       
    );
  }
}