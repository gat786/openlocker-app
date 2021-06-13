import 'package:open_locker_app/constants.dart';
import 'package:open_locker_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> getSharedUserPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = User();
  user.userName     = prefs.getString(USERNAME_KEY);
  user.emailAddress = prefs.getString(EMAILADDRESS_KEY);
  user.refreshToken = prefs.getString(REFRESHTOKEN_KEY);
  return user;
}

Future updateSharedUserPreferences(User updatedUserDetails) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(USERNAME_KEY, updatedUserDetails.userName ?? "");
  prefs.setString(EMAILADDRESS_KEY, updatedUserDetails.emailAddress ?? "");
  prefs.setString(REFRESHTOKEN_KEY, updatedUserDetails.refreshToken ?? "");
}

Future deleteSharedUserPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
