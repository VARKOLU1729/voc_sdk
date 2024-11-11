// import 'package:voc_sdk/helpers/web_imports.dart' if (dart.library.html) 'package:voc_sdk/helpers/web_imports.dart';

import 'package:flutter/material.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {


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
