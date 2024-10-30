import 'package:flutter/material.dart';

class ClickToCall extends StatefulWidget {
  const ClickToCall({super.key});

  @override
  State<ClickToCall> createState() => _ClickToCallState();
}

class _ClickToCallState extends State<ClickToCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Dialer under construction")),
    );
  }
}
