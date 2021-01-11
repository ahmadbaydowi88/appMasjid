import 'dart:io';

import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/profile/api/profileData.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:flutter/cupertino.dart';

class ChangeNotifierPublic extends ChangeNotifier {
  String getAccountFullName() {
    if (dataLogin == null) return "";
    return dataLogin.data.fullName;
  }

  void setAccountFullname(String fullName) {
    dataLogin.data.fullName = fullName;
    notifyListeners();
  }

  String getPathAvatarFromServer() {
    return dataProfile.data.avatar;
  }

  void setPathAvatar(String pathLocal) {
    String fileLama = dataProfile.data.avatar.split("/").last;
    String fileBaru = pathLocal.split("/").last;
    dataProfile.data.avatar =
        dataProfile.data.avatar.replaceAll(fileLama, fileBaru);
    notifyListeners();
  }
}
