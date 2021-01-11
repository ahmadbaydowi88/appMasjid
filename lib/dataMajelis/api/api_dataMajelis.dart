class DataMajelis {
  bool status;
  String message;
  Data data;
  int total;

  DataMajelis({this.status, this.message, this.data, this.total});

  DataMajelis.fromJson(Map<String, dynamic> json) {
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
  List<TMajelis> tMajelis;

  Data({this.tMajelis});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['t_majelis'] != null) {
      tMajelis = new List<TMajelis>();
      json['t_majelis'].forEach((v) {
        tMajelis.add(new TMajelis.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tMajelis != null) {
      data['t_majelis'] = this.tMajelis.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TMajelis {
  String idMajelis;
  String namaMajelis;
  String alamatMajelis;
  String created;
  String createdBy;
  String updated;
  String updatedBy;
  String idMasjid;

  TMajelis(
      {this.idMajelis,
      this.namaMajelis,
      this.alamatMajelis,
      this.created,
      this.createdBy,
      this.updated,
      this.updatedBy,
      this.idMasjid});

  TMajelis.fromJson(Map<String, dynamic> json) {
    idMajelis = json['id_majelis'];
    namaMajelis = json['nama_majelis'];
    alamatMajelis = json['alamat_majelis'];
    created = json['created'];
    createdBy = json['created_by'];
    updated = json['updated'];
    updatedBy = json['updated_by'];
    idMasjid = json['id_masjid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_majelis'] = this.idMajelis;
    data['nama_majelis'] = this.namaMajelis;
    data['alamat_majelis'] = this.alamatMajelis;
    data['created'] = this.created;
    data['created_by'] = this.createdBy;
    data['updated'] = this.updated;
    data['updated_by'] = this.updatedBy;
    data['id_masjid'] = this.idMasjid;
    return data;
  }
}
