import 'package:flutter/material.dart';
import 'package:voc_sdk/Screens/home_screen.dart';
import 'package:voc_sdk/Screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:voc_sdk/web_screens/web_home_screen.dart';

void main() async{
  return runApp(
      MaterialApp(
        home: kIsWeb ?  WebHomeScreen()  : (Platform.isAndroid? HomeScreen() : HomeScreen())
      )
  );
}

