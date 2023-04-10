import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/Statistics/YearPiechart.dart';
import 'package:ding_web/Screens/Statistics/YearPiechart_2.dart';
import 'package:ding_web/Screens/Statistics/YearStats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class YearStatisticsScreen extends StatefulWidget {
  User? user;
  YearStatisticsScreen({super.key,required this.user});

  @override
  State<YearStatisticsScreen> createState() => _YearStatisticsScreenState();
}

class _YearStatisticsScreenState extends State<YearStatisticsScreen> {
  String? year;
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return StreamBuilder(
      stream: DatabaseManager(displayName:user?.displayName).years,
      builder:(context, snapshot) {
        if(snapshot.hasData){
        
          if(snapshot.data!.length>1)
          return  Column(
            children: [
              DropdownButtonFormField(
                      value: year ,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: 'Year'),
                      items: snapshot.data!.map((e) =>DropdownMenuItem(
                        value: e,
                        child: Text(e))).toList(), onChanged: (value) {
                          setState(() {
                            
                            year=value!;
                          });
                       
                    },),
                    
                    YearStats(year: year),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      YearPieChart(year: year,user: user,),
                    YearPieChart_2(year: year,user: user,)
                    ],)
            ],
          );
          else if(snapshot.data?.length==1){
            return  Column(
            children: [
              DropdownButtonFormField(
                      value: year ,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: 'Year'),
                      items: snapshot.data!.map((e) =>DropdownMenuItem(
                        value: e,
                        child: Text(e))).toList(), onChanged: (value) {
                          setState(() {
                            
                            year=value!;
                          });
                       
                    },),
                    
                    YearStats(year: year),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      YearPieChart(year: year,user: user,),
                    YearPieChart_2(year: year,user: user,)
                    ],)
            ],
          );
          }
          else
            return Center(child: CircularProgressIndicator(),);
        }
        else{
          return Container();
        }
        
       
  });
  }
}