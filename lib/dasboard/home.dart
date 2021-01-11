import 'package:after_layout/after_layout.dart';
import 'package:apppengelolaan/dasboard/menuDrawer.dart';
import 'package:apppengelolaan/dasboard/viewcalendar.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/profile/api/profileData.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  // String username;
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  // DateTime _currentDate = new DateTime.now();
  static BuildContext thisContext;
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ViewCalendarState> _keyCalendar =
      GlobalKey<ViewCalendarState>();
  bool _dataLoaded = false;
  Future<void> refreshData() async {
    dataProfile = await getDataProfile();
    setState(() {
      _dataLoaded = true;
      Future.delayed(Duration(seconds: 1))
          .then((value) => _keyCalendar.currentState.getAgenda());
    });
  }

  List<String> nameMenu = [
    "Data Majelis",
    "kegiatan",
    "Artikel",
  ];

  List<IconData> iconMenu = [
    LineAwesomeIcons.mosque,
    Icons.event,
    LineAwesomeIcons.newspaper
  ];

  List<Function> onPressMenu = [
    () => Navigator.of(thisContext)
        .pushNamed(getRoutesName(RoutesName.listMajelis)),
    () => Navigator.of(thisContext)
        .pushNamed(getRoutesName(RoutesName.dataAgenda)),
    () => Navigator.of(thisContext)
        .pushNamed(getRoutesName(RoutesName.listArtikel)),
  ];

  @override
  Widget build(BuildContext context) {
    thisContext = context;
    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true, // default false
      swipe: true, // default true
      colorTransitionChild: Colors.white, // default Color.black54
      colorTransitionScaffold: Colors.black54, // default Color.black54
      // borderRadius: 50, // default 0
      leftAnimationType: InnerDrawerAnimation.linear, // default static
      rightAnimationType: InnerDrawerAnimation.quadratic,
      innerDrawerCallback: (a) =>
          print(a), // return  true (open) or false (close)
      leftChild: MenuWidget(
        closeDrawerCallback: () => _innerDrawerKey.currentState.close(),
      ),
      scaffold: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: true,
          title: Text("Aplikasi Masjid"),
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // _scaffoldKey.currentState.openDrawer();
                // setState(() {
                if (_innerDrawerKey.currentState.mounted) {
                  _innerDrawerKey.currentState.open();
                }
                // });
              }),
        ),
        body: !_dataLoaded
            ? viewLoaderData(context)
            : AbsorbPointer(
                absorbing: false,
                child: LiquidPullToRefresh(
                  showChildOpacityTransition: true,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      buttonMenu(),
                      ViewCalendar(
                        key: _keyCalendar,
                      ),
                    ],
                  ),
                  onRefresh: () => refreshData(),
                  color: Theme.of(context).primaryColor,
                  animSpeedFactor: 2,
                ),
              ),
      ),
    );
  }

  Widget buttonMenu() {
    List<Widget> b = [];
    for (int i = 0; i < nameMenu.length; i++) {
      b.add(
        buttonIcon(
          onPress: onPressMenu[i],
          icon: iconMenu[i],
          label: Text(
            nameMenu[i],
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return Container(
      height: 130,
      padding: EdgeInsets.all(10),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: b,
        ),
      ),
    );
  }

  Widget mainMenuIcon({
    @required Size deviceSize,
    @required String text,
    @required String src,
  }) {
    return Container(
      padding: EdgeInsets.all(6.0),
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 80,
              width: 80,
              child: Image.asset(src),
            ),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(Duration(seconds: 1)).then((value) => refreshData());
  }
}
