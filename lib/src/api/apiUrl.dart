import 'package:apppengelolaan/src/api/api.dart';

class UrlApi {
  UrlApi();
  String login = API_HOST + "user/login";
  String dataAnggota = API_HOST + "user/all";
  String addAnggota = API_HOST + "user/add";
  String deleteAnggota = API_HOST + "user/delete";
  String dataAgenda = API_HOST + "t_kegiatan/all";
  String addAgenda = API_HOST + "t_kegiatan/add";
  String aditAgenda = API_HOST + "t_kegiatan/update";
  String deleteAgenda = API_HOST + "t_kegiatan/delete";
  String dataProfile = API_HOST + "user/profile";
  String register = API_HOST + "user/register";
  String updateProfile = API_HOST + "user/update_user_profile";
  String dataMajelis = API_HOST + "t_majelis/all";
  String addDataMajelis = API_HOST + "t_majelis/add";
  String editDataMajelis = API_HOST + "t_majelis/update";
  String deleteDataMajelis = API_HOST + "t_majelis/delete";
  String dataArtikel = API_HOST + "t_artikel/all";
  String addArtikel = API_HOST + "t_artikel/add";
  String deleteArtikel = API_HOST + "t_artikel/delete";
  String masjidAll = API_HOST + "t_masjid/all";
  String groupAll = API_HOST + "group/all";
}

UrlApi urlApi = UrlApi();
