import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenLoaders{
  void functionLoader(context){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.0),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white,)
              ),
            ),
          );
        },
      );
  }
}