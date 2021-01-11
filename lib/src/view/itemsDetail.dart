import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apppengelolaan/listData.dart';

class ItemsDetail {
  final IconData icon;
  final String labelName;
  final String value;
  final double fontSize;
  final Color labelColor;
  final Color valueColor;
  ItemsDetail(
    this.icon,
    this.labelName,
    this.value, {
    this.fontSize,
    this.labelColor,
    this.valueColor,
  });
}

class DetailItems extends StatelessWidget {
  final List<ItemsDetail> items;
  final double width;
  DetailItems({Key key, @required this.items, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double thisWidth =
        width == null ? MediaQuery.of(context).size.width : width;
    List<Widget> r = List();
    for (int i = 0; i < items.length; i++) {
      if (i % 2 == 1) {
        r.add(Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            items[i - 1] == null
                ? Container()
                : buildItemData(
                    labelColor: items[i - 1].labelColor,
                    isiColor: items[i - 1].valueColor,
                    fontSize: items[i - 1].fontSize,
                    width: thisWidth,
                    splitWidth: items[i] == null ? 1 : 2,
                    context: context,
                    labelName: items[i - 1].labelName,
                    isi: items[i - 1].value,
                    iconLabel: items[i - 1].icon),
            SizedBox(
              width: 10,
            ),
            items[i] == null
                ? Container()
                : buildItemData(
                    labelColor: items[i].labelColor,
                    isiColor: items[i].valueColor,
                    fontSize: items[i].fontSize,
                    width: thisWidth,
                    context: context,
                    labelName: items[i].labelName,
                    isi: items[i].value,
                    iconLabel: items[i].icon),
          ],
        ));
      }
    }
    if (items.length % 2 == 1) {
      r.add(
        buildItemData(
            labelColor: items[items.length - 1].labelColor,
            isiColor: items[items.length - 1].valueColor,
            fontSize: items[items.length - 1].fontSize,
            width: thisWidth,
            splitWidth: 1,
            maxLineIsi: 5,
            context: context,
            labelName: items[items.length - 1].labelName,
            isi: items[items.length - 1].value,
            iconLabel: items[items.length - 1].icon),
      );
    }
    return FittedBox(
      fit: BoxFit.fill,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: r,
      ),
    );
  }
}
