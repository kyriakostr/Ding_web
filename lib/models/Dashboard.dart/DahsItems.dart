import 'package:ding_web/Screens/DashboardPages/EditMenu.dart';
import 'package:ding_web/Screens/DashboardPages/Statistics.dart';
import 'package:ding_web/models/Dashboard.dart/Dahsitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashitems{

//  static const Data_analysis = Dashitem(title: 'Data analysis',icon: Icons.data_exploration);
 static const Documents = Dashitem(title: 'Documents',icon: Icons.document_scanner_sharp);
 static const Service = Dashitem(title: 'Service Accounts',icon: Icons.people);
 static const Settings = Dashitem(title: 'Settings',icon: Icons.settings);
 static const EditMenu = Dashitem(title: 'Edit Menu',icon: Icons.edit_attributes);
 static const Statistics = Dashitem(title: 'Statistics',icon: Icons.percent);
 static const UpgradeMenu = Dashitem(title: 'Upgrade Menu',icon: Icons.upgrade);


 List<Dashitem> dashitems = [
  // Data_analysis,
  EditMenu,
  UpgradeMenu,
  Documents,
  Service,
  Settings,
  Statistics
 ];

}