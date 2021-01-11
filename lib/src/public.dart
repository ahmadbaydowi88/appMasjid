import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loadmore/loadmore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// enum KategoriMajelis { all, amatSegera, segera, biasa }
const List<String> kategori = ["Home", "Data Majelis"];
List<TabItem> tabItems = [
  TabItem(icon: MdiIcons.home, title: 'Home'),
  TabItem(icon: Icons.supervised_user_circle, title: 'Data Majelis'),
  TabItem(icon: Icons.account_circle, title: 'Artikel'),
];

const List<Color> fillColorButton = [
  Color(0xffdd4b39),
  Color(0xfff09c40),
  Color(0xff0073b7),
  Color(0xff34acde),
];
Widget buttonIcon({
  @required onPress(),
  Color fillColor = Colors.white,
  @required IconData icon,
  Color iconColor = Colors.black,
  Widget label,
  double iconSize = 35.0,
  bool showBadge = false,
  Widget badgeContent,
  Color badgeColor = Colors.red,
  EdgeInsetsGeometry padding,
}) {
  // label = label == null ?? Container();
  if (label == null) label = Container();
  if (padding == null) padding = EdgeInsets.all(8.0);
  return Padding(
    padding: padding,
    child: Column(
      children: [
        RawMaterialButton(
          onPressed: onPress,
          elevation: 1.0,
          fillColor: fillColor,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        label
      ],
    ),
  );
}

void showDialogTanya(
    {@required BuildContext context,
    String title = "",
    String description = "",
    String textButtonOK = "Ya",
    String textButtonCancel = "Batal",
    Color colorButtonOK = Colors.green,
    Color colorButtonCancel = Colors.red,
    onPressOK(),
    onPressCancel()}) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: title,
    desc: description,
    buttons: [
      DialogButton(
          child: Text(
            textButtonOK,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if (onPressOK != null) onPressOK();
          },
          color: colorButtonOK),
      DialogButton(
        child: Text(
          textButtonCancel,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          if (onPressCancel != null) onPressCancel();
        },
        color: colorButtonCancel,
      )
    ],
  ).show();
}

Widget viewLoaderData(BuildContext context, {Color color}) {
  return Center(
    child: SpinKitWave(
        color: color == null ? Theme.of(context).primaryColor : color),
  );
}

Widget viewNoData(BuildContext context) {
  return ListView(
    shrinkWrap: true,
    children: [
      Container(
        height: MediaQuery.of(context).size.height - 160,
        margin: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(MdiIcons.databaseSearch, size: 50, color: Colors.grey),
            SizedBox(
              height: 5,
            ),
            Text(
              "Tidak Ada Data",
              style: TextStyle().copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            )
          ],
        ),
      )
    ],
  );
}

class FileAttachment {
  String nama;
  String url;
  FileAttachment({this.nama, this.url});
}

String textLoadMore(LoadMoreStatus status) {
  switch (status) {
    case LoadMoreStatus.loading:
      return "Sedang memuat...";
      break;
    case LoadMoreStatus.nomore:
      return "Semua Data Telah Ditampilkan";
      break;
    case LoadMoreStatus.fail:
      return "Gagal memuat data!";
      break;
    default:
      return "";
  }
}

InputDecoration decorTextfield(
    BuildContext context, String labelName, Icon icon,
    {Widget iconSuffix}) {
  return InputDecoration(
      fillColor: Colors.black,
      labelText: labelName,
      labelStyle: TextStyle(color: Colors.white),
      errorStyle: TextStyle(color: Colors.red),
      prefixIcon: icon,
      suffixIcon: iconSuffix,
      enabledBorder: mainTextfielBorder(context,
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: mainTextfielBorder(context),
      errorBorder: mainTextfielBorder(context,
          borderSide: BorderSide(
            color: Colors.red,
          )),
      border: mainTextfielBorder(context, borderSide: null),
      isDense: true);
}

OutlineInputBorder mainTextfielBorder(BuildContext context,
    {BorderRadius borderRadius, BorderSide borderSide}) {
  if (borderRadius == null)
    borderRadius = BorderRadius.all(Radius.circular(8.0));
  if (borderSide == null) borderSide = BorderSide(color: Colors.grey);
  return OutlineInputBorder(
    borderRadius: borderRadius,
    borderSide: borderSide,
  );
}

Widget viewErrorLoadData(BuildContext context, {String error = ""}) {
  if (error != "") error = "\n[" + error + "]";
  return ListView(
    shrinkWrap: true,
    children: [
      Container(
        height: MediaQuery.of(context).size.height - 160,
        margin: EdgeInsets.all(25),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(MdiIcons.alertCircle, size: 50, color: Colors.grey),
              SizedBox(
                width: 10,
              ),
              Text(
                "Tidak Dapat Terhubung Dengan Server,\nMohon Untuk Periksa Koneksi Internet Anda\nDan Coba Lagi.$error",
                style: TextStyle()
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      )
    ],
  );
}

void showErrorFlushbar(
    {@required BuildContext context,
    @required String title,
    @required String message,
    Duration duration,
    onStatusChanged(FlushbarStatus status)}) {
  if (duration == null) duration = Duration(seconds: 3);
  Flushbar(
          shouldIconPulse: true,
          title: title,
          icon: Icon(
            MdiIcons.alert,
            color: Colors.white,
          ),
          message: message,
          backgroundColor: Colors.red,
          duration: duration,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          onStatusChanged: onStatusChanged)
      .show(context);
}

void showSuccessFlushbar(
    {@required BuildContext context,
    @required String title,
    @required String message,
    Duration duration,
    onStatusChanged(FlushbarStatus status)}) {
  if (duration == null) duration = Duration(seconds: 3);
  Flushbar(
          shouldIconPulse: true,
          title: title,
          icon: Icon(
            MdiIcons.check,
            color: Colors.white,
          ),
          message: message,
          backgroundColor: Colors.green,
          duration: duration,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          onStatusChanged: onStatusChanged)
      .show(context);
}
