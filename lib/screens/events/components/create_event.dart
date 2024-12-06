import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management_web/services/apis/events.dart';
import 'package:pass_slip_management_web/widgets/material_button.dart';
import 'package:http/http.dart' as http;
import '../../../functions/loaders.dart';
import '../../../services/network.dart';
import '../../../utils/palettes.dart';
import '../../../utils/snackbars/snackbar_message.dart';

class CreateEvent extends StatefulWidget {
  final Map details;
  CreateEvent({required this.details});
  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> with SingleTickerProviderStateMixin {
  final Buttons _buttons = new Buttons();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _image = new TextEditingController();
  final TextEditingController _desc = new TextEditingController();
  DateTime? _date;
  String _startTime = "";
  String _endTime = "";
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();
    if(widget.details.toString() != "{}"){
      _name.text = widget.details["name"];
      _desc.text = widget.details["description"];
      _date = DateTime.parse(widget.details["start date"]);
      _startTime = widget.details["start time"];
      _endTime = widget.details["end time"];
      _image.text = widget.details["image"];
    }
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);
    controller!.addListener(() {
      setState(() {});
    });
    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.details.toString() != "{}" ?
        'Update event' :
        'Create new event',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: <Widget>[

      ],
      content: Container(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(fontFamily: "regular"),
                decoration: _decoration(hint: "Event name"),
                controller: _name,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 55,
                padding: EdgeInsets.only(left: 20,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _date != null ?
                    Text("${DateFormat("dd MMMM yyyy").format(_date!)}",style: TextStyle(fontFamily: "semibold",fontSize: 16),) :
                    Text("Date",style: TextStyle(fontFamily: "regular",color: Colors.grey,fontSize: 16),),
                    Spacer(),
                    IconButton(
                      onPressed: ()async{
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));
                        if (picked != null && picked != _date) {
                          setState(() {
                            _date = picked;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_month,color: palettes.darkblue,),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 55,
                padding: EdgeInsets.only(left: 20,right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _startTime != "" ?
                    Text(_startTime,style: TextStyle(fontFamily: "semibold",fontSize: 16),) :
                    Text("Start time",style: TextStyle(fontFamily: "regular",color: Colors.grey,fontSize: 16),),
                    Spacer(),
                    IconButton(
                      onPressed: ()async{
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.input,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },);
                        setState(() {
                          _startTime = "${picked!.hour}:${picked.minute == 0 ? "00" : picked.minute}";
                        });
                      },
                      icon: Icon(Icons.access_time,color: palettes.darkblue,),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 55,
                padding: EdgeInsets.only(left: 20,right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _endTime != "" ?
                    Text(_endTime,style: TextStyle(fontFamily: "semibold",fontSize: 16),) :
                    Text("End time",style: TextStyle(fontFamily: "regular",color: Colors.grey,fontSize: 16),),
                    Spacer(),
                    IconButton(
                      onPressed: ()async{
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialEntryMode: TimePickerEntryMode.input,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },);
                        setState(() {
                          _endTime = "${picked!.hour}:${picked.minute == 0 ? "00" : picked.minute}";
                        });
                      },
                      icon: Icon(Icons.access_time,color: palettes.darkblue,),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(fontFamily: "regular"),
                decoration: _decoration(hint: "Link image", isOptional: true),
                controller: _image,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                maxLength: null,
                maxLines: 4,
                style: TextStyle(fontFamily: "regular"),
                decoration: _decoration(hint: "Description", isOptional: true),
                controller: _desc,
              ),
              SizedBox(
                height: 50,
              ),
              widget.details.toString() != "{}" ?
              _buttons.button(text: "Update", ontap: (){
                if(_name.text.isEmpty){
                  _snackbarMessage.snackbarMessage(context, message: "Event name is required." ,is_error: true);
                }else if(_date == null){
                  _snackbarMessage.snackbarMessage(context, message: "Start date is required." ,is_error: true);
                }else if(_startTime == "" || _endTime == ""){
                  _snackbarMessage.snackbarMessage(context, message: "Start time and end time is required." ,is_error: true);
                }else{
                  DatabaseReference ref = FirebaseDatabase.instance.ref("events");
                  FirebaseDatabase.instance.ref().child('events').orderByChild("name").equalTo(widget.details["name"]).onChildAdded.forEach((event){
                    ref.update({
                      "${event.snapshot.key!}/name": _name.text,
                      "${event.snapshot.key!}/start date": _date.toString(),
                      "${event.snapshot.key!}/start time": _startTime,
                      "${event.snapshot.key!}/end time": _endTime,
                      "${event.snapshot.key!}/image": _image.text,
                      "${event.snapshot.key!}/description": _desc.text,
                    }).whenComplete((){
                      Navigator.of(context).pop(null);
                    });
                  });
                }
              }, isValidate: true) :
              _buttons.button(text: "Create event", ontap: (){
                if(_name.text.isEmpty){
                  _snackbarMessage.snackbarMessage(context, message: "Event name is required." ,is_error: true);
                }else if(_date == null){
                  _snackbarMessage.snackbarMessage(context, message: "Start date is required." ,is_error: true);
                }else if(_startTime == "" || _endTime == ""){
                  _snackbarMessage.snackbarMessage(context, message: "Start time and end time is required." ,is_error: true);
                }else{
                  FocusScope.of(context).unfocus();
                  _screenLoaders.functionLoader(context);
                  eventServices.addEvent(details: {
                    "name": _name.text,
                    "start date": _date.toString(),
                    "start time": _startTime,
                    "end time": _endTime,
                    "image": _image.text,
                    "description": _desc.text,
                  }).whenComplete((){
                    Navigator.of(context).pop(null);
                    Navigator.of(context).pop(null);
                    _snackbarMessage.snackbarMessage(context, message: "New account successfully created.");
                  });
                }
              }, isValidate: true),
              SizedBox(
                height: 15,
              ),
              _buttons.button(text: "Cancel", ontap: (){
                Navigator.of(context).pop(null);
              }, color: Colors.blueGrey)
            ],
          ),
        ),
      ),
    );
  }
  InputDecoration _decoration({required String hint, bool isOptional = false}){
    return InputDecoration(
      counterText: "",
      border: InputBorder.none,
      hintText: hint,
      labelText: !isOptional ? hint : "optional",
      floatingLabelBehavior: !isOptional ? FloatingLabelBehavior.never : FloatingLabelBehavior.always,
      hintStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
      labelStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
      contentPadding: EdgeInsets.all(20),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palettes.darkblue),
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}