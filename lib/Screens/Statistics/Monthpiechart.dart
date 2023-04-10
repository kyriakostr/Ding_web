import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pie_chart/pie_chart.dart';

class MonthPiechart extends StatelessWidget {
  User? user;
  String? year;
  String? month;
  MonthPiechart({super.key,this.user,this.month,this.year});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseManager(displayName: user?.displayName,year: year,month: month).monthpiechart,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data!.isNotEmpty)
        return Container(
          child: PieChart(dataMap: snapshot.data!,
          chartRadius: 200 ,
          legendOptions: LegendOptions(legendPosition: LegendPosition.bottom),
          chartValuesOptions: ChartValuesOptions(showChartValuesInPercentage: true),),
        );
        else
        return Container();
        }
        
        else{
          return Container();
        }
        
      },);
  }
}