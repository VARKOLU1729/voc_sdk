import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:voc_sdk/Screens/call_logs.dart';
import 'package:voc_sdk/Screens/call_screen.dart';

import 'contacts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<HomeScreen> {
  String user = "No User";
  static const platform = MethodChannel('VOICECALL');
  bool _isLoading = true; // Loading state

  Future<http.Response> signUpNewUser({required String userName, required String password}) async {
    final url = Uri.parse('https://proxy.vox-cpaas.com/api/user');

    final body = {
      'authtoken': '73106b58_e0b1_46cb_b960_7b50c4ce5cb7',
      'projectid': 'pid_bbc98347_6212_4e9c_90de_58a3f735e033',
      'username': userName,
      'password': password,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to sign up user: ${response.statusCode}');
    }
  }

  void getUser({required String userName, required String password}) async {

    await _requestMicrophonePermission();
    setState(() {
      _isLoading = true;
    });

    try {
      //to signUp a new user - uncomment the below line
      // await signUpNewUser(userName: userName, password: password);
      String curUser = await platform.invokeMethod('getLoginStatus', {'loginId': userName, 'password': password});
      setState(() {
        user = curUser;
        _isLoading = false; // Reset loading state
      });
    } on PlatformException catch (e) {
      print("Error occurred: $e");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("An unexpected error occurred: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) {
      print("Microphone permission denied");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void initiateCall() async
  {
    await platform.invokeMethod('initiateCall');
  }

  void endCall() async
  {
    await platform.invokeMethod('endCall');
  }

  void answerCall() async
  {
    await platform.invokeMethod('answerCall');
  }


  @override
  void initState() {
    super.initState();
    getUser(userName: "runotest1", password: "12345");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('VoxValley'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text("Welcome $user", style: TextStyle(color: Colors.white)),

            SizedBox(height: 40,),

            ElevatedButton(
              onPressed:(){ Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CallLogs()));},
              child: Text("Call History"),
            ),

            ElevatedButton(
              onPressed:(){ Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Contacts()));},
              child: Text("Contacts"),
            ),

            SizedBox(height: 40,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                FloatingActionButton(
                  heroTag: "2",
                    onPressed: answerCall,
                  child: Icon(Icons.call),
                  backgroundColor: Colors.green,
                ),

                ElevatedButton(
                  onPressed: (){ Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CallScreen(contactNumber: "+916301450563")));},
                  child: Text("Click to Call "),
                ),

                FloatingActionButton(
                  heroTag: "1",
                    onPressed: endCall,
                  child: Icon(Icons.call),
                  backgroundColor: Colors.red,

                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
