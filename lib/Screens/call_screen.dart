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
  bool onLoud = false;

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
    setState(() {
      callRecord = !callRecord;
    });
  }

  void toggleLoudSpeaker() async
  {
    await platform.invokeMethod('toggleLoudSpeaker', {'onLoud':onLoud});
    setState(() {
      onLoud = !onLoud;
    });

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
      backgroundColor: Color.fromARGB(255, 26, 28, 33),
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
              color: Colors.white
            ),
            child: ClipOval(
              child: Icon(Icons.person, size: 60,),
            ),
          ),

          SizedBox(height: 10,),

          Text(calleName, style: TextStyle(color: Colors.white, fontSize: 30),),

          Text(widget.contactNumber, style: TextStyle(color: Colors.white, fontSize: 25),),

          StreamBuilder(
              stream: timer.rawTime,
              builder:(context, snapshot)
              {
                if(snapshot.hasData)
                  {
                    final val = snapshot.data;
                    final displayTime = StopWatchTimer.getDisplayTime(val!);
                    
                    return Text("${displayTime.substring(3,8)}", style: TextStyle(color: Colors.white),);
                  }
                return Text("Timer");
              }
          ),

          Spacer(flex: 3,),

          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 36, 42, 50),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Spacer(flex: 1,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 26, 28, 33),
                      radius: 30,
                      child: IconButton(onPressed: holdCall,
                          icon: Icon(callOnHold ? Icons.call_to_action_rounded :Icons.call_to_action_outlined, color: Colors.white,size:30,)
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.fromARGB(255, 26, 28, 33),
                      child: IconButton(onPressed: recordCall,
                          icon: Icon(callRecord ? Icons.record_voice_over :Icons.record_voice_over_outlined, color: Colors.white,size: 30,)
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.fromARGB(255, 26, 28, 33),
                      child: IconButton(onPressed: muteCall,
                          icon: Icon(callOnMute? Icons.mic_off :Icons.mic, color: Colors.white,size: 30,)
                      ),
                    ),

                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.fromARGB(255, 26, 28, 33),
                      child: IconButton(onPressed: toggleLoudSpeaker,
                          icon: Icon(onLoud ? Icons.volume_down_sharp :Icons.volume_up_outlined, color: Colors.white,size: 30,)
                      ),
                    ),
                  ],
                ),

                Spacer(flex: 2,),

                CircleAvatar(
                  backgroundColor: Colors.red, // Background color
                  radius: 40, // Size of the circle
                  child: IconButton(
                    icon: Icon(Icons.call_end_outlined, color: Colors.black87, size: 40,), // Icon color
                    onPressed: () {
                      endCall();
                      Navigator.pop(context);
                    },
                  ),
                ),

                Spacer(flex: 1,)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
