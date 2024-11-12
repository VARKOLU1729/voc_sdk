import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/call_logs_model.dart';

class CallLogs extends StatefulWidget {
  const CallLogs({super.key});

  @override
  State<CallLogs> createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {

  static const platform = MethodChannel('VOICECALL');
  List<CallLogsModel> callLogs = [];
  int curLargeView = -1;

  void getCallLogs() async {
    Map<dynamic, dynamic> x = await platform.invokeMethod('getCallLogs');
    List<CallLogsModel> tempLogs = [];

    x.forEach((key, value) {
      Map<String, dynamic> logData = {
        'call_Id': key,
        'calle_name': value[0],
        'calle_number': value[1],
        'call_type': value[2],
        'call_start_time': value[3],
        'call_duration': value[4],
      };
      tempLogs.add(CallLogsModel.fromJson(logData));
    });

    tempLogs.sort((a, b) => int.parse(b.callStartTime).compareTo(int.parse(a.callStartTime)));

    setState(() {
      callLogs = tempLogs;
    });
  }

  void deleteCallLog({required String callId}) async
  {
    String x = await platform.invokeMethod('deleteCallLog', {'callId' : callId});
    setState(() {
      callLogs.clear();
      getCallLogs();
    });
  }

  String getTime(int epoch)
  {
    DateTime callTime = DateTime.fromMillisecondsSinceEpoch(epoch);
    String time = DateFormat.Hms().format(callTime);
    return DateFormat('dd-MM-yyyy').format(callTime)+"  \u2981 "+time;
  }

  String getTimeDifference(int epoch) {
    DateTime callTime = DateTime.fromMillisecondsSinceEpoch(epoch);
    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(callTime);

    if (difference.inDays == 0) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes} mins ago';
      } else {
        return '${difference.inHours} hr ${difference.inMinutes%60} mins ago';
      }
    } else {
      return DateFormat('dd-MM-yyyy').format(callTime);
    }
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
            String timeMsg = getTimeDifference(int.parse(callLogs[index].callStartTime));
            String time = getTime(int.parse(callLogs[index].callStartTime));
            return InkWell(
              onTap: (){
                setState(() {
                  if(curLargeView==index)
                    {
                      curLargeView = -1;
                    }
                  else curLargeView = index;
                });
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                  child: ListTile(
                    leading: Icon(
                        checkCallType(callLogs[index].callType) ? Icons.call_made : Icons.call_received,
                      color: checkCallType(callLogs[index].callType) ? Colors.red: Colors.blue,
                    ),
                    title: RichText(
                        text:TextSpan(
                            style: TextStyle(color: Colors.black87, fontSize: 18),
                            children: [
                              TextSpan(text: callLogs[index].calleName),
                              TextSpan(text: '\n'),
                              TextSpan(text: callLogs[index].calleNumber),
                              TextSpan(text: '\n'),
                              TextSpan(text: '\n'),
                              TextSpan(text: "$timeMsg"),
                              TextSpan(text: ' \u2981 '),
                              TextSpan(text: "${callLogs[index].callDuration} mins"),
                              if(curLargeView==index) TextSpan(text: '\n'),
                              if(curLargeView==index) TextSpan(text: '\n'),
                              if(curLargeView==index) TextSpan(text: "$time")
                            ]
                        )
                    ),
                    trailing: IconButton(
                        onPressed: (){
                          deleteCallLog(callId : callLogs[index].callId);
                        },
                        icon:Icon(Icons.delete)
                    ),
                  )
                ),
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
