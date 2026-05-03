import 'package:hive/hive.dart';
import 'dart:io';
import 'lib/models/goal.dart';

Future<void> main() async {
  Directory dir = Directory.current;
  Hive.init(dir.path);
  Hive.registerAdapter(GoalAdapter());
  var box = await Hive.openBox<Goal>('goals');
  await box.clear();
}
