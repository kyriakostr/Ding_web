import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/Statistics/MonthPiechart_2.dart';
import 'package:ding_web/Screens/Statistics/Monthpiechart.dart';
import 'package:ding_web/models/Statistics/DayStatistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SearchMonth extends StatelessWidget {
  String? year;
  String? month;
  User? user;
  SearchMonth({super.key,this.month,this.year,this.user});
  Map<String,double> map = {};
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseManager(displayName: user?.displayName,year: year,month: month).searchmonthstatistics,
      builder:(context, snapshot){
       
        if(snapshot.hasData)
        
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
              color: Colors.white,
              height: 300,
              width: 300,
              child: SfCartesianChart(
                          title: ChartTitle(text: 'Profits of  ${month}'),
                          primaryXAxis: CategoryAxis(
                            title: AxisTitle(text: 'Date')
                          ),
                          primaryYAxis: NumericAxis(title: AxisTitle(text: 'EUROS')),
                          series: <ChartSeries>[
                            LineSeries<Daystatistics,String>(
                            dataSource: snapshot.data!,
                            xValueMapper: (datum, index) => datum.date,
                            yValueMapper: (datum, index) => datum.income,
                            dataLabelSettings: DataLabelSettings(isVisible: true),)
                          ]
                        ),
      ),
            ),
            SizedBox(
              height: 10,
            ),
            MonthPiechart(user: user,year: year,month: month,),
            MonthPiechart_2(user: user,year: year,month: month,)
          ],
        );
      else
        return Text('No data');
      } 
       
    );
  }
}