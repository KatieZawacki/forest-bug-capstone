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

  /// New field for pet state (sit, lay, stand, etc)
  @HiveField(5)
  String state;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.level,
    required this.imagePath,
    this.state = 'sit',
  });
}
