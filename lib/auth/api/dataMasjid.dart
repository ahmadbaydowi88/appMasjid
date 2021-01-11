class DataMasjid {
  bool status;
  String message;
  Data data;
  int total;

  DataMasjid({this.status, this.message, this.data, this.total});

  DataMasjid.fromJson(Map<String, dynamic> json) {
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
  List<TMasjid> tMasjid;

  Data({this.tMasjid});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['t_masjid'] != null) {
      tMasjid = new List<TMasjid>();
      json['t_masjid'].forEach((v) {
        tMasjid.add(new TMasjid.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tMasjid != null) {
      data['t_masjid'] = this.tMasjid.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TMasjid {
  String idMasjid;
  String namaMasjid;
  String alamat;

  TMasjid({this.idMasjid, this.namaMasjid, this.alamat});

  TMasjid.fromJson(Map<String, dynamic> json) {
    idMasjid = json['id_masjid'];
    namaMasjid = json['nama_masjid'];
    alamat = json['alamat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_masjid'] = this.idMasjid;
    data['nama_masjid'] = this.namaMasjid;
    data['alamat'] = this.alamat;
    return data;
  }
}
