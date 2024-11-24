import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pass_slip_management_web/widgets/material_button.dart';
import 'package:http/http.dart' as http;
import '../../../functions/loaders.dart';
import '../../../services/apis/auth.dart';
import '../../../services/network.dart';
import '../../../utils/palettes.dart';
import '../../../utils/snackbars/snackbar_message.dart';

class CreateAccount extends StatefulWidget {
  final Map details;
  CreateAccount({required this.details});
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> with SingleTickerProviderStateMixin {
  final Buttons _buttons = new Buttons();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  final TextEditingController _address = new TextEditingController();
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  String? gender;
  final List<String> _genderChoice = [
    "Male",
    "Female",
  ];
  List? _users;

  Future checkUserExist()async{
    try{
      final url = Uri.parse('${networkUtils.networkUtils}/users.json');
      await http.get(
        url,
      ).then((data)async{
        var respo = json.decode(data.body);
        if(data.statusCode == 200){
          print(respo.values);
          setState(() {
            _users = respo.values.toList();
          });
        }
      });
    }catch(e){
      print("ERROR CHECK $e");
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserExist();
    if(widget.details.toString() != "{}"){
      _fname.text = widget.details["firstname"];
      _lname.text = widget.details["lastname"];
      _email.text = widget.details["email"];
      _phone.text = widget.details["phone number"];
      _address.text = widget.details["address"];
      gender = widget.details["gender"];
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
        widget.details != {} ?
        'Update account' :
        'Create new account',
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
                decoration: _decoration(hint: "Firstname"),
                controller: _fname,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(fontFamily: "regular"),
                decoration: _decoration(hint: "Lastname"),
                controller: _lname,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(fontFamily: "regular"),
                decoration: _decoration(hint: "Email"),
                controller: _email,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(fontFamily: "regular"),
                decoration: _decoration(hint: "Phone number"),
                keyboardType: TextInputType.number,
                maxLength: 11,
                controller: _phone,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 65,
                padding: EdgeInsets.only(left: 18,right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    iconEnabledColor: palettes.darkblue,
                    iconDisabledColor: Colors.grey.shade300,
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    value: gender,
                    hint: Text(
                      "Gender",
                      style: TextStyle(fontFamily: "regular",color: Colors.grey.shade800),
                    ),
                    items: _genderChoice
                        .map(
                          (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(
                              fontFamily: "regular"
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(fontFamily: "regular"),
                decoration: _decoration(hint: "Address"),
                controller: _address,
              ),
              SizedBox(
                height: 50,
              ),
              widget.details.toString() != "{}" ?
              _buttons.button(text: "Update", ontap: (){
                if(_fname.text.isEmpty || _lname.text.isEmpty || _email.text.isEmpty || _phone.text.isEmpty || gender == null || _address.text.isEmpty){
                  _snackbarMessage.snackbarMessage(context, message: "All field is required." ,is_error: true);
                }else if(!_email.text.contains("@")){
                  _snackbarMessage.snackbarMessage(context, message: "Enter a valid email address." ,is_error: true);
                }else{
                  print("11111");
                  DatabaseReference ref = FirebaseDatabase.instance.ref("users");
                  FirebaseDatabase.instance.ref().child('users').orderByChild("email").equalTo(widget.details["email"]).onChildAdded.forEach((event){
                    ref.update({
                      "${event.snapshot.key!}/firstname": _fname.text,
                      "${event.snapshot.key!}/lastname": _lname.text,
                      "${event.snapshot.key!}/email": _email.text,
                      "${event.snapshot.key!}/phone number": _phone.text,
                      "${event.snapshot.key!}/gender": gender,
                      "${event.snapshot.key!}/address": _address.text,
                    }).whenComplete((){
                      Navigator.of(context).pop(null);
                    });
                  });
                }
              }, isValidate: true) :
              _buttons.button(text: "Create account", ontap: (){
                if(_fname.text.isEmpty || _lname.text.isEmpty || _email.text.isEmpty || _phone.text.isEmpty || gender == null || _address.text.isEmpty){
                  _snackbarMessage.snackbarMessage(context, message: "All field is required." ,is_error: true);
                }else if(!_email.text.contains("@")){
                  _snackbarMessage.snackbarMessage(context, message: "Enter a valid email address." ,is_error: true);
                }else if(_users != null){
                  if(_users!.where((s) => s["email"] == _email.text).toList().isNotEmpty){
                    print("EXIST");
                    _snackbarMessage.snackbarMessage(context, message: "Email address already been used." ,is_error: true);
                  }else{
                    FocusScope.of(context).unfocus();
                    _screenLoaders.functionLoader(context);
                    authServices.register(details: {
                      "firstname": _fname.text,
                      "lastname": _lname.text,
                      "email": _email.text,
                      "phone number": _phone.text,
                      "gender": gender,
                      "address": _address.text,
                      "password": "default-password",
                      "status": "Activate"
                    }).whenComplete((){
                      Navigator.of(context).pop(null);
                      Navigator.of(context).pop(null);
                      _snackbarMessage.snackbarMessage(context, message: "New account successfully created.");
                    });
                  }
                }else{
                  FocusScope.of(context).unfocus();
                  _screenLoaders.functionLoader(context);
                  authServices.register(details: {
                    "firstname": _fname.text,
                    "lastname": _lname.text,
                    "email": _email.text,
                    "phone number": _phone.text,
                    "gender": gender,
                    "address": _address.text,
                    "password": "default-password",
                    "status": "Activate"
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
  InputDecoration _decoration({required String hint}){
    return InputDecoration(
      counterText: "",
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(fontFamily: "regular"),
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