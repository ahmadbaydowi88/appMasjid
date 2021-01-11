class DataArtikel {
  bool status;
  String message;
  Data data;
  int total;

  DataArtikel({this.status, this.message, this.data, this.total});

  DataArtikel.fromJson(Map<String, dynamic> json) {
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
  List<TArtikel> tArtikel;

  Data({this.tArtikel});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['t_artikel'] != null) {
      tArtikel = new List<TArtikel>();
      json['t_artikel'].forEach((v) {
        tArtikel.add(new TArtikel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tArtikel != null) {
      data['t_artikel'] = this.tArtikel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TArtikel {
  String idArtikel;
  String judul;
  String isi;
  String avatar;
  String penulis;
  String created;
  String createdBy;

  TArtikel(
      {this.idArtikel,
      this.judul,
      this.isi,
      this.avatar,
      this.penulis,
      this.created,
      this.createdBy});

  TArtikel.fromJson(Map<String, dynamic> json) {
    idArtikel = json['id_artikel'];
    judul = json['judul'];
    isi = json['isi'];
    avatar = json['avatar'];
    penulis = json['penulis'];
    created = json['created'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_artikel'] = this.idArtikel;
    data['judul'] = this.judul;
    data['isi'] = this.isi;
    data['avatar'] = this.avatar;
    data['penulis'] = this.penulis;
    data['created'] = this.created;
    data['created_by'] = this.createdBy;
    return data;
  }
}
