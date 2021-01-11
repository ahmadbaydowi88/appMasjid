import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

var hiveDB;
Future<void> initHiveDB() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  hiveDB = await Hive.openBox('db');
}

Future<void> hiveSetMasjid(int val) async {
  if (hiveDB == null) await initHiveDB();
  hiveDB.put("user", val);
}
