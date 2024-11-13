import 'package:flutter/material.dart';
import 'package:voc_sdk/Widgets/dial_pad.dart';
import 'package:voc_sdk/web_screens/web_call_screen.dart';

class WebClickToCall extends StatefulWidget {
  const WebClickToCall({super.key});

  @override
  State<WebClickToCall> createState() => _WebClickToCallState();
}

class _WebClickToCallState extends State<WebClickToCall> {

  String enteredContact = "";

  void onButtonPressed(String char)
  {
    if(enteredContact.length<10) {
      setState(() {
        enteredContact += char;
      });
    }
  }

  void removeLastChar()
  {
    if(enteredContact.length>0) {
      setState(() {
        enteredContact = enteredContact.substring(0, enteredContact.length - 1);
      });
    }
  }

  void makeCall(BuildContext context)
  {
    if(enteredContact.length==10) {
      print("gng to call screen");
      showDialog(
        barrierDismissible: false,
          context: context,
          builder:(context)=>AlertDialog(
            content: Container(
              width: 300,
                height: 800,
                child: WebCallScreen(contactNumber: enteredContact,)
            ),
          )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DialPad(makeCall: (){makeCall(context);}, onButtonPressed: onButtonPressed, removeLastChar: removeLastChar, enteredContact: enteredContact)
    );
  }
}



