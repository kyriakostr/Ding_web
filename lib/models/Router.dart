
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/AuthenticationService/AuthenticationService.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/AuthenticatePages/ChoosePlan.dart';
import 'package:ding_web/Screens/AuthenticatePages/SetBusinessData.dart';
import 'package:ding_web/Screens/HomePages/Home.dart';
import 'package:ding_web/Screens/DashboardPages/Dashboard.dart';
import 'package:ding_web/Screens/Infos/AboutusPage.dart';
import 'package:ding_web/Screens/Infos/BusinessInfoPage.dart';
import 'package:ding_web/Screens/Infos/CustomerInfoPage.dart';
import 'package:ding_web/Screens/Success.dart';
import 'package:ding_web/models/Orders/List.dart';
import 'package:ding_web/Screens/Infos/Info.dart';
import 'package:ding_web/models/Orders/Order.dart';
import 'package:ding_web/models/Orders/Tempdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyRouter extends ChangeNotifier {
  
  final router = GoRouter(

urlPathStrategy: UrlPathStrategy.path,
initialLocation: '/',
routes: [
  GoRoute(
    path: '/',
    name: 'Home',
  pageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Home()),),
    GoRoute(
      name: 'Authentication',
      path: '/Authentication',
  pageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: AuthenticationService()),
     routes: [
        GoRoute(
          name: 'Details',
          path: 'number_of_table',
        pageBuilder: (context, state) { 
          final order = orders;
          
          return MaterialPage(
          key: state.pageKey,
          child:  MyWidget(order: order,), 
          
            );}),
            GoRoute(
              name: 'ChoosePlan',
              path: 'ChoosePlan',
              pageBuilder: (context, state) {
             return  MaterialPage(
            key: state.pageKey,
            child:  ChoosePlan(), 
          
            );
              },),
            GoRoute(
          name: 'BusinessData',
          path: 'Setbusinessdata',
        pageBuilder: (context, state) { 
          
          
          return MaterialPage(
          key: state.pageKey,
          child: SetBusinessData(), 
          
            );}),
           
            GoRoute(
          name: 'Success',
          path: 'success',
        pageBuilder: (context, state) { 
          
          
          return MaterialPage(
          key: state.pageKey,
          child: SuccessPage(),
          
            );}),
             
            GoRoute(
          name: 'Dashboard',
          path: 'Dashboard',
        pageBuilder: (context, state) { 
          
          
          return MaterialPage(
          key: state.pageKey,
          child:  Dashboard(), 
          
            );})

      ]
      ),
    GoRoute(path: '/Info',
    name: 'Info',
    pageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Info()),
      routes: [
        GoRoute(path: 'Aboutus',
        name:'Aboutus',
        pageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: AboutusPage()) ),
      GoRoute(path: 'CustomerInfo',
        name:'CustomerInfo',
        pageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: CustomerInfoPage()) ),
      GoRoute(path: 'BusinessInfo',
        name:'BusinessInfo',
        pageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: BusinessInfoPage()) )
      ]),
    
],

errorPageBuilder: (context, state) => 
MaterialPage(
  key: state.pageKey,
  child: Scaffold(body: 
  Center(child: Text(state.error.toString())),)),);
}

