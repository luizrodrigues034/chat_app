import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static const String userIdKey = 'USER_ID';
  static const String userNameKey = 'USER_NAME';
  static const String userEmailKey = 'USER_EMAIL';
  static const String userImageKey = 'USER_IMAGE';
  static const String userUserNameKey = 'USER_USERNAME';

  // Salvar dados do usuário
  static Future<void> saveUserInfo({
    required String id,
    required String name,
    required String email,
    required String image,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userIdKey, id);
    await prefs.setString(userNameKey, name);
    await prefs.setString(userEmailKey, email);
    await prefs.setString(userImageKey, image);
    await prefs.setString(userUserNameKey, username);
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      userIdKey: prefs.getString(userIdKey),
      userNameKey: prefs.getString(userNameKey),
      userEmailKey: prefs.getString(userEmailKey),
      userImageKey: prefs.getString(userImageKey),
      userUserNameKey: prefs.getString(userUserNameKey),
    };
  }

  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    await prefs.remove(userNameKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userImageKey);
    await prefs.remove(userUserNameKey);
  }
}
