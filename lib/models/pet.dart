import 'package:hive/hive.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type;

  @HiveField(3)
  int level;

  @HiveField(4)
  String imagePath;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.level,
    required this.imagePath,
  });
}
