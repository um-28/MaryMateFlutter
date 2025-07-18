import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(int userId, String name, String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('user_id', userId);
  await prefs.setString('user_name', name);
  await prefs.setString('user_email', email);
  print("✅ User data saved: $userId | $name | $email");
}
