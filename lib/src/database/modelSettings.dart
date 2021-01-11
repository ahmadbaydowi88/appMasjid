import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Settings extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;
}
