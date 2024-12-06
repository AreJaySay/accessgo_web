import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management_web/functions/confirm_action.dart';
import 'package:pass_slip_management_web/functions/loaders.dart';
import 'package:pass_slip_management_web/screens/events/components/create_event.dart';
import 'package:pass_slip_management_web/utils/palettes.dart';
import 'package:pass_slip_management_web/widgets/shimmering_loader.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:firebase_database/firebase_database.dart';

class Events extends StatefulWidget {
  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final TextEditingController _search = new TextEditingController();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final ShimmeringLoader _shimmeringLoader = new ShimmeringLoader();
  var _events = FirebaseDatabase.instance.ref().child('events');
  String _checker = "";

  @override
  void dispose() {
    // TODO: implement dispose
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _scrw = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: _events.onValue,
        builder: (context, snapshot) {
          var datas;
          var local;

          if(snapshot.hasData){
            if(snapshot.data!.snapshot.value != null){
              if(_checker == ""){
                datas = (snapshot.data!.snapshot.value as Map).values.toList();
              }else{
                datas = (snapshot.data!.snapshot.value as Map).values.toList().where((s) =>
                s["firstname"].toString().toLowerCase().contains(_checker.toLowerCase()) ||
                    s["lastname"].toString().toLowerCase().contains(_checker.toLowerCase()) ||
                    s["email"].toString().toLowerCase().contains(_checker.toLowerCase()) ||
                    s["phone number"].toString().toLowerCase().contains(_checker.toLowerCase())
                ).toList();
              }
            }
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: AppBar(
                flexibleSpace: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 700,
                    child: TextField(
                      style: TextStyle(fontFamily: "regular"),
                      decoration: _decoration(hint: "Search", onTap: (){
                        setState(() {
                          _search.text = "";
                          _checker = "";
                          datas = (snapshot.data!.snapshot.value as Map).values.toList();
                        });
                      }),
                      controller: _search,
                      onChanged: (text){
                        setState(() {
                          _checker = text;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            body: !snapshot.hasData ?
            _table([], _scrw) :
            snapshot.data!.snapshot.value == null || datas.isEmpty ?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    width: 300,
                    image: AssetImage("assets/icons/no_result_found.png"),
                  ),
                  Text("NO DATA FOUND",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey.shade700),),
                  SizedBox(
                    height: 5,
                  ),
                  Text("No event created yet, click the add button below to add one.",style: TextStyle(fontSize: 16),)
                ],
              ),
            ) : _table(datas, _scrw),
              floatingActionButton: Padding(
                padding: EdgeInsets.all(15),
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => CreateEvent(details: {},),
                    );
                  },
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000)
                  ),
                  child: Center(
                    child: Icon(Icons.add,color: palettes.darkblue,size: 27,),
                  ),
                ),
              )
          );
        }
    );
  }
  Widget _table(var datas, double scrw){
    return ScrollableTableView(
      headers: [
        "ID",
        "Photo",
        "Name",
        "Start date",
        "Start time",
        "End time",
        "Description",
        "Action",
        "Action",
      ].map((label) {
        return TableViewHeader(
          label: label,
          width: label == "ID" ? scrw/28 : label == "Action" ? scrw/15 :  scrw/9,
        );
      }).toList(),
      rows: [
        if(datas.isNotEmpty)...{
          for(int x = 0; x < datas.length; x++)...{
            ["${x+1}", datas[x]["image"], datas[x]["name"], "${DateFormat("dd MMMM yyyy").format(DateTime.parse(datas[x]["start date"]))}", datas[x]["start time"], datas[x]["end time"], datas[x]["description"], "Update/${datas[x]["name"]}", "Delete/${datas[x]["name"]}"],
          }
        }else...{
          for(int x = 0; x < 5; x++)...{
            ["", "", "", "", "", "", "","", ""],
          }
        }
      ].map((record) {
        return TableViewRow(
          backgroundColor: datas.isEmpty? Colors.transparent : palettes.blue.withOpacity(0.02),
          height: 60,
          cells: record.map((value) {
            return TableViewCell(
              child: datas.isEmpty?
              _shimmeringLoader.pageLoader(radius: 5, width: 100, height: 30) :
              value.toString().contains("https://") ?
              Image(
                image: NetworkImage(value),
              ) :
              value.toString().contains("Update") ?
              TextButton(
                onPressed: (){
                  FirebaseDatabase.instance.ref().child('events').orderByChild("name").equalTo(value.toString().split("/")[1]).onChildAdded.forEach((event){
                    showDialog(
                      context: context,
                      builder: (_) => CreateEvent(details: event.snapshot.value as Map,),
                    );
                  });
                },
                child: Text("Update",style: TextStyle(color: palettes.blue,fontWeight: FontWeight.w500),),
              ) : value.toString().contains("Delete") ?
              TextButton(
                onPressed: (){
                  confirmAction.action(context, (){
                    FirebaseDatabase.instance.ref().child('events').orderByChild("name").equalTo(value.toString().split("/")[1]).onChildAdded.forEach((event)async{
                      DatabaseReference ref = FirebaseDatabase.instance.ref("events/${event.snapshot.key!}");
                      await ref.remove();
                    });
                  }, 'Are you sure you want to delete this event ?');
                },
                child: Text("Delete",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w500),),
              ) :
              Text(value),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
  InputDecoration _decoration({required String hint, required Function() onTap}){
    return InputDecoration(
        counterText: "",
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(fontFamily: "regular"),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: palettes.darkblue),
            borderRadius: BorderRadius.circular(10)
        ),
        prefixIcon: Icon(Icons.search),
        suffixIcon: _checker == "" ?
        null :
        IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            onTap();
          },
        )
    );
  }
}
