import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voc_sdk/Screens/call_screen.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  String name = "";
  String contact = "";
  static const platform = MethodChannel('VOICECALL');
  String contactsResult = "";
  List<String> contactsName = [];
  List<String> contactsNumber = [];
  final formKey = GlobalKey<FormState>();

  void addToContacts({required String name, required String contact}) async
  {
    await platform.invokeMethod('addContact', {'name': name, 'contact':contact});
  }

  void getContacts() async
  {
    Map<dynamic, dynamic> x = await platform.invokeMethod('getContacts');
    print(x);
    setState(() {
      x.forEach((key, value) {
        contactsNumber.add(key);
        contactsName.add(value);
      });
    });
  }

  void save()
  {
    if(formKey.currentState!.validate())
      {
        print("validation of contact $name$contact successful");
        addToContacts(name: name, contact: contact);
        setState(() {
          contactsName = [];
          contactsNumber = [];
          getContacts();
        });
      }
  }



  @override
  void initState()
  {
    super.initState();
    getContacts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Contacts")),

      body: Stack(
        children:[ ListView.builder(
          itemCount: contactsName.length,
            itemBuilder: (context, index)
                {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text:TextSpan(
                                style: TextStyle(color: Colors.black87),
                                children: [
                                  TextSpan(text: contactsName[index]),
                                  TextSpan(text: '\n'),
                                  TextSpan(text: contactsNumber[index])
                                ]
                              )
                          ),

                          IconButton(
                              onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CallScreen(contactNumber: contactsNumber[index])));
                                CallScreen(contactNumber: contactsNumber[index],);
                              },
                              icon: Icon(Icons.wifi_calling)
                          )
                        ],
                      ),
                    ),
                  );
                }
        ),

          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
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

                              SizedBox(height: 10,),

                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Name")
                                ),
                                onChanged: (val){
                                  name = val;
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
              child: Icon(Icons.add_circle_rounded),
            ),
          )
      ]
      ),

    );
  }
}
