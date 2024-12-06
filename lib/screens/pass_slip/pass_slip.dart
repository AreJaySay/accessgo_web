import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management_web/functions/confirm_action.dart';
import 'package:pass_slip_management_web/functions/loaders.dart';
import 'package:pass_slip_management_web/screens/pass_slip/components/show_qr_code.dart';
import 'package:pass_slip_management_web/utils/palettes.dart';
import 'package:pass_slip_management_web/widgets/shimmering_loader.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:firebase_database/firebase_database.dart';

class PassSlip extends StatefulWidget {
  @override
  State<PassSlip> createState() => _PassSlipState();
}

class _PassSlipState extends State<PassSlip> {
  final TextEditingController _search = new TextEditingController();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final ShimmeringLoader _shimmeringLoader = new ShimmeringLoader();
  var _requests = FirebaseDatabase.instance.ref().child('requests');
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
        stream: _requests.onValue,
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
                    s["date"].toString().toLowerCase().contains(_checker.toLowerCase())||
                    s["time"].toString().toLowerCase().contains(_checker.toLowerCase())
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
                    Text("No requested pass slip for the maintime.",style: TextStyle(fontSize: 16),)
                  ],
                ),
              ) : _table(datas, _scrw),
          );
        }
    );
  }
  Widget _table(var datas, double scrw){
    return ScrollableTableView(
      headers: [
        "ID",
        "Fullname",
        "Email",
        "Date",
        "Time",
        "Reason",
        "Status",
        "Expiration",
        "Action",
        "Action",
      ].map((label) {
        return TableViewHeader(
          label: label,
          width: label == "ID" ? scrw/30 : label == "Action" ? scrw/13 :  scrw/10.8,
        );
      }).toList(),
      rows: [
        if(datas.isNotEmpty)...{
         for(int x = 0; x < datas.length; x++)...{
          if(datas[x]["expiration"] != "NA")...{
            if(datas[x]["status"] == "Expired")...{
              ["${x+1}", "${datas[x]["firstname"]} ${datas[x]["lastname"]}", datas[x]["email"], "${DateFormat("dd MMMM yyyy").format(DateTime.parse(datas[x]["date"]))}", "${DateFormat("h:mm a").format(DateTime.parse(datas[x]["time"]))}", datas[x]["reason"], datas[x]["status"], "${DateFormat("h:mm a").format(DateTime.parse(datas[x]["expiration"]))}",  "Disabled" ,  "deleterequest/${datas[x]["date"]}"],
            }else...{
              ["${x+1}", "${datas[x]["firstname"]} ${datas[x]["lastname"]}", datas[x]["email"], "${DateFormat("dd MMMM yyyy").format(DateTime.parse(datas[x]["date"]))}", "${DateFormat("h:mm a").format(DateTime.parse(datas[x]["time"]))}", datas[x]["reason"], datas[x]["status"], "${DateFormat("h:mm a").format(DateTime.parse(datas[x]["expiration"]))}",  "${datas[x]["status"] == "Accepted" ? "showqrcode/${datas[x]["date"].toString()}/${datas[x]["firstname"]} ${datas[x]["lastname"]}" : "acceptrequest/${datas[x]["date"]}"}" , "${datas[x]["status"] == "Declined" ? "deleterequest/${datas[x]["date"]}" : "declinerequest/${datas[x]["date"]}"}"],
            }
          }else...{
            ["${x+1}", "${datas[x]["firstname"]} ${datas[x]["lastname"]}", datas[x]["email"], "${DateFormat("dd MMMM yyyy").format(DateTime.parse(datas[x]["date"]))}", "${DateFormat("h:mm a").format(DateTime.parse(datas[x]["time"]))}", datas[x]["reason"], datas[x]["status"], "${datas[x]["expiration"] == "NA" ? "NA" : DateFormat("h:mm a").format(DateTime.parse(datas[x]["expiration"]))}",  "${datas[x]["status"] == "Accepted" ? "showqrcode/${datas[x]["date"].toString()}/${datas[x]["firstname"]} ${datas[x]["lastname"]}" : "acceptrequest/${datas[x]["date"]}"}" , "${datas[x]["status"] == "Declined" ? "deleterequest/${datas[x]["date"]}" : "declinerequest/${datas[x]["date"]}"}"],
          }
         }
        }else...{
          for(int x = 0; x < 5; x++)...{
            ["", "", "", "", "", "","", "", "", ""],
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
              value.toString().contains("acceptrequest") ?
              TextButton(
                onPressed: (){
                  confirmAction.action(context, (){
                    DatabaseReference ref = FirebaseDatabase.instance.ref("requests");
                    FirebaseDatabase.instance.ref().child('requests').orderByChild("date").equalTo(value.toString().split("/")[1]).onChildAdded.forEach((event)async{
                      await ref.update({
                        "${event.snapshot.key!}/status": "Accepted",
                      });
                    });
                  }, 'Are you sure you want to accept this request ?');
                },
                child: Text("Accept",style: TextStyle(color: palettes.blue,fontWeight: FontWeight.w500),),
              ) :
              value.toString().contains("declinerequest") ?
              TextButton(
                onPressed: (){
                  confirmAction.action(context, (){
                    DatabaseReference ref = FirebaseDatabase.instance.ref("requests");
                    FirebaseDatabase.instance.ref().child('requests').orderByChild("date").equalTo(value.toString().split("/")[1]).onChildAdded.forEach((event)async{
                      await ref.update({
                        "${event.snapshot.key!}/status": "Declined",
                        "${event.snapshot.key!}/expiration": "NA",
                      });
                    });
                  }, 'Are you sure you want to declined this request ?');
                },
                child: Text("Declined",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500),),
              ) :
              value.toString().contains("showqrcode") ?
              TextButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (_) => ShowQrCode(date: value.toString().split("/")[1], fullname: value.toString().split("/")[2],),
                  );
                },
                child: Text("Show qr code",style: TextStyle(color: palettes.darkblue,fontWeight: FontWeight.w500),),
              ) :
              value.toString().contains("deleterequest") ?
              TextButton(
                onPressed: (){
                  confirmAction.action(context, (){
                    FirebaseDatabase.instance.ref().child('requests').orderByChild("date").equalTo(value.toString().split("/")[1]).onChildAdded.forEach((event)async{
                      DatabaseReference ref = FirebaseDatabase.instance.ref("requests/${event.snapshot.key!}");
                      await ref.remove();
                    });
                  }, 'Are you sure you want to delete this request ?');
                },
                child: Text("Delete",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w500),),
              ) :
              Text(value,textAlign: TextAlign.center,),
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
