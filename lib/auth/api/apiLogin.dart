import 'dart:convert';

import 'package:apppengelolaan/auth/model/authData.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void doLogin(String username, String password,
    {onError(DioError error), onSuccess(), onFail()}) async {
  await postData(
    url: urlApi.login,
    data: {"username": username, "password": password},
    onComplete: (data, statusCode) {
      if (statusCode == 200) {
        dataLogin = ApiLogin.fromJson(jsonDecode(data));
        setTokenAuth(dataLogin.token);
        print(dataLogin.token);
        saveAuthData(AuthData(
            username: username, password: password, token: dataLogin.token));
        onSuccess();
      } else {
        onFail();
      }
    },
    onError: (error) {
      if (error.type == DioErrorType.RESPONSE) {
        if (error.response.statusCode == 406) {
          onFail();
        } else {
          onError(error);
        }
      } else {
        onError(error);
      }
    },
  );
}

void doLogout(BuildContext context, {bool showDialog = false}) {
  if (showDialog) {
    showDialogTanya(
      context: context,
      title: "Logout",
      description: "Logout dari akun ?",
      onPressOK: () => _logout(context),
      onPressCancel: () => Navigator.of(context).pop(),
    );
  } else {
    _logout(context);
  }
}

void _logout(BuildContext context) {
  Navigator.of(context)
      .popUntil(ModalRoute.withName(getRoutesName(RoutesName.mainPage)));
  Navigator.of(context).pushNamed(getRoutesName(RoutesName.mainPage));
}

class ApiLogin {
  bool status;
  String message;
  Data data;
  String token;

  ApiLogin({this.status, this.message, this.data, this.token});

  ApiLogin.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  String id;
  String email;
  Null oauthUid;
  Null oauthProvider;
  String username;
  String fullName;
  String avatar;
  String banned;
  String lastLogin;
  String lastActivity;
  String dateCreated;
  Null forgotExp;
  String rememberTime;
  String rememberExp;
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
