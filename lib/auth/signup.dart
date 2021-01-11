import 'dart:convert';

import 'package:apppengelolaan/animations/FadeAnimation.dart';
import 'package:apppengelolaan/auth/api/dataMasjid.dart';
import 'package:apppengelolaan/auth/api/groupData.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DropdownUnitProperties {
  final String id;
  final String name;

  DropdownUnitProperties({
    this.id,
    this.name,
  });
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _fullnameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _alamatFocusNode = FocusNode();
  final FocusNode _levelFocusNode = FocusNode();
  final FocusNode _masjidFocusNode = FocusNode();
  List<DropdownUnitProperties> _masjid = [];
  List<DropdownUnitProperties> _group = [];
  DataMasjid _dataMasjid;
  DataGroup _dataGroup;
  bool isError = false;
  bool showpassword = false;
  bool isSaving = false;

  Future<void> getThisDataMasjid() async {
    await getData(
      url: urlApi.masjidAll,
      onComplete: (data, statusCode) {
        print("data load : $data");
        setState(() {
          if (statusCode == 200) {
            _dataMasjid = DataMasjid.fromJson(jsonDecode(data));
            if (_dataMasjid.data.tMasjid != null) {
              _dataMasjid.data.tMasjid.forEach((element) {
                _masjid.add(DropdownUnitProperties(
                    id: element.idMasjid, name: element.namaMasjid));
              });
            }
          }
        });
      },
      onError: (error) {
        print(error);
        setState(() {
          isError = true;
        });
      },
    );
  }

  Future<void> getThisDataGroup() async {
    await getData(
      url: urlApi.groupAll,
      onComplete: (data, statusCode) {
        print("data load : $data");
        setState(() {
          if (statusCode == 200) {
            _dataGroup = DataGroup.fromJson(jsonDecode(data));
            if (_dataGroup.data.group != null) {
              _dataGroup.data.group.forEach((element) {
                _group.add(
                    DropdownUnitProperties(id: element.id, name: element.name));
              });
            }
          }
        });
      },
      onError: (error) {
        print(error);
        setState(() {
          isError = true;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getThisDataMasjid();
    getThisDataGroup();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Color(0xff05303D),
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: targetWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                FadeAnimation(
                    1,
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                SizedBox(
                  height: 10,
                ),
                FadeAnimation(
                    1.2,
                    Text(
                      "Login to your account",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  bulitextField(),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                    1.4,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: ArgonButton(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          borderRadius: 50,
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          color: Color(0xffff5a00),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MdiIcons.login, color: Colors.white),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "Daftar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          roundLoadingShape: false,
                          minWidth: MediaQuery.of(context).size.width,
                          loader:
                              SpinKitThreeBounce(color: Colors.white, size: 30),
                          onTap: (startLoading, stopLoading, btnState) async {
                            if (_fbKey.currentState.saveAndValidate()) {
                              setState(() {
                                isSaving = true;
                              });
                              startLoading();
                              await postData(
                                url: urlApi.register,
                                data: {
                                  "username":
                                      _fbKey.currentState.value['username'],
                                  "email": _fbKey.currentState.value['email'],
                                  "full_name":
                                      _fbKey.currentState.value['full_name'],
                                  "password":
                                      _fbKey.currentState.value['password'],
                                  "id_masjid":
                                      _fbKey.currentState.value['id_masjid'],
                                  "group": _fbKey.currentState.value['group'],
                                },
                                onComplete: (data, statusCode) {
                                  stopLoading();
                                  print(data);
                                  Navigator.of(context).pushReplacementNamed(
                                      getRoutesName(RoutesName.loginPage));
                                  showSuccessFlushbar(
                                      context: context,
                                      title: "Sukses",
                                      message: "Data Berhasil Disimpan.");
                                },
                                onError: (error) {
                                  stopLoading();
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
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  FadeAnimation(
                    1.5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Sudah Punya Akun?",
                          style: TextStyle(color: Colors.white24),
                        ),
                        FlatButton(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.teal),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/login");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bulitextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: FormBuilder(
        key: _fbKey,
        child: Column(
          children: <Widget>[
            FadeAnimation(
              1.2,
              FadeAnimation(
                1.2,
                FormBuilderTextField(
                  attribute: "email",
                  readOnly: isSaving,
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocusNode,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!"),
                  ],
                  onFieldSubmitted: (value) {
                    _emailFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  decoration: decorTextfield(
                    context,
                    "Alamat Email",
                    Icon(MdiIcons.email),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FadeAnimation(
              1.3,
              FormBuilderTextField(
                  obscureText: !showpassword,
                  attribute: "password",
                  readOnly: isSaving,
                  textInputAction: TextInputAction.done,
                  focusNode: _passwordFocusNode,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!")
                  ],
                  onFieldSubmitted: (value) {
                    _fullnameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_fullnameFocusNode);
                  },
                  decoration: decorTextfield(
                      context, "Kata Sandi", Icon(MdiIcons.formTextboxPassword),
                      iconSuffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            showpassword = !showpassword;
                          });
                        },
                        child:
                            Icon(showpassword ? MdiIcons.eyeOff : MdiIcons.eye),
                      ))),
            ),
            SizedBox(
              height: 10,
            ),
            FadeAnimation(
              1.2,
              FormBuilderTextField(
                attribute: "full_name",
                readOnly: isSaving,
                textInputAction: TextInputAction.next,
                focusNode: _fullnameFocusNode,
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Kolom Ini Dibutuhkan!"),
                ],
                onFieldSubmitted: (value) {
                  _fullnameFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_alamatFocusNode);
                },
                decoration: decorTextfield(
                  context,
                  "Nama Lengkap",
                  Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FadeAnimation(
              1.2,
              FormBuilderTextField(
                attribute: "username",
                readOnly: isSaving,
                textInputAction: TextInputAction.next,
                focusNode: _alamatFocusNode,
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Kolom Ini Dibutuhkan!"),
                ],
                onFieldSubmitted: (value) {
                  _alamatFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_masjidFocusNode);
                },
                decoration: decorTextfield(
                  context,
                  "Username",
                  Icon(MdiIcons.mapMarker),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FadeAnimation(
              1.2,
              FormBuilderDropdown(
                attribute: "id_masjid",
                dropdownColor: Colors.teal,
                readOnly: isSaving,
                decoration: decorTextfield(
                    context, "Masjid", Icon(LineAwesomeIcons.mosque)),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Kolom Ini Dibutuhkan!"),
                ],
                items: _masjid
                    .map((d) => DropdownMenuItem(
                        value: d.id,
                        child: Text(
                          "${d.name}",
                          style: TextStyle(color: Colors.white),
                        )))
                    .toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FadeAnimation(
              1.2,
              FormBuilderDropdown(
                focusNode: _levelFocusNode,
                dropdownColor: Colors.teal,
                readOnly: isSaving,
                attribute: "group",
                decoration: decorTextfield(
                    context, "keanggotaan", Icon(MdiIcons.accountBoxMultiple)),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Kolom Ini Dibutuhkan!"),
                ],
                items: _group
                    .map((d) => DropdownMenuItem(
                        value: d.id,
                        child: Text(
                          "${d.name}",
                          style: TextStyle(color: Colors.white),
                        )))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
