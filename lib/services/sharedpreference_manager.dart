


import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager{
  static SharedPreferences? _prefInstance;
  static Future<SharedPreferences> get _instance async => _prefInstance ??= await SharedPreferences.getInstance();

  static Future<SharedPreferences> init() async{
    _prefInstance=await _instance;
    return _prefInstance!;
  }

  static String getString(String key, [String? defValue]){
    return _prefInstance!.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value)async{
    return _prefInstance!.setString(key, value);
  }

}