import 'dart:io';

import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const String defaultEmailUser = "default@email.mail";

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormBuilderState> _k = GlobalKey<FormBuilderState>();
  final double _imageHeight = 300;
  final _picker = ImagePicker();
  bool showpassword = false;
  bool isSelectedImage = false;
  File fileSelectedImage;
  String _fullname, _email;
  int _valProgress = 0;
  bool isSaving = false;
  @override
  void initState() {
    super.initState();
    _fullname = dataLogin.data.fullName;
    _email = dataLogin.data.email;
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
    return FormBuilder(
      onWillPop: () {
        tanyakeluar();
        return Future<bool>.value(false);
      },
      key: _k,
      initialValue: {
        "nama_masjid": dataLogin.data.namaMasjid,
        "jabatan": dataLogin.data.jabatan,
        "fullname": dataProfile.data.fullName,
        "email": dataLogin.data.email == "0" || dataLogin.data.email == ""
            ? defaultEmailUser
            : dataLogin.data.email,
      },
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Stack(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  // margin: EdgeInsets.only(bottom: _imageBottomMargin),
                  height: _imageHeight, //+ _imageBottomMargin,
                  width: MediaQuery.of(context).size.width,
                  child: isSelectedImage
                      ? Image.file(
                          fileSelectedImage,
                          // fit: BoxFit.cover,
                        )
                      : Image.network(
                          Url_Img + dataProfile.data.avatar,
                          // fit: BoxFit.fitWidth,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null)
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: viewLoaderData(context),
                              );
                            else
                              return child;
                          },
                        ),
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
                    fillColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.edit,
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
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormBuilderTextField(
                  attribute: "nama_masjid",
                  readOnly: true,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  decoration: decorTextfield(
                      context,
                      "Nama Masjid",
                      Icon(
                        LineAwesomeIcons.mosque,
                        color: Colors.white,
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormBuilderTextField(
                  attribute: "jabatan",
                  readOnly: true,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  decoration: decorTextfield(
                      context,
                      "Jabatan",
                      Icon(
                        MdiIcons.clipboardAccount,
                        color: Colors.white,
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormBuilderTextField(
                  attribute: "fullname",
                  onChanged: (value) => _fullname = value,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  decoration: decorTextfield(
                      context, "Nama Lengkap", Icon(MdiIcons.cardText))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormBuilderTextField(
                  attribute: "email",
                  onChanged: (value) => _email = value,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                    FormBuilderValidators.email(
                        errorText: "Alamat Email Tidak Valid!")
                  ],
                  decoration:
                      decorTextfield(context, "Email", Icon(MdiIcons.email))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ArgonButton(
                    borderRadius: 8,
                    color: Colors.pink,
                    height: 50,
                    width: 150,
                    loader: SpinKitRipple(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(MdiIcons.formTextboxPassword, color: Colors.white),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Ubah Kata Sandi",
                          style: TextStyle().copyWith(color: Colors.white),
                        )
                      ],
                    ),
                    onTap: (startLoading, stopLoading, btnState) {
                      if (!isSaving) _showDialogPassword();
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ArgonButton(
                    borderRadius: 8,
                    color: Colors.green,
                    height: 50,
                    width: 150,
                    loader: SpinKitRipple(
                      color: Colors.white,
                    ),
                    child: isSaving
                        ? LiquidLinearProgressIndicator(
                            value: _valProgress / 100,
                            backgroundColor: Colors.green,
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                            borderRadius: 5,
                            center: Text(
                              "Menyimpan $_valProgress%",
                              style: TextStyle().copyWith(color: Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MdiIcons.contentSave, color: Colors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Simpan",
                                style:
                                    TextStyle().copyWith(color: Colors.white),
                              )
                            ],
                          ),
                    onTap: (startLoading, stopLoading, btnState) async {
                      print("$_fullname | $_email");
                      if (btnState == ButtonState.Idle) {
                        if (_k.currentState.validate()) {
                          setState(() {
                            isSaving = true;
                          });
                          await _prosessUbahProfile(
                            namaLengkap: _fullname,
                            email: _email,
                            pathAvatar: fileSelectedImage == null
                                ? null
                                : fileSelectedImage.path,
                            onSuccess: () {
                              showSuccessFlushbar(
                                context: context,
                                title: "Berhasil",
                                message: "Data Profile Berhasil Diubah!",
                                onStatusChanged: (status) {
                                  if (status == FlushbarStatus.DISMISSED) {
                                    Navigator.of(context).pushReplacementNamed(
                                        getRoutesName(RoutesName.homePage));
                                  }
                                },
                              );
                            },
                            onFail: () {
                              showErrorFlushbar(
                                  context: context,
                                  title: "Kesalahan!",
                                  message: "Profile Gagal Disimpan!");
                              setState(() {
                                isSaving = false;
                                _valProgress = 0;
                              });
                            },
                            onProgress: (val) {
                              setState(() {
                                _valProgress = val;
                              });
                            },
                          );
                        }
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDialogPassword() async {
    String pwdLama, pwdBaru, pwdVerifykasi;
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    Alert(
        context: context,
        title: "Ubah Kata Sandi",
        buttons: [],
        style: AlertStyle(
            backgroundColor: Theme.of(context).primaryColor,
            alertPadding: EdgeInsets.all(0),
            isCloseButton: false,
            isOverlayTapDismiss: false,
            isButtonVisible: false,
            buttonAreaPadding: EdgeInsets.all(0),
            constraints: BoxConstraints.expand(width: 300),
            //First to chars "55" represents transparency of color
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
                    obscureText: !showpassword,
                    attribute: "pwd_lama",
                    onChanged: (value) {
                      pwdLama = value;
                    },
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Kolom Ini Dibutuhkan!")
                    ],
                    decoration: _decorTextfield(context, "Kata Sandi Lama",
                        Icon(MdiIcons.formTextboxPassword),
                        iconSuffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              showpassword = !showpassword;
                            });
                          },
                          child: Icon(
                              showpassword ? MdiIcons.eyeOff : MdiIcons.eye),
                        ))),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                    obscureText: !showpassword,
                    attribute: "pwd_baru",
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Kolom Ini Dibutuhkan!"),
                      FormBuilderValidators.minLength(5,
                          errorText: "Kata Sandi Minimal 5 Karakter")
                    ],
                    onChanged: (value) {
                      pwdBaru = value;
                    },
                    decoration: _decorTextfield(context, "Kata Sandi Baru",
                        Icon(MdiIcons.formTextboxPassword),
                        iconSuffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              showpassword = !showpassword;
                            });
                          },
                          child: Icon(
                              showpassword ? MdiIcons.eyeOff : MdiIcons.eye),
                        ))),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  obscureText: !showpassword,
                  attribute: "pwd_baru_verifikasi",
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                    FormBuilderValidators.minLength(5,
                        errorText: "Kata Sandi Minimal 5 Karakter")
                  ],
                  onChanged: (value) {
                    pwdVerifykasi = value;
                  },
                  decoration: _decorTextfield(
                    context,
                    "Ulangi Kata Sandi Baru",
                    Icon(MdiIcons.formTextboxPassword),
                    iconSuffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          showpassword = !showpassword;
                        });
                      },
                      child:
                          Icon(showpassword ? MdiIcons.eyeOff : MdiIcons.eye),
                    ),
                  ),
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
                          if (_fbKey.currentState.validate()) {
                            print("$pwdLama | $pwdBaru");
                            startLoading();
                            doLogin(
                              dataLogin.data.email,
                              pwdLama,
                              onFail: () {
                                showErrorFlushbar(
                                    context: context,
                                    title: "Kata Sandi Salah",
                                    message: "Kata Sandi Lama Anda Salah!");
                                stopLoading();
                              },
                              onSuccess: () async {
                                if (pwdBaru == pwdVerifykasi) {
                                  await _prosessUbahProfile(
                                      password: pwdBaru,
                                      onSuccess: () {
                                        showSuccessFlushbar(
                                          context: context,
                                          title: "Berhasil",
                                          message:
                                              "Kata Sandi Berhasil Diubah!\nAnda Akan Dialihkan Ke Halaman Login!",
                                          onStatusChanged: (status) {
                                            if (status ==
                                                FlushbarStatus.DISMISSED) {
                                              doLogout(context);
                                            }
                                          },
                                        );
                                      },
                                      onFail: () {
                                        showErrorFlushbar(
                                            context: context,
                                            title: "Kesalahan!",
                                            message:
                                                "Kata Sandi Gagal Diubah!");
                                        stopLoading();
                                      });
                                } else {
                                  showErrorFlushbar(
                                      context: context,
                                      title: "Kesalahan!",
                                      message:
                                          "Kata Sandi Baru Yang Anda Masukan Tidak Sesuai Dengan Kata Sandi Verifikasi!");
                                  stopLoading();
                                }
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
      BuildContext context, String labelName, Icon icon,
      {Widget iconSuffix}) {
    return InputDecoration(
        fillColor: Colors.black,
        labelText: labelName,
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.red),
        prefixIcon: icon,
        suffixIcon: iconSuffix,
        enabledBorder: mainTextfielBorder(context,
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: mainTextfielBorder(context),
        errorBorder: mainTextfielBorder(context,
            borderSide: BorderSide(
              color: Colors.red,
            )),
        border: mainTextfielBorder(context, borderSide: null),
        isDense: true);
  }

  Future<void> _prosessUbahProfile(
      {String password = "",
      String pathAvatar,
      String namaLengkap,
      String email,
      onSuccess(),
      onFail(),
      onProgress(int val)}) async {
    if (namaLengkap == null) namaLengkap = dataLogin.data.fullName;
    if (email == null)
      email = dataLogin.data.email == "0" || dataLogin.data.email == ""
          ? defaultEmailUser
          : dataLogin.data.email;
    await uploadFile(
      file: pathAvatar == null ? null : {"avatar": pathAvatar},
      url: urlApi.updateProfile,
      data: {
        "email": email,
        "password": password,
        "full_name": namaLengkap,
        "id": dataLogin.data.id,
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
}
