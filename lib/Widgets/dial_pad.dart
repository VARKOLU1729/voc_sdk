import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget DialPad({required void Function() makeCall,required void Function(String) onButtonPressed,required void Function() removeLastChar,  required String enteredContact})
{
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("+91$enteredContact", style: TextStyle(fontSize: 40),),
          ),

          SizedBox(height: 20,),

          SizedBox(
            height: 500,
            width: 500,
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing:30,
                  crossAxisSpacing: 30,
                  mainAxisExtent: 100
              ),
              itemBuilder: (context, index) {
                if (index < 9) {
                  return DialerButton(
                    label: '${index + 1}',
                    onPressed: () => onButtonPressed("${index + 1}"),
                  );
                }
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
          SizedBox(height: 20,),
          Center(
            child: CircleAvatar(
              child: IconButton(
                onPressed: makeCall,
                icon:  Icon(Icons.call, color: Colors.white,),
              ),
              backgroundColor: Colors.green,
              radius: 45,
            ),
          )
        ],
      ),
    ),
  );
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