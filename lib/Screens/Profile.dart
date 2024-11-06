import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final formKey = GlobalKey<FormState>();
  static const platform = MethodChannel('VOICECALL');
  String contact = "";
  String curUser = "Unknown";
  List<String> didNumbers = [];
  void save()
  {
    if(formKey.currentState!.validate())
      {
        setState(() {
          didNumbers.add(contact);
        });
      }
  }
  
  void getCurUser() async
  {
    String x = await platform.invokeMethod('getCurUser');
    setState(() {
      curUser = x;
    });
  }

  @override
  void initState()
  {
    getCurUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 20,),

          Center(
            child: Container(
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
          ),

          SizedBox(height: 20,),
          Center(
            child: Text(curUser, style: TextStyle(fontSize: 25),),
          ),

          const Spacer(flex: 1,),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("My DID Numbers", style: TextStyle(fontSize: 20),),
                FilledButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (context)
                        {
                          return showAlertDialog(context);
                        }
                    );
                  },
                  child: const Text("+", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),

                ),
              ],
            ),
          ),

          Expanded(
              child: ListView.builder(
                itemCount: didNumbers.length,
                  itemBuilder: (context, index)
                      {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(didNumbers[index], style: TextStyle(fontSize: 15),),
                          ),
                        );
                      }
              )
          ),


          Spacer(flex: 3,),
        ],
      ),
    );
  }

  AlertDialog showAlertDialog(BuildContext context)
  {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration:const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Mobile Number")
              ),
              validator:(val){
                if(val!.length<10)
                {
                  return "Mobile number has to be 10 digits";
                }
                return null;
              },
              onChanged: (val){
                contact = "+91$val";
              },
            ),

          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        FilledButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child:const Text("Close")
        ),
        FilledButton(
            onPressed: (){
              save();
              Navigator.pop(context);
            },
            child:const Text("Save")
        )
      ],

    );
  }
}
