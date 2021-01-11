import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

// const String API_HOST = "http://10.236.232.132/AppMasjid/api/";
// const String Url_Img = "http://10.236.232.132/AppMasjid/uploads/user/";
// const String API_HOST = "http://coba.check-solution.com/api/";
// const String Url_Img = "http://coba.check-solution.com/uploads/user/";
const String API_HOST = "https://masjid.kecalapatriot.com/api/";
const String Url_Img = "https://masjid.kecalapatriot.com/uploads/user/";
const String _APIKEY = "226A33D777C277BF91BD149597126643";
String _tokenAuth = "";

void setTokenAuth(String token) {
  _tokenAuth = token;
}

void clearTokenAuth() {
  _tokenAuth = "";
}

BaseOptions options = new BaseOptions(
  connectTimeout: 30000,
  receiveTimeout: 30000,
);
Dio dio = new Dio(options);

Future<void> postData(
    {@required String url,
    Map<String, String> header,
    @required Map<String, dynamic> data,
    onComplete(String data, int statusCode),
    onError(DioError error),
    onSendProgress(int sent, int total),
    onReceiveProgress(int receive, int total)}) async {
  if (header == null) header = {};
  if (data == null) data = {};
  header.addAll({"X-Api-Key": _APIKEY, "X-Token": _tokenAuth});
  print("POST\nURL : $url \nBODY : $data");
  try {
    FormData formData = new FormData.fromMap(data);
    Response response = await dio.post(url,
        data: formData,
        options: Options(headers: header, responseType: ResponseType.plain),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    onComplete(response.data, response.statusCode);
  } on DioError catch (e) {
    if (e.type == DioErrorType.RESPONSE) {
      print(e.response.data);
    }
    if (onError != null) onError(e);
    print(e);
  }
}

Future<void> getData({
  @required String url,
  Map<String, String> header,
  Map<String, String> params,
  onComplete(String data, int statusCode),
  onError(DioError error),
}) async {
  if (header == null) header = {};
  header.addAll({"X-Api-Key": _APIKEY, "X-Token": _tokenAuth});
  print("GET\nURL : $url \nPARAMS : $params");
  try {
    Response response = await dio.get(url,
        queryParameters: params,
        options: Options(headers: header, responseType: ResponseType.plain));
    onComplete(
      response.data,
      response.statusCode,
    );
  } on DioError catch (e) {
    if (e.type == DioErrorType.RESPONSE) {
      print(e.response.data);
    }
    if (onError != null) onError(e);
  }
}

Future<void> uploadFile(
    {@required String url,
    @required Map<String, String> file, //fieldbody : pathfile
    Map<String, String> header,
    @required Map<String, dynamic> data,
    onComplete(String data, int statusCode),
    onError(DioError error),
    onSendProgress(int sent, int total),
    onReceiveProgress(int receive, int total)}) async {
  if (header == null) header = {};
  header.addAll({"X-Api-Key": _APIKEY, "X-Token": _tokenAuth});
  print("UPLOAD POST");
  print("Data : $data");
  print("File : $file");
  FormData formData = FormData.fromMap(data);
  if (file == null) file = {};
  file.forEach((key, value) async {
    formData.files.add(MapEntry(
        key, await MultipartFile.fromFile(value, filename: basename(value))));
  });
  try {
    Response response = await dio.post(url,
        data: formData,
        options: Options(headers: header, responseType: ResponseType.plain),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    onComplete(response.data, response.statusCode);
  } on DioError catch (e) {
    if (onError != null) onError(e);
  }
}
