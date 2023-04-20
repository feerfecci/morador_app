import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  static const _keyUserEmail = 'email';
  static const _keyUserPassWord = 'passWord';

  static Future setUserLogin(String email, String passWord) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
     preferences.setString(
      _keyUserEmail,
      email,
    );
     preferences.setString(
      _keyUserPassWord,
      passWord,
    );
  }

  static Future getUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> cache = {
      'email': preferences.getString(_keyUserEmail),
      'senha': preferences.getString(_keyUserPassWord)
    };
    return cache;
  }

  static removeUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(_keyUserEmail);
    preferences.remove(_keyUserPassWord);
  }
}
