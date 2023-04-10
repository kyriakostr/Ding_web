import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/models/Statistics/CompareStats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompareStatsScreen extends StatefulWidget {
  User? user;
  CompareStatsScreen({super.key,this.user});

  @override
  State<CompareStatsScreen> createState() => _CompareStatsScreenState();
}

class _CompareStatsScreenState extends State<CompareStatsScreen> {
  static const Choices = ['With ΦΠΑ','Without ΦΠΑ'];
  String selectedvalue=Choices.first;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseManager(displayName: widget.user?.displayName).compareyear,
      builder: (context, snapshot) {
        if(snapshot.hasData)
        return Column(
          children: [
           
            diagramm(snapshot.data!)
          ],
        );
        else
        return Container();
      },
    );
  }
  
  Widget diagramm(List<CompareYearStats> data){
   
        return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                height: 300,
                width: 300,
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Profits by year'),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Year')
                  ),
                  primaryYAxis: NumericAxis(title: AxisTitle(text: 'EUROS')),
                  series: <ChartSeries> [
                    StackedColumnSeries<CompareYearStats,double>(dataSource: data,
                     xValueMapper: (CompareYearStats x, index) => double.parse(x.year!) ,
                      yValueMapper: (CompareYearStats y, index) =>double.parse(y.income.toString()),
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      )
                  ],
                )
              ),
            );
     
  }
}

// BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.center,
//               maxY: 2000,
//               minY: 0,
//               barTouchData: BarTouchData(enabled: true),
//               barGroups: snapshot.data?.map(
//                 (e) => BarChartGroupData(x: int.parse(e.year!
//                 ),barRods: [
//                   BarChartRodData(
//                     toY: double.parse(e.income.toString())
//                     )
//                 ]
//                 )).toList()
//             )
//           ),