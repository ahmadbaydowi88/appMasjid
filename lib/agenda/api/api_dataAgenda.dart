class DataAgenda {
  bool status;
  String message;
  Data data;
  int total;

  DataAgenda({this.status, this.message, this.data, this.total});

  DataAgenda.fromJson(Map<String, dynamic> json) {
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
  List<TKegiatan> tKegiatan;

  Data({this.tKegiatan});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['t_kegiatan'] != null) {
      tKegiatan = new List<TKegiatan>();
      json['t_kegiatan'].forEach((v) {
        tKegiatan.add(new TKegiatan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tKegiatan != null) {
      data['t_kegiatan'] = this.tKegiatan.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TKegiatan {
  String idKegiatan;
  String namaKegiatan;
  String keterangan;
  String tglAkhir;
  String created;
  String createdBy;
  String id;
  String tglAwal;

  TKegiatan(
      {this.idKegiatan,
      this.namaKegiatan,
      this.keterangan,
      this.tglAkhir,
      this.created,
      this.createdBy,
      this.id,
      this.tglAwal});

  TKegiatan.fromJson(Map<String, dynamic> json) {
    idKegiatan = json['id_kegiatan'];
    namaKegiatan = json['nama_kegiatan'];
    keterangan = json['keterangan'];
    tglAkhir = json['tgl_akhir'];
    created = json['created'];
    createdBy = json['created_by'];
    id = json['id'];
    tglAwal = json['tgl_awal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_kegiatan'] = this.idKegiatan;
    data['nama_kegiatan'] = this.namaKegiatan;
    data['keterangan'] = this.keterangan;
    data['tgl_akhir'] = this.tglAkhir;
    data['created'] = this.created;
    data['created_by'] = this.createdBy;
    data['id'] = this.id;
    data['tgl_awal'] = this.tglAwal;
    return data;
  }
}
