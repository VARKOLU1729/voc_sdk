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


  @override
  void initState()
  {
    super.initState();
    // addToContacts(name:"Rishabh", contact:"+917078257578");
    getContacts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Contacts")),

      body: ListView.builder(
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

    );
  }
}
