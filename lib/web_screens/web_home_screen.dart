import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:js/js.dart';
import 'package:flutter/material.dart';

@JS()
external initializeCalmSDK();

void initVoxSDK() async {
  if(kIsWeb)
  {
    try {
      var promise = initializeCalmSDK();
      var qs = await js_util.promiseToFuture(promise);
      print(qs);
    } catch (e) {
      print("Error initializing Calm SDK: $e");
    }
  }

}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState()
  {
    super.initState();
    // initVoxSDK();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Text("HI"),
    );
  }
}
