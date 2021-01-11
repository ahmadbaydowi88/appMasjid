import 'package:apppengelolaan/agenda/view/addAgenda.dart';
import 'package:apppengelolaan/agenda/view/dataAgenda.dart';
import 'package:apppengelolaan/anggota/anggotaView.dart';
import 'package:apppengelolaan/anggota/view/addAnggota.dart';
import 'package:apppengelolaan/auth/signup.dart';
import 'package:apppengelolaan/dasboard/home.dart';
import 'package:apppengelolaan/dataArtikel/api/addArtikel.dart';
import 'package:apppengelolaan/dataArtikel/view/dataArtikel.dart';
import 'package:apppengelolaan/dataMajelis/view/dataMajelis.dart';
import 'package:apppengelolaan/dataMajelis/view/addDataMajelis.dart.bak';
import 'package:apppengelolaan/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:apppengelolaan/landing/welcome.dart';
import 'package:apppengelolaan/auth/login.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => MainPage(),
  '/login': (context) => LoginPage(),
  '/home': (context) => HomePage(),
  '/signup': (context) => SignupPage(),
  '/profile': (context) => ProfilePage(),
  '/addMajelis': (context) => AddMajelis(),
  '/addArtikel': (context) => AddArtikel(),
  '/allAgenda': (context) => AgendaView(),
  '/addAgenda': (context) => AddAgenda(),
  '/listMajelis': (context) => ListDataMajelis(),
  '/dataAgenda': (context) => AgendaView(),
  '/dataAnggota': (context) => AnggotaView(),
  '/addAnggota': (context) => AddAnggota(),
  '/listArtikel': (context) => ListDataArtikel(),
};

enum RoutesName {
  mainPage,
  loginPage,
  homePage,
  signupPage,
  profilePage,
  addMajelis,
  addArtikel,
  allAgenda,
  addAgenda,
  listMajelis,
  dataAgenda,
  dataAnggota,
  addAnggota,
  listArtikel,
}
String getRoutesName(RoutesName routesName) {
  return routes.keys.toList()[routesName.index];
}
