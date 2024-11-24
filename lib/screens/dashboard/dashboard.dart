import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management_web/services/apis/holidays.dart';
import 'package:pass_slip_management_web/utils/palettes.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:table_calendar/table_calendar.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    // TODO: implement initState
    holidayServices.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("USERS CHART",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: _piechart(data: {
                            "Active": 10,
                            "Inactive": 3,
                          },icon: Icons.people_alt_outlined, colorList: [
                            palettes.blue,
                            Colors.grey.shade400
                          ],border: palettes.blue),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("PASS SLIP CHART",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: _piechart(data: {
                            "Pending": 10,
                            "Accepted": 33,
                            "Declined": 5,
                            "Expired": 3,
                          },icon: Icons.description_outlined, colorList: [
                            Colors.orange,
                            palettes.darkblue,
                            Colors.grey.shade400,
                            Colors.redAccent
                          ],border: palettes.darkblue),
                        ),
                      ],
                    ),
                    Container(
                      width: 500,
                      child: TableCalendar(
                        daysOfWeekVisible: false,
                        rowHeight: 67,
                        firstDay: DateTime.utc(2000, 1, 1),
                        lastDay: DateTime.utc(2090, 1, 1),
                        focusedDay: DateTime.now(),
                        calendarStyle: CalendarStyle(
                          weekendTextStyle: TextStyle(color: Colors.red,fontFamily: "regular"),
                          todayDecoration: BoxDecoration(
                              color: palettes.blue,
                            borderRadius: BorderRadius.circular(1000)
                          ),
                          todayTextStyle: TextStyle(color: Colors.white,fontFamily: "regular"),
                          defaultTextStyle: TextStyle(color: Colors.black,fontFamily: "regular"),
                          holidayTextStyle: TextStyle(color: Colors.blue)
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Daily Monitoring",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 2),),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 50),
                child: charts.SfCartesianChart(
                    primaryXAxis: charts.CategoryAxis(
                      labelStyle: TextStyle(fontSize: 15)
                    ),
                    primaryYAxis: charts.NumericAxis(minimum: 0, maximum: 40, interval: 10,),
                    tooltipBehavior: charts.TooltipBehavior(enable: true),
                    series: <charts.CartesianSeries<_ChartData, String>>[
                      charts.ColumnSeries<_ChartData, String>(
                          dataSource: [
                            _ChartData('20 Nov, 2024', 12),
                            _ChartData('21 Nov, 2024', 15),
                            _ChartData('22 Nov, 2024', 30),
                            _ChartData('23 Nov, 2024', 6.4),
                            _ChartData('24 Nov, 2024', 2),
                            _ChartData('25 Nov, 2024', 14)
                          ],
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Accepted',
                          color: palettes.darkblue),
                      charts.ColumnSeries<_ChartData, String>(
                          dataSource: [
                            _ChartData('20 Nov, 2024', 56),
                            _ChartData('21 Nov, 2024', 22),
                            _ChartData('22 Nov, 2024', 55),
                            _ChartData('23 Nov, 2024', 77),
                            _ChartData('24 Nov, 2024', 6),
                            _ChartData('25 Nov, 2024', 9)
                          ],
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Declined',
                          color: Colors.grey.shade400)
                    ])
              )
            ),
          ],
        ),
      )
    );
  }
  Widget _piechart({required Map<String, double> data, required IconData icon, required List<Color> colorList, required Color border}){
    return PieChart(
      dataMap: data,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      emptyColor: Colors.grey.shade300,
      centerWidget: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(color: border)
        ),
        padding: EdgeInsets.all(15),
        child: Icon(icon,size: 45,color: border,),
      ),
      legendOptions: LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        chartValueBackgroundColor: Colors.transparent,
        chartValueStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
