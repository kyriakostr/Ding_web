import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/Statistics/CompareStatsScreen.dart';
import 'package:ding_web/Screens/Statistics/DaystatisticsScreen.dart';
import 'package:ding_web/Screens/Statistics/MonthStatisticsScreen.dart';
import 'package:ding_web/Screens/Statistics/SearchScreen.dart';
import 'package:ding_web/Screens/Statistics/YearStatisticsScreen.dart';
import 'package:ding_web/models/Statistics/DayStatistics.dart';
import 'package:ding_web/models/Statistics/Statitem.dart';
import 'package:ding_web/models/Statistics/Statitems.dart';
import 'package:ding_web/models/Statistics/Statslisttile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Statitem item = Statsitems().statsitems.first;
  int tappedIndex=0;
  double i =0;
  final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now()).split('-');
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    
    return Row(
      children: [
        Expanded(
          
          child: Container(
            width: 50,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Statsitems().statsitems.length,
              itemBuilder: (context, index) {
                final current_stat = Statsitems().statsitems[index];
                return Container(
                        
                        decoration: BoxDecoration(borderRadius:BorderRadius.circular(30),color: tappedIndex==index?Colors.orange[800]:Colors.transparent,),  
                        child: StatsListtile(statitem: current_stat,index: index,onselected: (item){
                          setState(() {
                            this.item=item;
                          });
                        },tappedindex: (value) {
                          setState(() {
                            this.tappedIndex = value;
                          });
                        },),
                      );
              },),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          flex: 5,
          child: selectitem(item))
      ],
    );

    
  }
  Widget selectitem(Statitem item){
    switch(item){
      // case Dashitems.Data_analysis:
      //   return Text('Data analysis');
      case Statsitems.Search:
        return SearchScreen();
      case Statsitems.CompareYearStats:
        return CompareStatsScreen(user: user,);
      case Statsitems.Day:
        return DaystatisticsScreen(user: user);
      case Statsitems.Year:
         return Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: YearStatisticsScreen(user: user,),
        );
      case Statsitems.Month:
        return Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: MonthStatisticsScreen(user: user,),
        );
      default:
       return Text('data');
    }
  }

 
}