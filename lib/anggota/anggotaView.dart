import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:apppengelolaan/anggota/api/dataUserApi.dart';
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
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loadmore/loadmore.dart';

class AnggotaView extends StatefulWidget {
  @override
  _AnggotaViewState createState() => _AnggotaViewState();
}

class _AnggotaViewState extends State<AnggotaView>
    with AfterLayoutMixin<AnggotaView> {
  bool isLoaded = false;
  bool isError = false;
  int currentLimit = 0;
  String strSearch = "";
  int maxData = 0;
  bool _showButton = true;
  DataUser dataUser;
  bool isSaving = false;
  static const int dataPerPage = 10;

  Future<bool> nextPage() async {
    currentLimit += dataPerPage;
    await refreshData(limit: currentLimit);
    return true;
  }

  Future<bool> refreshData({int limit = -1, bool setNull = false}) async {
    if (setNull) {
      setState(() {
        dataUser = null;
      });
    }
    if (limit == -1) {
      currentLimit = dataPerPage;
      limit = dataPerPage;
    }
    await getData(
      url: urlApi.dataAnggota,
      params: {
        "limit": limit.toString(),
      },
      onComplete: (data, statusCode) {
        print(data);
        if (statusCode == 200) {
          dataUser = DataUser.fromJson(jsonDecode(data));
          maxData = dataUser.total;
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
        title: "Detail Anggota Masjid",
      ),
      body: LiquidPullToRefresh(
          color: Theme.of(context).primaryColor,
          animSpeedFactor: 2,
          showChildOpacityTransition: true,
          child: dataUser != null
              ? dataUser.data.user.length == 0
                  ? viewNoData(context)
                  : LoadMore(
                      whenEmptyLoad: true,
                      isFinish: currentLimit >= maxData,
                      textBuilder: textLoadMore,
                      onLoadMore: () => nextPage(),
                      child: _buildListView())
              : viewLoaderData(context),
          onRefresh: refreshData),
      floatingActionButton: dataLogin.data.jabatan == 'Jamaah'
          ? Container()
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(getRoutesName(RoutesName.addAnggota));
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
        return Container(
          margin: EdgeInsets.only(
              bottom: index == dataUser.data.user.length - 1 ? 10 : 0),
          child: CardSurat(
            items: [
              ItemsDetail(
                LineAwesomeIcons.user_tag,
                "Nama Anggota",
                dataUser.data.user[index].fullName,
              ),
              ItemsDetail(
                LineAwesomeIcons.map_marker,
                "Alamat Email",
                dataUser.data.user[index].email,
              ),
              ItemsDetail(
                LineAwesomeIcons.user_graduate,
                "Jabatan",
                dataUser.data.user[index].jabatan,
              ),
              ItemsDetail(
                LineAwesomeIcons.mosque,
                "Masjid",
                dataUser.data.user[index].namaMasjid,
              ),
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
                                  context, dataUser.data.user[index].id, index),
                            )
                          : Container(),
                ],
              ),
            ),
            // footer: Padding(
            //   padding: const EdgeInsets.only(bottom: 8),
            //   child: Align(
            //       alignment: Alignment.centerRight,
            //       child: ,),
            // )
            // _buildCard(data, index, context)
          ),
        );
      },
      itemCount: dataUser.data.user.length,
    );
  }

  Widget _buttonAction(BuildContext context, String idMajelis, int index) {
    return Row(
      children: [
        // RaisedButton.icon(
        //     elevation: 0,
        //     color: Color(0xff07bfe1),
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10.0)),
        //     onPressed: () async {},
        //     icon: Icon(
        //       FontAwesome.edit,
        //       color: Colors.white,
        //     ),
        //     label: Text(
        //       "Edit",
        //       style: TextStyle().copyWith(color: Colors.white),
        //     )),
        // SizedBox(
        //   width: 20,
        // ),
        RaisedButton.icon(
          elevation: 0,
          color: Color(0xffe3001a),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () async {
            showDialogTanya(
              context: context,
              title: "Delete",
              description: "Apakah Kamu ingin Delete Data ini?",
              onPressOK: () async {
                await postData(
                  url: urlApi.deleteAnggota,
                  data: {
                    "id": dataUser.data.user[index].id,
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
                    setState(() {
                      isSaving = false;
                    });
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
