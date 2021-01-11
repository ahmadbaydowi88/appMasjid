import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthData {
  String username;
  String password;
  String token;
  AuthData({this.username, this.password, this.token});

  AuthData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }
}

Future<AuthData> loadAuthData() async {
  if (await Permission.storage.status != PermissionStatus.granted) return null;
  SharedPreferences p = await SharedPreferences.getInstance();
  if (!p.containsKey("auth_data")) await p.setString("auth_data", "");
  await p.reload();
  String r = p.getString("auth_data");
  if (r != "") {
    return AuthData.fromJson(jsonDecode(r));
  } else {
    return null;
  }
}

Future<void> saveAuthData(AuthData authData) async {
  if (await Permission.storage.status != PermissionStatus.granted) return;
  SharedPreferences p = await SharedPreferences.getInstance();
  await p.setString("auth_data", jsonEncode(authData));
}

Future<void> clearAuthData() async {
  if (await Permission.storage.status != PermissionStatus.granted) return;
  SharedPreferences p = await SharedPreferences.getInstance();
  await p.setString("auth_data", "");
}
