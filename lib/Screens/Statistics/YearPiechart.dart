import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pie_chart/pie_chart.dart';

class YearPieChart extends StatelessWidget {
  String? year;
  User? user;
   YearPieChart({super.key,this.year,this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseManager(displayName:user?.displayName ,year: year).yearpiechart ,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data!.isNotEmpty)
           return Container(
          child: PieChart(dataMap: snapshot.data!,
          chartRadius: 200 ,
          legendOptions: LegendOptions(legendPosition: LegendPosition.bottom),
          chartValuesOptions: ChartValuesOptions(showChartValuesInPercentage: true),),
        );
        else{
          return Container();
        }
        }else{
          return Container();
        }
       
      },
    );
  }
}