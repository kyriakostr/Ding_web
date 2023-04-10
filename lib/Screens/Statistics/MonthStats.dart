import 'package:ding_web/AuthenticationService/DatabaseManager.dart';
import 'package:ding_web/Screens/Statistics/MonthPiechart_2.dart';
import 'package:ding_web/Screens/Statistics/Monthpiechart.dart';
import 'package:ding_web/models/Statistics/DayStatistics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthStats extends StatelessWidget {
  
  String month;
  MonthStats({super.key,required this.month});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
     Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: DatabaseManager(displayName: user!.displayName,month: month).monthstatistics,
      builder: (context, snapshot) {
        if(snapshot.hasData){
         
           return Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
              children: [
                Text(DateFormat('yyyy').format(DateTime.now()),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                Container(
                  color: Colors.white,
                  height: 200,
                  width: size.width*0.5,
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
                  )
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MonthPiechart(user: user,year: DateFormat('yyyy').format(DateTime.now()),month: month,),
                    MonthPiechart_2(user: user,year: DateFormat('yyyy').format(DateTime.now()),month: month,)
                  ],
                )
                ],
             ),
           );
        }else{
          return Container();
        }
      },);
  }
}
// LineChart(
//                     LineChartData(
//                       maxY: 1000,
//                       minY: 0,
//                       maxX: double.parse(snapshot.data!.length.toString())*2,
//                       lineBarsData: [LineChartBarData(
//                       spots: snapshot.data?.map((e) { 
                        
//                         return FlSpot(double.parse(snapshot.data!.indexOf(e).toString())+1, e.income!) ;
//                         }
//                       ).toList(),
//                       isCurved: true,
//                       dotData: FlDotData(show: true))]
//                       )
//                   ),