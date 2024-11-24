import 'package:flutter/material.dart';

class LocationTracker extends StatefulWidget {
  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        image: NetworkImage("https://foreignerds.com/wp-content/uploads/2024/05/4.png"),
      ),
    );
  }
}
