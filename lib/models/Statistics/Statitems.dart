import 'package:ding_web/models/Dashboard.dart/Dahsitem.dart';
import 'package:ding_web/models/Statistics/CompareStats.dart';
import 'package:ding_web/models/Statistics/Statitem.dart';
import 'package:flutter/material.dart';

class Statsitems{

//  static const Data_analysis = Dashitem(title: 'Data analysis',icon: Icons.data_exploration);
 static const Day = Statitem(title: 'Day');
 static const Month = Statitem(title: 'Month');
 static const Year = Statitem(title: 'Year');
 static const CompareYearStats = Statitem(title: 'Compare Year Stats');
 static const Search = Statitem(title: 'Search');



 List<Statitem> statsitems = [
  // Data_analysis,
  Day,
  Month,
  Year,
  CompareYearStats,
  Search
 ];

}