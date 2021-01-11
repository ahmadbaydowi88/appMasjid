import 'dart:convert';

import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<DataProfile> getDataProfile() async {
  //get data from server
  DataProfile r;
  await getData(
    url: urlApi.dataProfile,
    onComplete: (data, statusCode) {
      r = DataProfile.fromJson(jsonDecode(data));
    },
  );
  return r;
}

Future<DataProfile> loadDataProfile() async {
  if (await Permission.storage.status != PermissionStatus.granted) return null;
  SharedPreferences p = await SharedPreferences.getInstance();
  if (!p.containsKey("auth_data")) await p.setString("auth_data", "");
  await p.reload();
  String r = p.getString("auth_data");
  if (r != "") {
    return DataProfile.fromJson(jsonDecode(r));
  } else {
    return null;
  }
}

Future<void> saveDataProfile(DataProfile authData) async {
  if (await Permission.storage.status != PermissionStatus.granted) return;
  SharedPreferences p = await SharedPreferences.getInstance();
  await p.setString("auth_data", jsonEncode(authData));
}

Future<void> clearDataProfile() async {
  if (await Permission.storage.status != PermissionStatus.granted) return;
  SharedPreferences p = await SharedPreferences.getInstance();
  await p.setString("auth_data", "");
}

class DataProfile {
  bool status;
  String message;
  Data data;

  DataProfile({this.status, this.message, this.data});

  DataProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String id;
  String email;
  Null oauthUid;
  Null oauthProvider;
  String pass;
  String username;
  String fullName;
  String avatar;
  String banned;
  String lastLogin;
  String lastActivity;
  String dateCreated;
  Null forgotExp;
  Null rememberTime;
  Null rememberExp;
  Null verificationCode;
  Null topSecret;
  String ipAddress;
  String idMasjid;
  String namaMasjid;
  String jabatan;

  Data(
      {this.id,
      this.email,
      this.oauthUid,
      this.oauthProvider,
      this.pass,
      this.username,
      this.fullName,
      this.avatar,
      this.banned,
      this.lastLogin,
      this.lastActivity,
      this.dateCreated,
      this.forgotExp,
      this.rememberTime,
      this.rememberExp,
      this.verificationCode,
      this.topSecret,
      this.ipAddress,
      this.idMasjid,
      this.namaMasjid,
      this.jabatan});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    oauthUid = json['oauth_uid'];
    oauthProvider = json['oauth_provider'];
    pass = json['pass'];
    username = json['username'];
    fullName = json['full_name'];
    avatar = json['avatar'];
    banned = json['banned'];
    lastLogin = json['last_login'];
    lastActivity = json['last_activity'];
    dateCreated = json['date_created'];
    forgotExp = json['forgot_exp'];
    rememberTime = json['remember_time'];
    rememberExp = json['remember_exp'];
    verificationCode = json['verification_code'];
    topSecret = json['top_secret'];
    ipAddress = json['ip_address'];
    idMasjid = json['id_masjid'];
    namaMasjid = json['nama_masjid'];
    jabatan = json['jabatan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['oauth_uid'] = this.oauthUid;
    data['oauth_provider'] = this.oauthProvider;
    data['pass'] = this.pass;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    data['avatar'] = this.avatar;
    data['banned'] = this.banned;
    data['last_login'] = this.lastLogin;
    data['last_activity'] = this.lastActivity;
    data['date_created'] = this.dateCreated;
    data['forgot_exp'] = this.forgotExp;
    data['remember_time'] = this.rememberTime;
    data['remember_exp'] = this.rememberExp;
    data['verification_code'] = this.verificationCode;
    data['top_secret'] = this.topSecret;
    data['ip_address'] = this.ipAddress;
    data['id_masjid'] = this.idMasjid;
    data['nama_masjid'] = this.namaMasjid;
    data['jabatan'] = this.jabatan;
    return data;
  }
}
