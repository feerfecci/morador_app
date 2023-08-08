import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  static const _keyUserUser = 'user';
  static const _keyUserPassWord = 'senha';

  static Future setOrderCards(model, {required int qualModel}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = qualModel == 1 ? 'indexList' : 'indexList2';
    return preferences.setStringList(
      key,
      model,
    );
  }

  static Future getOrderCards(int qualModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = qualModel == 1 ? 'indexList' : 'indexList2';
    List? indexLista = preferences.getStringList(key);
    return indexLista;
  }

  static Future setUserLogin(String user, String senha) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(
      _keyUserUser,
      user,
    );
    preferences.setString(
      _keyUserPassWord,
      senha,
    );
  }

  static Future getUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? cacheUser = preferences.getString(_keyUserUser);
    String? cacheSenha = preferences.getString(_keyUserPassWord);
    List cache = [cacheUser, cacheSenha];
    return cache;
  }

  static removeUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(_keyUserUser);
    preferences.remove(_keyUserPassWord);
  }
}
