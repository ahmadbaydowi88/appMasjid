import 'package:apppengelolaan/agenda/api/api_dataAgenda.dart';
import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/view/appbar.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditAgenda extends StatefulWidget {
  final DataAgenda dataAgenda;
  final int index;

  const EditAgenda({Key key, this.dataAgenda, this.index}) : super(key: key);
  @override
  _EditAgendaState createState() => _EditAgendaState();
}

class _EditAgendaState extends State<EditAgenda> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();
  bool isSaving = false;
  FocusNode _namaKegiatan = FocusNode();
  FocusNode _keterangan = FocusNode();
  var tglAwal, tglAkhir;
  @override
  void initState() {
    super.initState();
    tglAwal =
        DateTime.parse(widget.dataAgenda.data.tKegiatan[widget.index].tglAwal);
    tglAkhir =
        DateTime.parse(widget.dataAgenda.data.tKegiatan[widget.index].tglAkhir);
  }

  void tanyakeluar() {
    if (isSaving) {
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
          title: "Edit Agenda",
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormBuilder(
            key: _key,
            initialValue: {
              "nama_kegiatan":
                  widget.dataAgenda.data.tKegiatan[widget.index].namaKegiatan,
              "keterangan":
                  widget.dataAgenda.data.tKegiatan[widget.index].keterangan,
              "tgl_awal": tglAwal,
              "tgl_akhir": tglAkhir,
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                FormBuilderTextField(
                    attribute: "nama_kegiatan",
                    textInputAction: TextInputAction.next,
                    focusNode: _namaKegiatan,
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Kolom Ini Dibutuhkan!"),
                    ],
                    onFieldSubmitted: (value) {
                      _namaKegiatan.unfocus();
                      FocusScope.of(context).requestFocus(_keterangan);
                    },
                    decoration: decorTextfield(context, "Nama Kegiatan",
                        Icon(MdiIcons.fileDocumentEdit))),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                    attribute: "keterangan",
                    textInputAction: TextInputAction.newline,
                    focusNode: _keterangan,
                    maxLines: 3,
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Kolom Ini Dibutuhkan!"),
                    ],
                    onFieldSubmitted: (value) {
                      _keterangan.unfocus();
                      FocusScope.of(context).requestFocus();
                    },
                    decoration: decorTextfield(context, "Keterangan",
                        Icon(MdiIcons.fileDocumentEdit))),
                SizedBox(
                  height: 10,
                ),
                FormBuilderDateTimePicker(
                  attribute: "tgl_awal",
                  locale: Locale("id"),
                  readOnly: isSaving,
                  // inputType: InputType.date,
                  onChanged: (value) => tglAwal = value,
                  format: DateFormat("yyyy-MM-dd HH:mm"),
                  decoration: decorTextfield(
                      context, "Dari Tanggal", Icon(MdiIcons.calendar)),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderDateTimePicker(
                  attribute: "tgl_akhir",
                  locale: Locale("id"),
                  readOnly: isSaving,
                  // inputType: InputType.date,
                  format: DateFormat("yyyy-MM-dd HH:mm"),
                  decoration: decorTextfield(
                      context, "Sampai Tanggal", Icon(MdiIcons.calendar)),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ArgonButton(
              height: 50,
              width: 100,
              borderRadius: 10,
              elevation: 0,
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Batal",
                    style: TextStyle().copyWith(color: Colors.white),
                  )
                ],
              ),
              onTap: (startLoading, stopLoading, btnState) {
                if (!isSaving) tanyakeluar();
              },
            ),
            SizedBox(
              width: 10,
            ),
            ArgonButton(
              height: 50,
              width: 100,
              borderRadius: 10,
              elevation: 0,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.contentSave,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Simpan",
                    style: TextStyle().copyWith(color: Colors.white),
                  )
                ],
              ),
              roundLoadingShape: false,
              minWidth: 100,
              loader: SpinKitThreeBounce(
                color: Colors.white,
                size: 30,
              ),
              onTap: (startLoading, stopLoading, btnState) async {
                if (btnState == ButtonState.Idle) {
                  if (btnState == ButtonState.Idle) {
                    print(_key.currentState.value['nama_kegiatan']);
                    if (_key.currentState.saveAndValidate()) {
                      setState(() {
                        isSaving = true;
                      });
                      startLoading();
                      await postData(
                        url: urlApi.aditAgenda,
                        data: {
                          "id_kegiatan": widget.dataAgenda.data
                              .tKegiatan[widget.index].idKegiatan,
                          "nama_kegiatan":
                              _key.currentState.value['nama_kegiatan'],
                          "keterangan": _key.currentState.value['keterangan'],
                          "tgl_awal": _key.currentState.value['tgl_awal'],
                          "tgl_akhir": _key.currentState.value['tgl_akhir'],
                          // "updated": DateTime.now(),
                          // "updated_by": dataLogin.data.id,
                          "id": dataLogin.data.idMasjid
                        },
                        onComplete: (data, statusCode) {
                          print(data);
                          Navigator.of(context).pop<bool>(true);
                          showSuccessFlushbar(
                              context: context,
                              title: "Sukses",
                              message: "Data Berhasil Disimpan.");
                          // refreshData();
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
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
