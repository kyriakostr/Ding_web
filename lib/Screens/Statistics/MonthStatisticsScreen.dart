import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/Statistics/MonthStats.dart';
import 'package:ding_web/models/Statistics/DayStatistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MonthStatisticsScreen extends StatefulWidget {
  User? user;
  
  MonthStatisticsScreen({super.key,this.user,});

  @override
  State<MonthStatisticsScreen> createState() => _MonthStatisticsScreenState();
}

class _MonthStatisticsScreenState extends State<MonthStatisticsScreen> {
  String month='';
  @override
  Widget build(BuildContext context) {
    
    double i =0;
    String? selectedyear;
    return StreamBuilder(
      stream: DatabaseManager(displayName: widget.user?.displayName).months,
      builder:(context, snapshot) {
        if(snapshot.hasData){
          return  Column(
            children: [
              DropdownButtonFormField(
                      
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: 'Month'),
                      items: snapshot.data!.map((e) =>DropdownMenuItem(
                        value: e,
                        child: Text(e))).toList(), onChanged: (value) {
                          setState(() {
                            month=value!;
                            
                          });
                       
                    },),
                    MonthStats(month: month)
                    
            ],
          );
        }else{
          return Container();
        }
        
       
  });
  }
}