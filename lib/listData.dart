import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget buildItemData(
    {@required String labelName,
    @required String isi,
    @required IconData iconLabel,
    @required BuildContext context,
    double fontSize,
    double width,
    int splitWidth = 2,
    int maxLineIsi = 3,
    Color labelColor = Colors.black,
    Color isiColor = Colors.grey}) {
  if (isi == null) isi = "";
  if (width == null) width = MediaQuery.of(context).size.width;
  if (labelColor == null) labelColor = Colors.black;
  if (isiColor == null) isiColor = Colors.grey;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconLabel,
            color: labelColor,
            size: 25,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            labelName,
            style: TextStyle().copyWith(
              color: labelColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      GestureDetector(
        onTap: () {
          // var alertStyle = AlertStyle(
          //   // animationType: AnimationType.shrink,
          //   isCloseButton: false,
          //   isOverlayTapDismiss: false,
          //   descStyle: TextStyle(fontWeight: FontWeight.bold),
          //   animationDuration: Duration(milliseconds: 400),
          //   alertBorder: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(15.0),
          //     side: BorderSide(
          //       color: Colors.grey,
          //     ),
          //   ),
          // );

          Alert(
              style: AlertStyle(),
              context: context,
              type: AlertType.none,
              title: labelName,
              desc: isi,
              buttons: [
                DialogButton(
                    color: Colors.red,
                    child: Text("Tutup",
                        style: TextStyle().copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ]).show();
        },
        child: Container(
          // color: Colors.red,
          width: width / splitWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 29, bottom: 5),
            child: Text(
              isi,
              textAlign: TextAlign.start,
              style: TextStyle().copyWith(
                fontWeight: FontWeight.bold,
                color: isiColor,
                fontSize: fontSize,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: maxLineIsi,
            ),
          ),
        ),
      )
    ],
  );
}
