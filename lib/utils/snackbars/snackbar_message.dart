import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SnackbarMessage{
  Future<void> snackbarMessage(context,{String? message,bool is_error = false,bool isChat = false})async{
    await Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      messageText: Text(message!,style: TextStyle(color: Colors.white,fontSize: 14.5,fontFamily: "regular"),),
      icon: is_error ? Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.white,
      ) : Icon(Icons.check_circle,color: Colors.green,),
      duration: Duration(seconds: isChat ? 10 : 6),
      leftBarIndicatorColor: is_error ? Colors.red : Colors.green,
      backgroundColor: is_error ? Colors.black.withOpacity(0.9) : Colors.blueGrey,
      margin: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
      borderRadius: BorderRadius.circular(5),
      mainButton:
      IconButton(
        icon: Icon(Icons.close,color: Colors.white,),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    )..show(context);
  }
}