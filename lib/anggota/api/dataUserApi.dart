class DataUser {
  bool status;
  String message;
  Data data;
  int total;

  DataUser({this.status, this.message, this.data, this.total});

  DataUser.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Data {
  List<User> user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = new List<User>();
      json['user'].forEach((v) {
        user.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
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
  Null rememberTime;
  Null rememberExp;
  Null verificationCode;
  Null topSecret;
  String ipAddress;
  String idMasjid;
  String namaMasjid;
  String jabatan;
  String avatarThumbnail;
  List<Group> group;

  User(
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
      this.jabatan,
      this.avatarThumbnail,
      this.group});

  User.fromJson(Map<String, dynamic> json) {
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
    avatarThumbnail = json['avatar_thumbnail'];
    if (json['group'] != null) {
      group = new List<Group>();
      json['group'].forEach((v) {
        group.add(new Group.fromJson(v));
      });
    }
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
    data['avatar_thumbnail'] = this.avatarThumbnail;
    if (this.group != null) {
      data['group'] = this.group.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Group {
  String userId;
  String groupId;
  String id;
  String name;
  String definition;

  Group({this.userId, this.groupId, this.id, this.name, this.definition});

  Group.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    groupId = json['group_id'];
    id = json['id'];
    name = json['name'];
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['group_id'] = this.groupId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['definition'] = this.definition;
    return data;
  }
}
