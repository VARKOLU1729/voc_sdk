import 'dart:async';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallScreen extends StatefulWidget {
  final String contactNumber;
  const CallScreen({super.key, required this.contactNumber});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {

  static const platform = MethodChannel('VOICECALL');
  String calleName = "Unknown";
  bool callOnHold = false;
  bool callOnMute = false;
  bool callRecord = false;

  StopWatchTimer timer = StopWatchTimer(
                    mode: StopWatchMode.countUp
                  );

  void initiateCall() async
  {
    String x = await platform.invokeMethod('initiateCall', {'contactNumber' : widget.contactNumber});
    setState(() {
      calleName = x;
    });
  }

  void endCall() async
  {
    await platform.invokeMethod('endCall');
  }

  void holdCall() async
  {
    setState(() {
      callOnHold = !callOnHold;
      print(callOnHold);
    });
    await platform.invokeMethod('holdCall', {'onHold':callOnHold});
  }

  void muteCall() async
  {
    setState(() {
      callOnMute = !callOnMute;
    });
    await platform.invokeMethod('muteCall', {'onMute':callOnMute});
  }

  void recordCall() async
  {
    await platform.invokeMethod('recordCall', {'isRecording':callRecord});
    callRecord = !callRecord;
  }

  @override
  void initState()
  {
    super.initState();
    initiateCall();
    timer.onStartTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Spacer(flex: 1,),
          Container(
            height: 100,
            width: 100,
            // color: Colors.grey,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.5)
            ),
            child: ClipOval(
              child: Icon(Icons.person, size: 60,),
            ),
          ),

          SizedBox(height: 10,),

          Text(calleName, style: TextStyle(color: Colors.black87, fontSize: 30),),

          Text(widget.contactNumber, style: TextStyle(color: Colors.black87, fontSize: 25),),

          StreamBuilder(
              stream: timer.rawTime,
              builder:(context, snapshot)
              {
                if(snapshot.hasData)
                  {
                    final val = snapshot.data;
                    final displayTime = StopWatchTimer.getDisplayTime(val!);
                    
                    return Text("${displayTime.substring(3,8)}");
                  }
                return Text("Timer");
              }
          ),

          Spacer(flex: 3,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: holdCall,
                  icon: Icon(callOnHold ? Icons.call_to_action_rounded :Icons.call_to_action_outlined)
              ),
              IconButton(onPressed: recordCall,
                  icon: Icon(callRecord ? Icons.record_voice_over :Icons.record_voice_over_outlined)
              ),
              IconButton(onPressed: muteCall,
                  icon: Icon(callOnMute ? Icons.mic_off :Icons.mic)
              ),
            ],
          ),

          Spacer(flex: 1,),

          FloatingActionButton(
            heroTag: "1",
            onPressed:(){
              endCall();
              Navigator.pop(context);
              },
            child: Icon(Icons.call),
            backgroundColor: Colors.red,
          ),

          Spacer(flex: 1,),
        ],
      ),
    );
  }
}
