import 'package:flutter/material.dart';
import 'package:voc_sdk/Screens/call_screen.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),

            Text("+91$enteredContact", style: TextStyle(fontSize: 40),),

            SizedBox(height: 20,),

            Expanded(
              flex: 4,
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing:30,
                  crossAxisSpacing: 30,
                ),
                itemBuilder: (context, index) {
                  if (index < 9) {
                    return DialerButton(
                      label: '${index + 1}',
                      onPressed: () => onButtonPressed("${index + 1}"),
                    );
                  }

                  // Special symbols in the last row: +, 0, *
                  switch (index) {
                    case 9:
                      return DialerButton(
                        label: '+',
                        onPressed: () => onButtonPressed('+'),
                      );
                    case 10:
                      return DialerButton(
                        label: '0',
                        onPressed: () => onButtonPressed('0'),
                      );
                    case 11:
                      return DialerButton(
                        label: '<-',
                        onPressed: (){
                          removeLastChar();
                        },
                      );
                    default:
                      return SizedBox.shrink();
                  }
                },
              ),
            ),
            Center(
                child: CircleAvatar(
                  child: IconButton(
                    onPressed: makeCall,
                    icon:  Icon(Icons.call, color: Colors.white,),
                  ),
                  backgroundColor: Colors.green,
                  radius: 40,
                )
            )
          ],
        ),
      ),
    );
  }
}




class DialerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const DialerButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(5),
        backgroundColor: color??Colors.grey[200],
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}