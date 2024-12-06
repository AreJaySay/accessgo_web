import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_slip_management_web/widgets/material_button.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import '../../../functions/confirm_action.dart';

class ShowQrCode extends StatefulWidget {
  final String date, fullname;
  ShowQrCode({required this.date, required this.fullname});
  @override
  State<ShowQrCode> createState() => _ShowQrCodeState();
}

class _ShowQrCodeState extends State<ShowQrCode> with SingleTickerProviderStateMixin {
  final Buttons _buttons = new Buttons();
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();
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
        'Scan qr code',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Container(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              QrImageView(
                data: "${widget.date}/${widget.fullname}",
                version: QrVersions.auto,
                size: 350,
                gapless: false,
                embeddedImage: AssetImage('assets/logos/accessgo-transparent.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(80, 80),
                ),
                errorStateBuilder: (cxt, err) {
                  return Container(
                    child: Center(
                      child: Text(
                        'Uh oh! Something went wrong...',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              ),
              SizedBox(
                height: 40,
              ),
              _buttons.button(text: "Close", ontap: (){
                Navigator.of(context).pop(null);
              }, color: Colors.blueGrey),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}