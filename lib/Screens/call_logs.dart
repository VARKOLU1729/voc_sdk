import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CallLogs extends StatefulWidget {
  const CallLogs({super.key});

  @override
  State<CallLogs> createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {

  static const platform = MethodChannel('VOICECALL');
  List<dynamic> callIds = [];

  List<List<dynamic>> callLogs = [];

  void getCallLogs() async
  {
    Map<dynamic, dynamic> x = await platform.invokeMethod('getCallLogs');
    print(x);
    setState(() {
      x.forEach((key, value) {
        callIds.add(key);
        callLogs.add(value);
      });
    });
  }

  void deleteCallLog({required String callId}) async
  {
    String x = await platform.invokeMethod('deleteCallLog', {'callId' : callId});
    setState(() {
      callIds = [];
      callLogs = [];
      getCallLogs();
    });
  }


  bool checkCallType( String callType)
  {
    if(callType == "OUTGOING PSTN CALL")
      {
        return true;
      }
    else return false;
  }

  @override
  void initState() {
    super.initState();
    // getPSTNCallHistory();
    getCallLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Call Logs")),
      body:ListView.builder(
          itemCount: callLogs.length,
          itemBuilder: (context, index)
          {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                child: ListTile(
                  leading: Icon(
                      checkCallType(callLogs[index][2]) ? Icons.call_made : Icons.call_received,
                    color: checkCallType(callLogs[index][2]) ? Colors.red: Colors.blue,
                  ),
                  title: RichText(
                      text:TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: callLogs[index][0]),
                            TextSpan(text: '\n'),
                            TextSpan(text: callLogs[index][1]),
                            TextSpan(text: '\n'),
                            // TextSpan(text: callLogs[index][2]),
                            TextSpan(text: '\n'),
                            TextSpan(text: callLogs[index][3]),
                            TextSpan(text: '   '),
                            TextSpan(text: callLogs[index][4]),
                          ]
                      )
                  ),
                  trailing: IconButton(
                      onPressed: (){
                        print('del');
                        print(callIds[index]);
                        deleteCallLog(callId : callIds[index]);
                      },
                      icon:Icon(Icons.delete)
                  ),
                )
              ),
            );
          }
      ),
    );
  }






  //this returns all the pstn call history of specific project
  // Future<void> getPSTNCallHistory() async {
  //   final String url = 'https://proxy.vox-cpaas.in/api/getpstncallhistory';
  //   final String projectId = 'pid_0d5bb4ba_421b_4351_b6aa_f9585ba9f309';
  //   final String authToken = '2116d01b_d461_4c5b_8ba3_c24fa40485e4';
  //
  //   final Uri uri = Uri.parse(
  //     '$url?projectid=$projectId&authtoken=$authToken&fromnumber=NULL&tonumber=NULL&starttime=NULL&endtime=NULL&countryname=NULL&countrycode=NULL&offset=0&size=1',
  //   );
  //
  //   try {
  //     final response = await http.get(
  //       uri,
  //       headers: {'Accept': 'application/json'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         data = json.decode(response.body);
  //       });
  //       print('PSTN Call History: $data');
  //     } else {
  //       print(
  //           'Failed to load call history. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('An error occurred: $e');
  //   }
  // }
}
