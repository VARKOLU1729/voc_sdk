
// import 'dart:js' as js;
// import 'dart:js_util' as js_util;


@JS()
library my_lib;

import 'dart:js_util' as js_util;

import 'package:js/js.dart';
import 'package:flutter/material.dart';

@JS()
external initializeCalmSDK();

void initVoxSDK() async {
  try {
    var promise = initializeCalmSDK();
    var qs = await js_util.promiseToFuture(promise);
    print(qs);
  } catch (e) {
    print("Error initializing Calm SDK: $e");
  }
}

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {

  // Future<void> initializeCalmSDK() async {
  //   try {
  //     final result = await js_util.promiseToFuture(js.context.callMethod('initializeCalmSDK'));
  //
  //     print("Calm SDK initialized: $result");
  //   } catch (e) {
  //     print("Error initializing Calm SDK: $e");
  //   }
  // }

  @override
  void initState()
  {
    super.initState();
    // initializeCalmSDK();
    initVoxSDK();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Text("HI"),
    );
  }
}
