import 'dart:io';

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
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddArtikel extends StatefulWidget {
  @override
  _AddArtikelState createState() => _AddArtikelState();
}

class _AddArtikelState extends State<AddArtikel> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FocusNode _judulFocusNode = FocusNode();
  final FocusNode _isiFocusNode = FocusNode();
  // final FocusNode _avatarFocusNode = FocusNode();
  final FocusNode _penulisFocusNode = FocusNode();
  final double _imageHeight = 200;
  File fileSelectedImage;
  bool isSelectedImage = false;
  bool isError = false;
  bool isLoaded = false;
  bool isSaving = false;
  String judul, isi, penulis;
  final _picker = ImagePicker();

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
    return Scaffold(
      appBar: AppbarMain(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "Tambah Artikel",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _fbKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              FormBuilderTextField(
                  attribute: "judul",
                  readOnly: isSaving,
                  textInputAction: TextInputAction.next,
                  focusNode: _judulFocusNode,
                  onChanged: (value) {
                    judul = value;
                  },
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  onFieldSubmitted: (value) {
                    _judulFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_isiFocusNode);
                  },
                  decoration: _decorTextfield(
                    context,
                    "Judul",
                  )),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                  attribute: "isi",
                  readOnly: isSaving,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  focusNode: _isiFocusNode,
                  onChanged: (value) {
                    isi = value;
                  },
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  onFieldSubmitted: (value) {
                    _isiFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_penulisFocusNode);
                  },
                  decoration: _decorTextfield(
                    context,
                    "Isi Artikel",
                  )),
              SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                  attribute: "penulis",
                  readOnly: isSaving,
                  textInputAction: TextInputAction.next,
                  focusNode: _penulisFocusNode,
                  onChanged: (value) {
                    penulis = value;
                  },
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  onFieldSubmitted: (value) {
                    _penulisFocusNode.unfocus();
                  },
                  decoration: _decorTextfield(
                    context,
                    "Sumber Atikel",
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                "Gambar Artikel",
                style: TextStyle(fontSize: 16),
              ),
              Divider(
                color: Colors.white,
              ),
              Stack(
                children: [
                  Container(
                      color: Theme.of(context).primaryColor,
                      // margin: EdgeInsets.only(bottom: _imageBottomMargin),
                      height: _imageHeight, //+ _imageBottomMargin,
                      width: MediaQuery.of(context).size.width,
                      child: isSelectedImage
                          ? Image.file(fileSelectedImage)
                          : Image.asset("assets/images/default_image.png")
                      // Image.network(
                      //     Url_Img + dataLogin.data.avatar,
                      //     fit: BoxFit.cover,
                      //     loadingBuilder: (context, child, loadingProgress) {
                      //       if (loadingProgress != null)
                      //         return Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: viewLoaderData(context),
                      //         );
                      //       else
                      //         return child;
                      //     },
                      //   ),
                      ),
                  Positioned(
                    right: -15,
                    top: _imageHeight - 50,
                    child: RawMaterialButton(
                      onPressed: () async {
                        if (isSaving) return;
                        PickedFile image =
                            await _picker.getImage(source: ImageSource.gallery);
                        fileSelectedImage = File(image.path);
                        setState(() {
                          isSelectedImage = true;
                        });
                      },
                      elevation: 2.0,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        // size: 35.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _buildButton(context)
            ],
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
                  if (_fbKey.currentState.saveAndValidate()) {
                    setState(() {
                      isSaving = true;
                    });
                    startLoading();
                    _prosessTambahArtikel(
                        isi: isi,
                        judul: judul,
                        penulis: penulis,
                        pathAvatar: fileSelectedImage == null
                            ? null
                            : fileSelectedImage.path,
                        onSuccess: () {
                          Navigator.of(context).pop<bool>(true);
                          showSuccessFlushbar(
                            context: context,
                            title: "Berhasil",
                            message: "Data Artikel Berhasil Diubah!",
                          );
                        },
                        onFail: () {
                          showErrorFlushbar(
                              context: context,
                              title: "Kesalahan!",
                              message: "Data Artikel Gagal Diubah!");
                          stopLoading();
                        });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _prosessTambahArtikel(
      {String pathAvatar,
      String judul = "",
      String isi = "",
      String penulis = "",
      onSuccess(),
      onFail(),
      onProgress(int val)}) async {
    await uploadFile(
      file: pathAvatar == null ? null : {"avatar": pathAvatar},
      url: urlApi.addArtikel,
      data: {
        "judul": judul,
        "isi": isi,
        "created_by": dataLogin.data.id,
        "penulis": penulis,
      },
      onComplete: (data, statusCode) {
        print(data);
        if (statusCode == 200) {
          if (onSuccess != null) onSuccess();
        }
      },
      onError: (error) {
        print(error.response.data);
        if (onFail != null) onFail();
      },
      onSendProgress: (send, total) {
        if (onProgress != null) onProgress((send / total * 100).toInt());
      },
    );
  }

  InputDecoration _decorTextfield(
    BuildContext context,
    String labelName,
  ) {
    return InputDecoration(
        labelText: labelName,
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.red),
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
}
