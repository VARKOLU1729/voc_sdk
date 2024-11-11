// import 'dart:js_util' as js_util;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:js/js.dart';
//
// @JS()
// external initializeCalmSDK();
//
// void initVoxSDK() async {
//   if(kIsWeb)
//   {
//     try {
//       var promise = initializeCalmSDK();
//       var qs = await js_util.promiseToFuture(promise);
//       print(qs);
//     } catch (e) {
//       print("Error initializing Calm SDK: $e");
//     }
//   }
//
// }