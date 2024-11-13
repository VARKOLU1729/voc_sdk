import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:js/js.dart';
import 'package:flutter/material.dart';
import 'package:voc_sdk/web_screens/web_call_logs.dart';
import 'package:voc_sdk/web_screens/web_click_to_call.dart';
import '../Screens/contacts.dart';
import 'dart:js' as js;

@JS()
external initializeCalmSDK();

void initVoxSDK() async {
  print("went to init");
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

  bool extendRail = false;
  int selectedIndex = 0;
  List<NavigationRailDestination> destinations = [
    NavigationRailDestination(icon: Icon(Icons.call), label: Text("Click To Call")),
    NavigationRailDestination(icon: Icon(Icons.recent_actors_sharp), label: Text("Call Logs")),
    NavigationRailDestination(icon: Icon(Icons.contacts), label: Text("Contacts")),
  ];

  List<Widget> tabs  = [WebClickToCall(),WebCallLogs(), Contacts()];


  void handleInitJsEvents(String message)
  {
    if(message=="INIT")
      {
        print("INIT success from js");
      }
  }

  @override
  void initState()
  {
    super.initState();
    initVoxSDK();
    js.context['onInitJsEvent'] = handleInitJsEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text("VoxRuno"),
        ),
        leading: IconButton(
            onPressed: (){
              setState(() {

                extendRail = !extendRail;
              });
            },
            icon: Icon(Icons.menu)),
      ),
      backgroundColor: Colors.white,
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationRail(
            selectedLabelTextStyle: TextStyle(fontSize: 15),
              unselectedLabelTextStyle: TextStyle(fontSize: 15),
            extended: extendRail,
            backgroundColor: Colors.orangeAccent.withOpacity(0.1),
            groupAlignment: -1,
            onDestinationSelected: (index){setState(() {
              selectedIndex = index;
            });},
              destinations: destinations,
              selectedIndex: selectedIndex
          ),

          Expanded(child: tabs[selectedIndex])
        ],
      ),

    );
  }
}
