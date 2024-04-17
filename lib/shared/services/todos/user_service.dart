import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<void> readUserData(
    void Function(String?) onFirstnameUpdated,
    void Function(String?) onLastnameUpdated,
    void Function(int?) onUserIdUpdated,
    void Function(String?) onFullNameUpdated,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    onFirstnameUpdated(prefs.getString('user_fname'));
    onLastnameUpdated(prefs.getString('user_lname'));
    onUserIdUpdated(prefs.getInt('user_id'));
    onFullNameUpdated(
        '${prefs.getString('user_fname')?[0].toUpperCase()}${prefs.getString('user_fname')?.substring(1)} ${prefs.getString('user_lname')}');
  }
}
