import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DIDProvider extends ChangeNotifier
{
  void addDID(String contact) async
  {
    final sp = await SharedPreferences.getInstance();
  }
}