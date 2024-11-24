import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_slip_management_web/landing.dart';
import 'package:pass_slip_management_web/services/routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDM7HvmZQIF8wpEpO4lW8ZvlOYLR1VHBRQ",
      appId: "1:1043032763922:android:0d4260ea94bf234f0a32cb",
      databaseURL: 'https://accessgo-188ae-default-rtdb.firebaseio.com',
      messagingSenderId: "1043032763922",
      projectId: "accessgo-188ae",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Access Go Web',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Routes _routes = new Routes();

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3), () async{
      _routes.navigator_pushreplacement(context, Landing());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column()
    );
  }
}
