import 'package:apppengelolaan/anggota/anggotaView.dart';
import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/auth/api/dataMasjid.dart';
import 'package:apppengelolaan/auth/model/authData.dart';
import 'package:apppengelolaan/dasboard/home.dart';
import 'package:apppengelolaan/dasboard/menuDrawer.dart';
import 'package:apppengelolaan/dataArtikel/api/api_dataArtikel.dart';
import 'package:apppengelolaan/dataMajelis/api/api_dataMajelis.dart';
import 'package:apppengelolaan/profile/api/profileData.dart';
import 'package:apppengelolaan/profile/profile.dart';
import 'package:apppengelolaan/src/changeNotifierPublic.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:apppengelolaan/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

ApiLogin dataLogin;
AuthData authData;
DataProfile dataProfile;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //designSize: Size(750, 1334)
  // initializeDateFormatting("id_ID").then((_) => runApp(MyApp()));
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => HomePage()),
      Provider(create: (context) => MenuWidget()),
      Provider(create: (context) => ProfilePage()),
      Provider(create: (context) => DataMajelis()),
      Provider(create: (context) => AnggotaView()),
      Provider(create: (context) => DataArtikel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // notificationContext = context;
    // SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: routes,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('id', 'ID'),
        // ...
      ],
      theme: lightTheme,
      // ThemeData(primaryColor: Color(0xff29b3ac), accentColor: Color(0xffd1de56)),
      // home: LoginPage()
    );
  }
}
