import 'package:flutter/material.dart';
import 'package:voc_sdk/Screens/call_screen.dart';
import 'package:voc_sdk/Widgets/dial_pad.dart';

class ClickToCall extends StatefulWidget {
  const ClickToCall({super.key});

  @override
  State<ClickToCall> createState() => _ClickToCallState();
}

class _ClickToCallState extends State<ClickToCall> {

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

  void makeCall()
  {
    if(enteredContact.length==10) {
      print("gng to call screen");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CallScreen(contactNumber: "+91$enteredContact")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DialPad(makeCall: makeCall, onButtonPressed: onButtonPressed, removeLastChar: removeLastChar, enteredContact: enteredContact)
    );
  }
}



