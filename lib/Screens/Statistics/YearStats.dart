import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/models/Statistics/MonthStatistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearStats extends StatelessWidget {
  String? year;
  YearStats({super.key,required this.year});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    double max = 0;
    return StreamBuilder(
      stream: DatabaseManager(displayName: user?.displayName,year: year ).yearstatistics,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          snapshot.data?.forEach((element) {
            if(element.income!>max) max = element.income!;
          },);
         return Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(
                    color: Colors.white,
                    height: 200,
                    width: 400,
                    child: SfCartesianChart(
                    title: ChartTitle(text: 'Profits of  ${year}'),
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(text: 'Month')
                    ),
                    primaryYAxis: NumericAxis(title: AxisTitle(text: 'EUROS')),
                    series: <ChartSeries>[
                      LineSeries<MonthStatistics,String>(
                      dataSource: snapshot.data!,
                      xValueMapper: (datum, index) => datum.month,
                      yValueMapper: (datum, index) => datum.income,
                      dataLabelSettings: DataLabelSettings(isVisible: true),)
                    ]
                  )
                  ),
         );
        }else
        return Container();
      },);
  }
}
// LineChart(
//                       LineChartData(
//                         maxY: max*2 ,
//                         minY: 0,
//                         maxX: double.parse(snapshot.data!.length.toString())*2,
//                         lineBarsData: [LineChartBarData(
//                         spots: snapshot.data?.map((e) { 
                          
//                           return FlSpot(double.parse(e.indexofmonth.toString()), e.income!) ;
//                           }
//                         ).toList(),
//                         isCurved: true,
//                         dotData: FlDotData(show: true))]
//                         )
//                     ),