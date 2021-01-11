import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/view/itemsDetail.dart';
import 'package:flutter/material.dart';

class CardSurat extends StatefulWidget {
  final List<ItemsDetail> items;
  final List<FileAttachment> files;
  final double elevation;
  final Color backgroundColor;
  final Widget footer;
  CardSurat(
      {Key key,
      @required this.items,
      this.files,
      this.footer,
      this.elevation = 4,
      this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  CardSuratState createState() => CardSuratState();
}

class CardSuratState extends State<CardSurat> {
  List<FileAttachment> _files;
  @override
  Widget build(BuildContext context) {
    if (widget.files == null)
      _files = List();
    else
      _files = widget.files;
    return Card(
      margin: EdgeInsets.all(8),
      elevation: widget.elevation,
      color: widget.backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: _files.length == 0 && widget.footer == null ? 8 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DetailItems(items: widget.items),
            _files.length == 0 && widget.footer == null
                ? Container()
                : Divider(
                    color: Colors.grey,
                  ),
            // _files.length == 0
            //     ? Container()
            //     : ListFiles(
            //         files: widget.files,
            //       ),
            _files.length == 0 || widget.footer == null
                ? Container(
                    margin: EdgeInsets.only(bottom: 8),
                  )
                : Divider(
                    color: Colors.grey,
                  ),
            widget.footer == null ? Container() : widget.footer
          ],
        ),
      ),
    );
  }
}
