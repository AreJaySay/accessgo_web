import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/snackbars/snackbar_message.dart';
import '../network.dart';

class AuthServices{
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();

  // Future login(context,{required String email, required String pass, bool isManuall = true})async{
  //   try{
  //     final url = Uri.parse('${networkUtils.networkUtils}/users.json');
  //     await http.get(
  //       url,
  //     ).then((data)async{
  //       var respo = json.decode(data.body);
  //       if(data.statusCode == 200){
  //         List _res = respo.values.toList().where((s) => s["email"] == email && s["password"] == pass).toList();
  //         if(_res.isNotEmpty){
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           prefs.setString('email', email);
  //           prefs.setString('password', pass);
  //           authModel.pass = pass;
  //           authModel.email = email;
  //           authModel.loggedUser = _res[0];
  //           if(isManuall){
  //             Navigator.of(context).pop(null);
  //           }
  //           _routes.navigator_pushreplacement(context, Landing());
  //         }else{
  //           authModel.loggedUser = null;
  //           if(isManuall){
  //             Navigator.of(context).pop(null);
  //             _snackbarMessage.snackbarMessage(context, message: "Invalid email or password." ,is_error: true);
  //           }else{
  //             _routes.navigator_pushreplacement(context, Welcome());
  //           }
  //         }
  //         print("LOGIN ${respo.values.toList()}");
  //       }
  //     });
  //   }catch(e){
  //     print("ERROR LOGIN $e");
  //     if(isManuall){
  //       Navigator.of(context).pop(null);
  //       _snackbarMessage.snackbarMessage(context, message: "Invalid email or password." ,is_error: true);
  //     }else{
  //       _routes.navigator_pushreplacement(context, Welcome());
  //     }
  //   }
  // }

  Future register({required Map details})async{
    try{
      final url = Uri.parse('${networkUtils.networkUtils}/users.json');
      await http.post(
        url,
        body: json.encode(details),
      ).then((data){
        var respo = json.decode(data.body);
        print("REGISTER ${respo}");
      });
    }catch(e){
      print("ERROR REGISTER $e");
    }
  }

  // Future update({required String id})async{
  //   try{
  //     final url = Uri.parse('${networkUtils.networkUtils}/users/$id.json');
  //     await http.patch(
  //       url,
  //       body: json.encode(registerModel.toMap()),
  //     ).then((data){
  //       var respo = json.decode(data.body);
  //       print("UPDATE ${respo}");
  //     });
  //   }catch(e){
  //     print("ERROR UPDATE $e");
  //   }
  // }
}

final AuthServices authServices = new AuthServices();