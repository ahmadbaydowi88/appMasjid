import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:apppengelolaan/agenda/api/api_dataAgenda.dart';
import 'package:apppengelolaan/agenda/view/editAgenda.dart';
import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:apppengelolaan/src/view/appbar.dart';
import 'package:apppengelolaan/src/view/cardSurat.dart';
import 'package:apppengelolaan/src/view/itemsDetail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loadmore/loadmore.dart';

class AgendaView extends StatefulWidget {
  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView>
    with AfterLayoutMixin<AgendaView> {
  bool isLoaded = false;
  bool isError = false;
  int maxData = 0;
  int currentLimit = 0;
  String strSearch = "";
  bool _showButton = true;
  DataAgenda allAgenda;
  static const int dataPerPage = 10;

  Future<bool> nextPage() async {
    currentLimit += dataPerPage;
    await refreshData(limit: currentLimit);
    return true;
  }

  Future<bool> refreshData({int limit = -1, bool setNull = false}) async {
    if (setNull) {
      setState(() {
        allAgenda = null;
      });
    }
    if (limit == -1) {
      currentLimit = dataPerPage;
      limit = dataPerPage;
    }
    await getData(
      url: urlApi.dataAgenda,
      params: {
        // "id": dataLogin.data.id,
        "limit": limit.toString(),
      },
      onComplete: (data, statusCode) {
        print(data);
        if (statusCode == 200) {
          allAgenda = DataAgenda.fromJson(jsonDecode(data));
          maxData = allAgenda.total;
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

  void tanyakeluar() {
    if (isLoaded) {
      Navigator.of(context).pop();
    } else {
      showDialogTanya(
          context: context,
          colorButtonOK: Colors.red,
          colorButtonCancel: Colors.green,
          description: "Data Anda Tidak Tersimpan\nLanjutkan ?",
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
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppbarMain(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: "Detail Kegiatan",
        ),
        body: LiquidPullToRefresh(
            color: Theme.of(context).primaryColor,
            animSpeedFactor: 2,
            showChildOpacityTransition: true,
            child: allAgenda != null
                ? allAgenda.data.tKegiatan.length == 0
                    ? viewNoData(context)
                    : LoadMore(
                        whenEmptyLoad: true,
                        isFinish: currentLimit >= maxData,
                        textBuilder: textLoadMore,
                        onLoadMore: () => nextPage(),
                        child: _buildListView())
                : viewLoaderData(context),
            onRefresh: () => refreshData()),
        floatingActionButton: dataLogin.data.jabatan == 'Jamaah'
            ? Container()
            : FloatingActionButton.extended(
                onPressed: () => Navigator.of(context).pushNamed(
                  getRoutesName(RoutesName.addAgenda),
                ),
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
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
              bottom: index == allAgenda.data.tKegiatan.length - 1 ? 10 : 0),
          child: CardSurat(
            items: [
              ItemsDetail(Icons.near_me, "Nama Kegiatan",
                  allAgenda.data.tKegiatan[index].namaKegiatan),
              ItemsDetail(Icons.home, "Keterangan",
                  allAgenda.data.tKegiatan[index].keterangan),
              ItemsDetail(Icons.date_range, "Dari",
                  allAgenda.data.tKegiatan[index].tglAwal),
              ItemsDetail(Icons.date_range, "Sampai",
                  allAgenda.data.tKegiatan[index].tglAkhir),
            ],
            footer: Container(
              margin: EdgeInsets.only(bottom: _showButton ? 0 : 8),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  dataLogin.data.jabatan == 'Jamaah'
                      ? Container()
                      : _showButton
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: _buttonAction(
                                  context,
                                  allAgenda.data.tKegiatan[index].idKegiatan,
                                  index),
                            )
                          : Container(),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: allAgenda.data.tKegiatan.length,
    );
  }

  Widget _buttonAction(BuildContext context, String idAgenda, int index) {
    return Row(
      children: [
        RaisedButton.icon(
          elevation: 0,
          color: Color(0xff07bfe1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () => Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => new EditAgenda(
                dataAgenda: allAgenda,
                index: index,
              ),
            ),
          ),
          icon: Icon(
            FontAwesomeIcons.edit,
            color: Colors.white,
          ),
          label: Text(
            "Edit",
            style: TextStyle().copyWith(color: Colors.white),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        RaisedButton.icon(
          elevation: 0,
          color: Color(0xffff0000),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () async {
            showDialogTanya(
              context: context,
              title: "Delete",
              description: "Apakah Kamu ingin Delete Data ini?",
              onPressOK: () async {
                await postData(
                  url: urlApi.deleteAgenda,
                  data: {
                    "id_kegiatan": allAgenda.data.tKegiatan[index].idKegiatan,
                  },
                  onComplete: (data, statusCode) {
                    print(data);
                    Navigator.of(context).pop<bool>(true);
                    showSuccessFlushbar(
                        context: context,
                        title: "Sukses",
                        message: "Data Berhasil Di Hapus.");
                    refreshData();
                  },
                  onError: (error) {
                    print(error);

                    showErrorFlushbar(
                        context: context,
                        title: "Error",
                        message:
                            "Data Tidak Dapat Disimpan!\nHarap Periksa Koneksi Internet Anda,Dan Coba Lagi.");
                  },
                );
              },
              onPressCancel: () => Navigator.of(context).pop(),
            );
          },
          icon: Icon(
            FontAwesomeIcons.trash,
            color: Colors.white,
          ),
          label: Text(
            "Hapus",
            style: TextStyle().copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    refreshData();
  }
}
