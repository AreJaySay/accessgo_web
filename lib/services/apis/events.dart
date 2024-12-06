import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/snackbars/snackbar_message.dart';
import '../network.dart';

class EventServices{
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();

  Future addEvent({required Map details})async{
    try{
      final url = Uri.parse('${networkUtils.networkUtils}/events.json');
      await http.post(
        url,
        body: json.encode(details),
      ).then((data){
        var respo = json.decode(data.body);
        print("EVENTS ${respo}");
      });
    }catch(e){
      print("ERROR EVENTS $e");
    }
  }
}

final EventServices eventServices = new EventServices();