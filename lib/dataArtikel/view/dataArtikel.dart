import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/dataArtikel/api/DetailData.dart';
import 'package:apppengelolaan/dataArtikel/api/api_dataArtikel.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:apppengelolaan/src/view/appbar.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loadmore/loadmore.dart';

class ListDataArtikel extends StatefulWidget {
  ListDataArtikel({Key key}) : super(key: key);
  @override
  _ListDataArtikelState createState() => _ListDataArtikelState();
}

class _ListDataArtikelState extends State<ListDataArtikel>
    with AfterLayoutMixin<ListDataArtikel> {
  bool isLoaded = false;
  bool isError = false;
  int maxData = 0;
  int currentLimit = 0;
  String strSearch = "";
  static const int dataPerPage = 10;
  DataArtikel dataArtikel;

  Future<bool> nextPage() async {
    currentLimit += dataPerPage;
    await refreshData(limit: currentLimit);
    return true;
  }

  Future<bool> refreshData({int limit = -1, bool setNull = false}) async {
    if (setNull) {
      setState(() {
        dataArtikel = null;
      });
    }
    if (limit == -1) {
      currentLimit = dataPerPage;
      limit = dataPerPage;
    }
    await getData(
      url: urlApi.dataArtikel,
      params: {
        "id": dataLogin.data.id,
        "limit": limit.toString(),
      },
      onComplete: (data, statusCode) {
        print(data);
        if (statusCode == 200) {
          dataArtikel = DataArtikel.fromJson(jsonDecode(data));
          maxData = dataArtikel.total;
          setState(() {
            isLoaded = true;
          });
        }
      },
      onError: (error) {
        setState(() {
          isError = true;
        });
      },
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarMain(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "Artikel Islam",
      ),
      body: LiquidPullToRefresh(
        color: Theme.of(context).primaryColor,
        animSpeedFactor: 2,
        showChildOpacityTransition: true,
        child: dataArtikel != null
            ? dataArtikel.data.tArtikel.length == 0
                ? viewNoData(context)
                : LoadMore(
                    whenEmptyLoad: true,
                    isFinish: currentLimit >= maxData,
                    textBuilder: textLoadMore,
                    onLoadMore: () => nextPage(),
                    child: _buildListView())
            : viewLoaderData(context),
        onRefresh: () => refreshData(),
      ),
      floatingActionButton: dataLogin.data.jabatan == 'Jamaah'
          ? Container()
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(getRoutesName(RoutesName.addArtikel));
              },
              backgroundColor: Color(0xff167a3c),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text(
                "Tambah Data",
                style: TextStyle().copyWith(color: Colors.white),
              ),
            ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
          // onDismissed: (DismissDirection direction) {
          //   setState(() {
          //     dataArtikel.data.tArtikel.removeAt(index);
          //   });
          // },
          secondaryBackground: slideLeftBackground(),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              final bool res = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                        "Anda yakin ingin menghapus artikel ${dataArtikel.data.tArtikel[index].judul}?",
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            setState(() {
                              dataArtikel.data.tArtikel.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              return res;
            }
          },
          key: UniqueKey(),
          background: slideLeftBackground(),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ListDetail(
                      dataArtikel: dataArtikel,
                      index: index,
                    ))),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Container(
                height: 150,
                margin: EdgeInsets.only(
                    bottom:
                        index == dataArtikel.data.tArtikel.length - 1 ? 10 : 0),
                child: Card(
                  color: Colors.white,
                  elevation: 3.0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 140,
                            width: 150.0,
                            child: Image.network(
                              dataArtikel.data.tArtikel[index].avatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                // Container(
                                //   width: 150.0,
                                //   child: Image.network(
                                //     dataArtikel.data.tArtikel[index].avatar,
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  child: Text(
                                    dataArtikel.data.tArtikel[index].judul,
                                    style: new TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      dataArtikel.data.tArtikel[index].created,
                                      style: new TextStyle(
                                          color: Colors.black, fontSize: 10.0),
                                    ),
                                    Text(
                                      "Lanjut Baca",
                                      style: new TextStyle(
                                          color: Colors.black, fontSize: 10.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: dataArtikel.data.tArtikel.length,
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    refreshData();
  }
}
