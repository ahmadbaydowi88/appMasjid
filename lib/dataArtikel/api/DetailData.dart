import 'package:apppengelolaan/dataArtikel/api/api_dataArtikel.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/view/appbar.dart';
import 'package:flutter/material.dart';

class ListDetail extends StatefulWidget {
  final DataArtikel dataArtikel;
  final int index;

  ListDetail({Key key, this.dataArtikel, this.index}) : super(key: key);
  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  bool isError = false;
  bool isLoaded = false;
  void tanyakeluar() {
    if (isError) {
      Navigator.of(context).pop();
    } else {
      showDialogTanya(
          context: context,
          colorButtonOK: Colors.red,
          colorButtonCancel: Colors.green,
          description: "Apakah anda sudah selesai membaca ?",
          title: "Keluar",
          onPressOK: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          onPressCancel: () {
            Navigator.of(context).pop();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        tanyakeluar();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppbarMain(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: "Detail Artikel",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    widget.dataArtikel.data.tArtikel[widget.index].judul,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Image.network(
                      widget.dataArtikel.data.tArtikel[widget.index].avatar),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    widget.dataArtikel.data.tArtikel[widget.index].isi,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
