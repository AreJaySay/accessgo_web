import 'package:cell_calendar/cell_calendar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management_web/utils/palettes.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _users = FirebaseDatabase.instance.ref().child('users');
  var _requests = FirebaseDatabase.instance.ref().child('requests');
  var _events = FirebaseDatabase.instance.ref().child('events');
  final cellCalendarPageController = CellCalendarPageController();
  DateTime _current = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
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
                          StreamBuilder(
                            stream: _users.onValue,
                            builder: (context, snapshot) {
                              List? datas;

                              if(snapshot.hasData){
                                datas = (snapshot.data!.snapshot.value as Map).values.toList();
                              }

                              return Expanded(
                                child: Column(
                                  children: [
                                    Text("USERS CHART",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: !snapshot.hasData ?
                                      Center(
                                        child: CircularProgressIndicator(color: palettes.blue,),
                                      ) : _piechart(data: {
                                        "Active": datas == null ? 0 :  double.parse(datas.where((s) => s["status"] == "Activate").toList().length.toString()),
                                        "Inactive": datas == null ? 0 :  double.parse(datas.where((s) => s["status"] == "Deactivate").toList().length.toString()),
                                      },icon: Icons.people_alt_outlined, colorList: [
                                        palettes.blue,
                                        Colors.grey.shade400
                                      ],border: palettes.blue),
                                    ),
                                  ],
                                ),
                              );
                            }
                          ),
                          StreamBuilder(
                              stream: _requests.onValue,
                              builder: (context, snapshot) {
                              List? datas;

                              if(snapshot.hasData){
                                if(snapshot.data!.snapshot.value != null){
                                  datas = (snapshot.data!.snapshot.value as Map).values.toList();
                                }
                              }
                              return Expanded(
                                child: Column(
                                  children: [
                                    Text("PASS SLIP CHART",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: !snapshot.hasData ?
                                      Center(
                                        child: CircularProgressIndicator(color: palettes.blue,),
                                      ) :
                                      _piechart(data: {
                                        "Pending": datas == null ? 0 : double.parse(datas.where((s) => s["status"] == "Pending").toList().length.toString()),
                                        "Accepted": datas == null ? 0 :  double.parse(datas.where((s) => s["status"] == "Accepted").toList().length.toString()),
                                        "Declined": datas == null ? 0 :  double.parse(datas.where((s) => s["status"] == "Declined").toList().length.toString()),
                                        "Expired": datas == null ? 0 :  double.parse(datas.where((s) => s["status"] == "Expired").toList().length.toString()),
                                      },icon: Icons.description_outlined, colorList: [
                                        Colors.orange,
                                        palettes.darkblue,
                                        Colors.grey.shade400,
                                        Colors.redAccent
                                      ],border: palettes.darkblue),
                                    ),
                                  ],
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    )
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Monitoring",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,letterSpacing: 2),),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: _requests.onValue,
                      builder: (context, snapshot) {
                        List? datas;

                        if(snapshot.hasData){
                          if(snapshot.data!.snapshot.value != null){
                            datas = (snapshot.data!.snapshot.value as Map).values.toList();
                          }
                        }

                      return Expanded(
                        child: !snapshot.hasData ?
                        Center(
                          child: CircularProgressIndicator(color: palettes.blue,),
                        ) : Padding(
                          padding: EdgeInsets.only(right: 50),
                          child: charts.SfCartesianChart(
                              primaryXAxis: charts.CategoryAxis(
                                labelStyle: TextStyle(fontSize: 13)
                              ),
                              primaryYAxis: charts.NumericAxis(minimum: 0, maximum: 40, interval: 10,),
                              tooltipBehavior: charts.TooltipBehavior(enable: true),
                              series: <charts.CartesianSeries<_ChartData, String>>[
                                if(datas != null)...{
                                  charts.ColumnSeries<_ChartData, String>(
                                      dataSource: [
                                        if(datas.where((s) => s["status"] == "Accepted").toList().isNotEmpty)...{
                                          for(int x = 0; x < datas.where((s) => s["status"] == "Accepted").toList().length; x++)...{
                                            _ChartData(DateFormat("dd MMM, yyyy").format(DateTime.parse(datas.where((s) => s["status"] == "Accepted").toList()[x]["date"])), double.parse(datas.where((s) => s["status"] == "Accepted").toList().length.toString())),
                                          }
                                        }
                                      ],
                                      xValueMapper: (_ChartData data, _) => data.x,
                                      yValueMapper: (_ChartData data, _) => data.y,
                                      name: 'Accepted',
                                      color: palettes.darkblue),
                                  charts.ColumnSeries<_ChartData, String>(
                                      dataSource: [
                                        if(datas.where((s) => s["status"] == "Declined").toList().isNotEmpty)...{
                                          for(int x = 0; x < datas.where((s) => s["status"] == "Declined").toList().length; x++)...{
                                            _ChartData(DateFormat("dd MMM, yyyy").format(DateTime.parse(datas.where((s) => s["status"] == "Declined").toList()[x]["date"])), double.parse(datas.where((s) => s["status"] == "Declined").toList().length.toString())),
                                          }
                                        }
                                      ],
                                      xValueMapper: (_ChartData data, _) => data.x,
                                      yValueMapper: (_ChartData data, _) => data.y,
                                      name: 'Declined',
                                      color: Colors.grey.shade400)
                                }
                              ])
                        )
                      );
                    }
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: _events.onValue,
                builder: (context, snapshot) {
                  List? datas;

                  if(snapshot.hasData){
                    if(snapshot.data!.snapshot.value != null){
                      datas = (snapshot.data!.snapshot.value as Map).values.toList();
                    }
                  }

                  print(datas);

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30,top: 10),
                      child: !snapshot.hasData ?
                      Center(
                        child: CircularProgressIndicator(color: palettes.blue,),
                      ) : CellCalendar(
                        dateTextStyle: TextStyle(fontSize: 15),
                        cellCalendarPageController: cellCalendarPageController,
                        events: [
                          if(datas != null)...{
                            for(int x = 0; x < datas.length; x++)...{
                              _calendar(date: DateTime.parse(datas[x]["start date"]), event: datas[x]["name"])
                            }
                          }
                        ],
                        monthYearLabelBuilder: (datetime) {
                          final year = datetime!.year.toString();
                          final month = datetime.month.monthName;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                Text(
                                  "$month  $year",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.keyboard_arrow_left),
                                  onPressed: () {
                                    setState(() {
                                      _current = DateTime(_current.year, _current.month - 1 , _current.day);
                                    });
                                    cellCalendarPageController.animateToDate(
                                      _current,
                                      curve: Curves.linear,
                                      duration: const Duration(milliseconds: 300),
                                    );
                                  },
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.keyboard_arrow_right),
                                  onPressed: () {
                                    setState(() {
                                      _current = DateTime(_current.year, _current.month + 1, _current.day);
                                    });
                                    cellCalendarPageController.animateToDate(
                                      _current,
                                      curve: Curves.linear,
                                      duration: const Duration(milliseconds: 300),
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        },
                        onCellTapped: (date) {
                          final eventsOnTheDate = [
                            for(int x = 0; x < datas!.length; x++)...{
                              _calendar(date: DateTime.parse(datas[x]["start date"]), event: datas[x]["name"])
                            }
                          ].where((event) {
                            final eventDate = event.eventDate;
                            return eventDate.year == date.year &&
                                eventDate.month == date.month &&
                                eventDate.day == date.day;
                          }).toList();
                          if(eventsOnTheDate.isNotEmpty){
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("${date.month.monthName} ${date.day}"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: eventsOnTheDate
                                        .map(
                                          (event) =>
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            margin: const EdgeInsets.only(bottom: 12),
                                            color: event.eventBackgroundColor,
                                            child: Text(
                                              event.eventName,
                                              style: TextStyle(fontSize: 14,color: Colors.white),
                                            ),
                                          ),
                                    )
                                        .toList(),
                                  ),
                                ));
                          }
                        },
                        onPageChanged: (firstDate, lastDate) {
                          print("asdasd");
                          /// Called when the page was changed
                          /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
                        },
                      ),
                    ),
                  );
                }
            ),
            SizedBox(
              width: 20,
            )
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

  CalendarEvent _calendar({required DateTime date, required String event}){
    return CalendarEvent(
      eventName: event,
      eventDate: date,
      eventBackgroundColor: palettes.darkblue,
      eventTextStyle: TextStyle(
        fontSize: 9,
        color: Colors.white,
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
