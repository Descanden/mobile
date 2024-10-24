import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _emailKey = 'user_email';

  // Save email to SharedPreferences
  Future<void> saveEmail(String email) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email);
    } catch (e) {
      print('Error saving email: $e'); // Log the error
    }
  }

  // Get email from SharedPreferences
  Future<String?> getEmail() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error getting email: $e'); // Log the error
      return null;
    }
  }

  // Remove email from SharedPreferences
  Future<void> removeEmail() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emailKey);
    } catch (e) {
      print('Error removing email: $e'); // Log the error
    }
  }
}
