import 'package:flutter/material.dart';

Widget showPassword({required bool showPassword, required void Function(bool?) onChanged})
{
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: CheckboxListTile(
      splashRadius: 0,
      value: showPassword,
      onChanged: onChanged,
      title: const Text(
        "Show password",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      fillColor: WidgetStatePropertyAll(Colors.white),
      activeColor: Colors.white,
      checkColor: Colors.orange,
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: Colors.transparent,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      side: BorderSide(
          width: 2,
          color: showPassword? Colors.orange : Colors.white
      ),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(horizontal: -4),
    ),
  );
}



Widget PasswordNotice()
{
  double fontSize = 15;
  double letterSpacing  = 0.2;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: RichText(
      text: TextSpan(
          text: 'i  ',style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green, fontSize: fontSize, letterSpacing: letterSpacing),
          children: [
            TextSpan(
                text: "Passwords must be at least 8 letters", style: TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontSize: fontSize, letterSpacing: letterSpacing)
            )
          ]
      ),
    ),
  );
}

Widget Header(String title)
{
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Text(title ,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
  );
}


Widget statement()
{
  Color color = Colors.green;
  double fontSize = 15;
  FontWeight fontWeight = FontWeight.w400;
  double letterSpacing = 0.2;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: RichText(
        text: TextSpan(text: "By creating an account or logging in, you agree to Runo's ", style: TextStyle(height:1.5, color: Colors.white, fontSize: fontSize, fontWeight: fontWeight, letterSpacing: letterSpacing),
          children: [
            TextSpan(text: "Conditions of Use ", style: TextStyle(color: color,  fontSize: fontSize, decoration: TextDecoration.underline, letterSpacing: letterSpacing)),
            TextSpan(text: "and ", style: TextStyle(color: Colors.white,  fontSize: fontSize, fontWeight: fontWeight, letterSpacing: letterSpacing)),
            TextSpan(text: "Privacy Notice", style: TextStyle(color: color,  fontSize: fontSize, decoration: TextDecoration.underline, letterSpacing: letterSpacing))
          ],
        )
    ),
  );
}


Widget buildUserNameField({required void Function(String?) onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: InputField(
      labelText: "",
      // onChanged: (val) => _username = val,
      onChanged: onChanged,
      validator: (val) {
        if (val!.isEmpty) {
          return 'Username must not be null';
        }
        return null;
      },
    ),
  );
}


Widget buildEmailField({required void Function(String?) onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: InputField(
      labelText: "",
      // onChanged: (val) => _email = val,
      onChanged: onChanged,
      validator: (val) {
        if (!val!.contains('@gmail.com')) {
          return 'Email must contain @gmail.com';
        }
        return null;
      },
    ),
  );
}

Widget buildPasswordField({required void Function(String?) onChanged, required bool showPassword}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: InputField(
      labelText: "",
      // onChanged: (val) => _password = val,
      onChanged: onChanged,
      validator: (val) {
        if (val!.length < 8) {
          return 'Password should contain at least 8 characters';
        }
        return null;
      },
      obscureText: !showPassword,
    ),
  );
}

Widget buildActionButton({required BuildContext context, required String text, required void Function() save}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: SizedBox(
      width: 360, // Fixed width
      height: 48, // Fixed height
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.orange),
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
        ),
        onPressed: save,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center, // Align text to center
        ),
      ),
    ),
  );
}

class InputField extends StatelessWidget {
  final void Function(String?) onChanged;
  final String? Function(String?) validator;
  final String labelText;
  final bool? obscureText;

  const InputField({
    super.key,
    required this.onChanged,
    required this.validator,
    required this.labelText,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2)),
        floatingLabelStyle: const TextStyle(color: Colors.orange),
        filled: true,
        fillColor: const Color.fromARGB(255, 41, 41, 43),
        label: Text(labelText),
        border: const OutlineInputBorder(),
      ),
    );
  }
}