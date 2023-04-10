import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class DaystatisticsScreen extends StatelessWidget {
  User? user;
  DaystatisticsScreen({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseManager(displayName:user?.displayName ).daystatistics,
      builder: (context, snapshot) {
        if(snapshot.hasData)
      return  Container(
        child: Center(
          child: Column(
            children: [
              Text(DateFormat('dd-MM-yyyy').format(DateTime.now()),style: TextStyle(
                fontSize: 25,
                fontFamily: 'Montserrat',fontWeight: FontWeight.bold
              )),
              Text('Income of the day so far',style: TextStyle(
                fontSize: 25,
                fontFamily: 'Montserrat',fontWeight: FontWeight.bold
              ),),
              Text(snapshot.data!.income!.toStringAsFixed(2)+' Euros',style: TextStyle(
                fontSize: 25,
                fontFamily: 'Montserrat',fontWeight: FontWeight.bold
              ),),
            ],
          ),
        ),
      );
      else return Container();
      
      });
  }
}