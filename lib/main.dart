import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ding_web/AuthenticationService/AuthenticationService.dart';
import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/HomePages/Home.dart';
import 'package:ding_web/Screens/AuthenticatePages/AuthenticationPage.dart';
import 'package:ding_web/Screens/CustomerPage.dart';
import 'package:ding_web/Screens/Infos/Info.dart';
import 'package:ding_web/Screens/AuthenticatePages/Signup.dart';
import 'package:ding_web/Utils.dart';
import 'package:ding_web/models/Dashboard.dart/MenuController.dart';
import 'package:ding_web/models/Orders/Order.dart';
import 'package:ding_web/models/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await FacebookAuth.i.webAndDesktopInitialize(appId: '918115922900929', cookie: true, xfbml: true, version:'v14.0');
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCQtfUEdYHpniYJ206z7ntzSwHDFgmrk18", appId: "1:55153842864:web:60fdcb5ea85568dc073975",
       messagingSenderId: "55153842864", projectId: "ding-71bf2",
       storageBucket: "ding-71bf2.appspot.com",databaseURL: 'https://ding-71bf2-default-rtdb.europe-west1.firebasedatabase.app/'
 ) );
  runApp(MultiProvider(
    providers:  [
        StreamProvider<User?>.value(
        value: FirebaseAuth.instance.authStateChanges(),
        initialData: null,),
        ChangeNotifierProvider<MyRouter>(
          create: (BuildContext createContext) => MyRouter()),
        ChangeNotifierProvider(
            create: (_)=>Order()),
        ChangeNotifierProvider(create: (_)=>MenuController())
            
          
        
        ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = Provider.of<MyRouter>(context, listen: false).router;
    // final order = Provider.of<Order>(context);
   
    return MaterialApp.router(
              scaffoldMessengerKey: Utils.messengerkey,
              routerDelegate: router.routerDelegate  ,
              routeInformationParser: router.routeInformationParser,
             
              title: 'Ding',
              theme: ThemeData(
                // fontFamily: 'Montserrat',
                primarySwatch: Colors.blue,
              ),
             
              
            );
     
        
          
            
            
            
            
             
          
        
      
   
  }
}
// Order? order(BuildContext context){
//   return Provider.of<OrderModel>(context).order;
// }
// final router = GoRouter(

//             urlPathStrategy: UrlPathStrategy.path,
//             initialLocation: '/',
//             routes: [
//               GoRoute(
//                 path: '/',
//               pageBuilder: (context, state) => MaterialPage(
//                 key: state.pageKey,
//                 child: Home()),),
//                 GoRoute(
//                   path: '/Authentication',
//               pageBuilder: (context, state) => MaterialPage(
//                 key: state.pageKey,
//                 child: AuthenticationService()),
//                 routes: [
//                   GoRoute(
//                     name: 'Details',
//                     path: 'Details',
//                   pageBuilder: (context, state) => MaterialPage(
//                     key: state.pageKey,
//                     child: ChangeNotifierProvider<OrderModel>(create: (context) => OrderModel(),
//                     child: Details(),)
//                       ))

//                 ]
//                 ),
//                 GoRoute(path: '/Info',
//                 pageBuilder: (context, state) => MaterialPage(
//                   key: state.pageKey,
//                   child: Info()),)
//             ],

//             errorPageBuilder: (context, state) => 
//             MaterialPage(
//               key: state.pageKey,
//               child: Scaffold(body: 
//               Center(child: Text(state.error.toString())),)),);








