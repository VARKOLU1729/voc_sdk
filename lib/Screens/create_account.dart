import 'package:flutter/material.dart';
import 'package:voc_sdk/Widgets/login_widgets.dart' as LoginWidgets;
import 'package:http/http.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  String? email;
  String? password;
  String? userName;
  bool showPassword = false;
  final authKey = GlobalKey<FormState>();

  void save() async
  {
    if(authKey.currentState!.validate())
    {
        var url = Uri(scheme: 'https',
          host: 'proxy.vox-cpaas.com',
          path: 'api/user',
          queryParameters: {
          'authtoken' : '7dbad2d9_4476_42a5_8989_9d11e2966b90',
            'projectid' : 'pid_c374f86a_7fb1_4734_8386_3f4a599d0640',
            'username' : userName!,
            'password' : password!,
          }
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black87,
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildLoginForm()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm()
  {
    return Container(
      width: 400,
      child: Form(
        key: authKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginWidgets.Header("UserName"),
            LoginWidgets.buildUserNameField(onChanged: (val){setState(() {
              userName=val!;
            });}),
            SizedBox(height: 10,),
            LoginWidgets.Header("Email"),
            LoginWidgets.buildEmailField(onChanged: (val)=> {email = val!}),
            SizedBox(height: 10,),
            LoginWidgets.Header("Password"),
            LoginWidgets.buildPasswordField(onChanged:(val)=> {password = val!}, showPassword: showPassword),
            LoginWidgets.showPassword(showPassword: showPassword, onChanged: (val){setState(() {
              showPassword=val!;
            });}),
            SizedBox(height: 20,),
            LoginWidgets.buildActionButton(context: context, text: "Create Account", save: save),
            SizedBox(height: 40,),

          ],
        ),
      ),
    );
  }

}
