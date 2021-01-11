import 'package:apppengelolaan/animations/FadeAnimation.dart';
import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/src/public.dart';
import 'package:apppengelolaan/src/routes.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool initComplete = false;
  bool sedangMasuk = false;
  bool showpassword = false;
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
            Navigator.of(context)
                .pushReplacementNamed(getRoutesName(RoutesName.mainPage));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Container(
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
                        "Login",
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
                height: 50,
              ),
              Expanded(
                child: AbsorbPointer(
                  absorbing: sedangMasuk,
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
                              color: Theme.of(context).primaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(MdiIcons.login, color: Colors.white),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Masuk",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                              roundLoadingShape: false,
                              minWidth: MediaQuery.of(context).size.width,
                              loader: SpinKitThreeBounce(
                                  color: Colors.white, size: 30),
                              onTap:
                                  (startLoading, stopLoading, btnState) async {
                                if (btnState == ButtonState.Idle) {
                                  _emailFocusNode.unfocus();
                                  _passwordFocusNode.unfocus();
                                  if (_fbKey.currentState.saveAndValidate()) {
                                    _passwordFocusNode.unfocus();
                                    setState(() {
                                      sedangMasuk = true;
                                    });
                                    startLoading();
                                    doLogin(
                                      _fbKey.currentState.value['email'],
                                      _fbKey.currentState.value['password'],
                                      onError: (e) {
                                        stopLoading();
                                        setState(() {
                                          sedangMasuk = false;
                                        });
                                        showErrorFlushbar(
                                            context: context,
                                            title: "Error!",
                                            message:
                                                "Tidak Dapat Terhubung Ke Server,\nMohon Untuk Periksa Koneksi Internet Anda!");
                                      },
                                      onSuccess: () {
                                        stopLoading();

                                        //sukses masuk
                                        setState(() {
                                          sedangMasuk = false;
                                        });

                                        Navigator.of(context)
                                            .pushReplacementNamed(getRoutesName(
                                                RoutesName.homePage));
                                      },
                                      onFail: () {
                                        stopLoading();
                                        setState(() {
                                          sedangMasuk = false;
                                        });
                                        showErrorFlushbar(
                                            context: context,
                                            title: "Gagal!",
                                            message:
                                                "Nama Pengguna Atau Kata Sandi Anda Salah!");
                                      },
                                    );
                                  }
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
                                "Daftar",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.teal),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    getRoutesName(RoutesName.signupPage));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  readOnly: sedangMasuk,
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
                  readOnly: sedangMasuk,
                  textInputAction: TextInputAction.done,
                  focusNode: _passwordFocusNode,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Kolom Ini Dibutuhkan!")
                  ],
                  onFieldSubmitted: (value) {
                    _passwordFocusNode.unfocus();
                    FocusScope.of(context).requestFocus();
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
          ],
        ),
      ),
    );
  }
}
