import 'package:shared_preferences/shared_preferences.dart';

class LocalDb {
  static Future<String?> getusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  static Future<String?> getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("id");
  }

  static setusername({username}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", username);
    return null;
  }

  static setuserid({id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("id", id);
    return null;
  }
}
