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

          Spacer(flex: 1,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Your DID Numbers", style: TextStyle(fontSize: 20),),
          ),

          Expanded(
              child: ListView.builder(
                itemCount: didNumbers.length,
                  itemBuilder: (context, index)
                      {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(didNumbers[index]),
                          ),
                        );
                      }
              )
          ),

          Center(
            child: FilledButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context)
                    {
                      return AlertDialog(
                        content: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
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
                              child: Text("Close")
                          ),
                          FilledButton(
                              onPressed: (){
                                save();
                                Navigator.pop(context);
                              },
                              child: Text("Save")
                          )
                        ],

                      );
                    }
                );
              },
              child: Text("Add new DID Number"),

            ),
          ),
          Spacer(flex: 3,),
        ],
      ),
    );
  }
}
