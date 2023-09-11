import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String password;

  Item({required this.name, required this.userName, required this.password});
}
