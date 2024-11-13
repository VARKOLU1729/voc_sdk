import 'dart:async';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js_util' as js_util;
import 'dart:js' as js;
import 'package:js/js.dart';


@JS()
external initiatePstnCall(String contactNumber);
@JS()
external endPstnCall();
@JS()
external mutePstnCall();
// external holdPstnCall();
@JS()
external recordPstnCall();

void initPstnCall({required String contactNumber}) async {
  if(kIsWeb)
  {
    try {
      var promise = initiatePstnCall(contactNumber);
      var qs = await js_util.promiseToFuture(promise);
      print(qs);
    } catch (e) {
      print("Error initializing Calm SDK: $e");
    }
  }

}

void endCall() async
{
  if(kIsWeb)
  {
    try {
      var promise = endPstnCall();
      var qs = await js_util.promiseToFuture(promise);
      print(qs);
    } catch (e) {
      print("Error initializing Calm SDK: $e");
    }
  }
}

void muteCall() async
{
  if(kIsWeb)
  {
    try {
      var promise = mutePstnCall();
      var qs = await js_util.promiseToFuture(promise);
      print(qs);
    } catch (e) {
      print("Error initializing Calm SDK: $e");
    }
  }
}

void recordCall() async
{
  if(kIsWeb)
  {
    try {
      var promise = recordPstnCall();
      var qs = await js_util.promiseToFuture(promise);
      print(qs);
    } catch (e) {
      print("Error initializing Calm SDK: $e");
    }
  }
}

//
// void holdCall() async
// {
//   if(kIsWeb)
//   {
//     try {
//       var promise = holdPstnCall();
//       var qs = await js_util.promiseToFuture(promise);
//       print(qs);
//     } catch (e) {
//       print("Error initializing Calm SDK: $e");
//     }
//   }
// }

class WebCallScreen extends StatefulWidget {
  final String contactNumber;
  const WebCallScreen({super.key, required this.contactNumber});

  @override
  State<WebCallScreen> createState() => _WebCallScreenState();
}

class _WebCallScreenState extends State<WebCallScreen> {

  // final NativeEventNotifier notifier = NativeEventNotifier();
  // static const platform = MethodChannel('VOICECALL');

  String calleName = "Unknown";
  bool callOnHold = false;
  bool callOnMute = false;
  bool callRecord = false;
  bool onLoud = false;
  bool callAnswered = false;
  bool callRinging = false;

  StopWatchTimer timer = StopWatchTimer(
      mode: StopWatchMode.countUp
  );


  void handleCallJsEvents(String message)
  {
    switch(message)
    {
      case "ANSWERED":
        setState(() {
          callAnswered=true;
          timer.onStartTimer();
        });
        break;
      case "RINGING":
        setState(() {
          callRinging = true;
        });
        break;
      case "PSTN-END":
        setState(() {
          timer.onStopTimer();
        });

    }
  }

  @override
  void initState()
  {
    super.initState();
    initPstnCall(contactNumber : widget.contactNumber);
    js.context['onCallJsEvent'] = handleCallJsEvents;
    // initiateCall();
    // notifier.startListening((eventData){
    //   if(eventData['callAnswered'])
    //   {
    //     setState(() {
    //       callAnswered = true;
    //       timer.onStartTimer();
    //     });
    //   }
    //   else if(eventData['callRinging'])
    //   {
    //     setState(() {
    //       callRinging = true;
    //     });
    //   }
    //   else if(eventData['callNoAnswer'])
    //   {
    //     setState(() {
    //       timer.onStopTimer();
    //       endCall();
    //     });
    //   }
    //   else if(eventData['callEnded'])
    //   {
    //     setState(() {
    //       timer.onStopTimer();
    //       endCall();
    //     });
    //   }
    //   else if(eventData['callTerminated'])
    //   {
    //     setState(() {
    //       timer.onStopTimer();
    //       endCall();
    //     });
    //   }
    // });
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

          if(!callAnswered && !callRinging)
            Text("Connecting...", style: TextStyle(color: Colors.white),),

          if(!callAnswered && callRinging)
            Text("Ringing...", style: TextStyle(color: Colors.white),),

          if(callAnswered)
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
                    // CircleAvatar(
                    //   backgroundColor: Color.fromARGB(255, 26, 28, 33),
                    //   radius: 30,
                    //   child: IconButton(onPressed: holdCall,
                    //       icon: Icon(callOnHold ? Icons.call_to_action_rounded :Icons.call_to_action_outlined, color: Colors.white,size:30,)
                    //   ),
                    // ),
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

                    // CircleAvatar(
                    //   radius: 30,
                    //   backgroundColor: Color.fromARGB(255, 26, 28, 33),
                    //   child: IconButton(onPressed: toggleLoudSpeaker,
                    //       icon: Icon(onLoud ? Icons.volume_down_sharp :Icons.volume_up_outlined, color: Colors.white,size: 30,)
                    //   ),
                    // ),
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
