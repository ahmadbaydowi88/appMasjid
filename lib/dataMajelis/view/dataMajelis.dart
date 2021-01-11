import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/dataMajelis/api/api_dataMajelis.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/view/appbar.dart';
import 'package:apppengelolaan/src/view/cardSurat.dart';
import 'package:apppengelolaan/src/view/itemsDetail.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loadmore/loadmore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ListDataMajelis extends StatefulWidget {
  @override
  _ListDataMajelisState createState() => _ListDataMajelisState();
}

class _ListDataMajelisState extends State<ListDataMajelis>
    with AfterLayoutMixin<ListDataMajelis> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();
  bool isLoaded = false;
  bool isError = false;
  int maxData = 0;
  int currentLimit = 0;
  String strSearch = "";
  bool _showButton = true;
  final FocusNode _alamatFocusNode = FocusNode();
  final FocusNode _majelisFocusNode = FocusNode();
  static const int dataPerPage = 10;
  DataMajelis dataMajelis;
  Future<bool> nextPage() async {
    currentLimit += dataPerPage;
    await refreshData(limit: currentLimit);
    return true;
  }

  bool isSaving = false;
  Future<bool> refreshData({int limit = -1, bool setNull = false}) async {
    if (setNull) {
      setState(() {
        dataMajelis = null;
      });
    }
    if (limit == -1) {
      currentLimit = dataPerPage;
      limit = dataPerPage;
    }
    await getData(
      url: urlApi.dataMajelis,
      params: {
        "id": dataLogin.data.id,
        "limit": limit.toString(),
      },
      onComplete: (data, statusCode) {
        print(data);
        if (statusCode == 200) {
          dataMajelis = DataMajelis.fromJson(jsonDecode(data));
          maxData = dataMajelis.total;
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
        title: "Detail Majelis",
      ),
      body: LiquidPullToRefresh(
        color: Theme.of(context).primaryColor,
        animSpeedFactor: 2,
        showChildOpacityTransition: true,
        child: dataMajelis != null
            ? dataMajelis.data.tMajelis.length == 0
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
                _showDialogTambah();
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
              bottom: index == dataMajelis.data.tMajelis.length - 1 ? 10 : 0),
          child: CardSurat(
            items: [
              ItemsDetail(Icons.near_me, "Nama Majelis",
                  dataMajelis.data.tMajelis[index].namaMajelis),
              ItemsDetail(Icons.home, "Alamat Majelis",
                  dataMajelis.data.tMajelis[index].alamatMajelis),
              ItemsDetail(Icons.date_range, "Tanggal Daftar",
                  dataMajelis.data.tMajelis[index].created),
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
                                  dataMajelis.data.tMajelis[index].idMajelis,
                                  index),
                            )
                          : Container(),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: dataMajelis.data.tMajelis.length,
    );
  }

  Widget _buttonAction(BuildContext context, String idMajelis, int index) {
    return Row(
      children: [
        RaisedButton.icon(
            elevation: 0,
            color: Color(0xff07bfe1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: () async {
              Alert(
                context: context,
                title: "Edit Data Majelis",
                buttons: [],
                style: AlertStyle(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    titleStyle: TextStyle(color: Colors.white),
                    alertPadding: EdgeInsets.all(0),
                    isCloseButton: false,
                    isOverlayTapDismiss: false,
                    isButtonVisible: false,
                    buttonAreaPadding: EdgeInsets.all(0),
                    constraints: BoxConstraints.expand(
                      width: 300,
                    ),
                    //First to chars "55" represents transparency of color
                    overlayColor: Color(0x55000000),
                    alertElevation: 0,
                    alertAlignment: Alignment.center),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return FormBuilder(
                      key: _key,
                      initialValue: {
                        "nama_majelis":
                            dataMajelis.data.tMajelis[index].namaMajelis,
                        "alamat_majelis":
                            dataMajelis.data.tMajelis[index].alamatMajelis
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          FormBuilderTextField(
                            readOnly: isSaving,
                            attribute: "nama_majelis",
                            textInputAction: TextInputAction.next,
                            focusNode: _majelisFocusNode,
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Kolom Ini Dibutuhkan!"),
                            ],
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_alamatFocusNode);
                            },
                            decoration: _decorTextfield(context, "Nama Majelis",
                                Icons.supervised_user_circle),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FormBuilderTextField(
                            readOnly: isSaving,
                            attribute: "alamat_majelis",
                            textInputAction: TextInputAction.next,
                            focusNode: _alamatFocusNode,
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Kolom Ini Dibutuhkan!"),
                            ],
                            decoration: _decorTextfield(
                                context, "Alamat", FontAwesomeIcons.map),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ArgonButton(
                                  borderRadius: 5,
                                  color: Color(0xffff0000),
                                  height: 40,
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cancel, color: Colors.white),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Batal",
                                          style: TextStyle()
                                              .copyWith(color: Colors.white))
                                    ],
                                  ),
                                  onTap: (startLoading, stopLoading, btnState) {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                ArgonButton(
                                  borderRadius: 5,
                                  color: Color(0xff167a3c),
                                  height: 40,
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check, color: Colors.white),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("OK",
                                          style: TextStyle()
                                              .copyWith(color: Colors.white))
                                    ],
                                  ),
                                  loader: SpinKitRipple(
                                    color: Colors.white,
                                  ),
                                  onTap: (startLoading, stopLoading,
                                      btnState) async {
                                    print(_key
                                        .currentState.value['nama_majelis']);
                                    if (_key.currentState.saveAndValidate()) {
                                      setState(() {
                                        isSaving = true;
                                      });
                                      startLoading();
                                      await postData(
                                        url: urlApi.editDataMajelis,
                                        data: {
                                          "id_majelis": dataMajelis
                                              .data.tMajelis[index].idMajelis,
                                          "nama_majelis": _key.currentState
                                              .value['nama_majelis'],
                                          "alamat_majelis": _key.currentState
                                              .value['alamat_majelis'],
                                          "updated": DateTime.now(),
                                          "updated_by": dataLogin.data.id,
                                          "id_masjid": dataLogin.data.idMasjid
                                        },
                                        onComplete: (data, statusCode) {
                                          print(data);
                                          Navigator.of(context).pop<bool>(true);
                                          showSuccessFlushbar(
                                              context: context,
                                              title: "Sukses",
                                              message:
                                                  "Data Majelis Berhasil Disimpan.");
                                          refreshData();
                                        },
                                        onError: (error) {
                                          setState(() {
                                            isSaving = false;
                                          });
                                          print(error);

                                          stopLoading();
                                          showErrorFlushbar(
                                              context: context,
                                              title: "Error",
                                              message:
                                                  "Data Tidak Dapat Disimpan!\nHarap Periksa Koneksi Internet Anda,Dan Coba Lagi.");
                                        },
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ).show();
            },
            icon: Icon(
              FontAwesomeIcons.edit,
              color: Colors.white,
            ),
            label: Text(
              "Edit",
              style: TextStyle().copyWith(color: Colors.white),
            )),
        SizedBox(
          width: 20,
        ),
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
                  url: urlApi.deleteDataMajelis,
                  data: {
                    "id_majelis": dataMajelis.data.tMajelis[index].idMajelis,
                  },
                  onComplete: (data, statusCode) {
                    print(data);
                    Navigator.of(context).pop<bool>(true);
                    showSuccessFlushbar(
                        context: context,
                        title: "Sukses",
                        message: "Data Majelis Berhasil Di Hapus.");
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

  void _showDialogTambah() async {
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    Alert(
        context: context,
        title: "Tambah Data Majelis",
        buttons: [],
        style: AlertStyle(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            titleStyle: TextStyle(color: Colors.white),
            alertPadding: EdgeInsets.all(0),
            isCloseButton: false,
            isOverlayTapDismiss: false,
            isButtonVisible: false,
            buttonAreaPadding: EdgeInsets.all(0),
            constraints: BoxConstraints.expand(
              width: 300,
            ),
            overlayColor: Color(0x55000000),
            alertElevation: 0,
            alertAlignment: Alignment.center),
        content: StatefulBuilder(builder: (context, setState) {
          return FormBuilder(
            key: _fbKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  readOnly: isSaving,
                  attribute: "nama_majelis",
                  textInputAction: TextInputAction.next,
                  focusNode: _majelisFocusNode,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_alamatFocusNode);
                  },
                  decoration: _decorTextfield(
                      context, "Nama Majelis", Icons.supervised_user_circle),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  readOnly: isSaving,
                  attribute: "alamat_majelis",
                  textInputAction: TextInputAction.next,
                  focusNode: _alamatFocusNode,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  decoration:
                      _decorTextfield(context, "Alamat", FontAwesomeIcons.map),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ArgonButton(
                        borderRadius: 5,
                        color: Colors.red,
                        height: 40,
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Batal",
                                style:
                                    TextStyle().copyWith(color: Colors.white))
                          ],
                        ),
                        onTap: (startLoading, stopLoading, btnState) {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ArgonButton(
                        borderRadius: 5,
                        color: Colors.green,
                        height: 40,
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text("OK",
                                style:
                                    TextStyle().copyWith(color: Colors.white))
                          ],
                        ),
                        loader: SpinKitRipple(
                          color: Colors.white,
                        ),
                        onTap: (startLoading, stopLoading, btnState) async {
                          print(_fbKey.currentState.value['nama_majelis']);
                          if (_fbKey.currentState.saveAndValidate()) {
                            setState(() {
                              isSaving = true;
                            });
                            startLoading();
                            await postData(
                              url: urlApi.addDataMajelis,
                              data: {
                                "nama_majelis":
                                    _fbKey.currentState.value['nama_majelis'],
                                "alamat_majelis":
                                    _fbKey.currentState.value['alamat_majelis'],
                                "created": DateTime.now(),
                                "created_by": dataLogin.data.id,
                                "id_masjid": dataLogin.data.idMasjid
                              },
                              onComplete: (data, statusCode) {
                                print(data);
                                Navigator.of(context).pop<bool>(true);
                                showSuccessFlushbar(
                                    context: context,
                                    title: "Sukses",
                                    message: "Data Majelis Berhasil Disimpan.");
                                refreshData();
                              },
                              onError: (error) {
                                setState(() {
                                  isSaving = false;
                                });
                                print(error);

                                stopLoading();
                                showErrorFlushbar(
                                    context: context,
                                    title: "Error",
                                    message:
                                        "Data Tidak Dapat Disimpan!\nHarap Periksa Koneksi Internet Anda,Dan Coba Lagi.");
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        })).show();
  }

  InputDecoration _decorTextfield(
      BuildContext context, String labelName, IconData icon,
      {Widget iconSuffix}) {
    return InputDecoration(
        labelText: labelName,
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.red),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        suffixIcon: iconSuffix,
        enabledBorder: mainTextfielBorder(
          context,
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: mainTextfielBorder(context),
        errorBorder: mainTextfielBorder(context,
            borderSide: BorderSide(
              color: Colors.red,
            )),
        border: mainTextfielBorder(context, borderSide: null),
        isDense: true);
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    refreshData();
  }
}
