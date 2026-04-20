import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/goal.dart';
import '../models/check_in.dart';
import '../models/bug_stage.dart';
import '../models/forest_progress.dart';

class DatabaseHelper {
  static const String _dbName = 'forest_bug.db';
  static const int _version = 1;

  static const String goalsTable = 'goals';
  static const String checkInsTable = 'checkIns';
  static const String bugStageTable = 'bugStage';
  static const String forestProgressTable = 'forestProgress';

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _version,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $goalsTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $checkInsTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        notes TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $bugStageTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stage TEXT NOT NULL,
        progressPoints INTEGER NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $forestProgressTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        totalTrees INTEGER NOT NULL,
        treesCultivated INTEGER NOT NULL,
        lastUpdated TEXT NOT NULL
      )
    ''');
  }

  // Goals
  Future<int> insertGoal(Goal goal) async {
    final db = await database;
    return db.insert(goalsTable, goal.toMap());
  }

  Future<List<Goal>> getGoals() async {
    final db = await database;
    final result = await db.query(goalsTable);
    return result.map((map) => Goal.fromMap(map)).toList();
  }

  Future<int> updateGoal(Goal goal) async {
    final db = await database;
    return db.update(
      goalsTable,
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<int> deleteGoal(int id) async {
    final db = await database;
    return db.delete(goalsTable, where: 'id = ?', whereArgs: [id]);
  }

  // Check-ins
  Future<int> insertCheckIn(CheckIn checkIn) async {
    final db = await database;
    return db.insert(checkInsTable, checkIn.toMap());
  }

  Future<List<CheckIn>> getCheckIns() async {
    final db = await database;
    final result = await db.query(checkInsTable, orderBy: 'timestamp DESC');
    return result.map((map) => CheckIn.fromMap(map)).toList();
  }

  Future<int> deleteCheckIn(int id) async {
    final db = await database;
    return db.delete(checkInsTable, where: 'id = ?', whereArgs: [id]);
  }

  // Bug Stage
  Future<int> insertBugStage(BugStage bugStage) async {
    final db = await database;
    return db.insert(bugStageTable, bugStage.toMap());
  }

  Future<BugStage?> getLatestBugStage() async {
    final db = await database;
    final result = await db.query(
      bugStageTable,
      orderBy: 'updatedAt DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return BugStage.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateBugStage(BugStage bugStage) async {
    final db = await database;
    return db.update(
      bugStageTable,
      bugStage.toMap(),
      where: 'id = ?',
      whereArgs: [bugStage.id],
    );
  }

  // Forest Progress
  Future<int> insertForestProgress(ForestProgress progress) async {
    final db = await database;
    return db.insert(forestProgressTable, progress.toMap());
  }

  Future<ForestProgress?> getForestProgress() async {
    final db = await database;
    final result = await db.query(forestProgressTable, limit: 1);
    if (result.isNotEmpty) {
      return ForestProgress.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateForestProgress(ForestProgress progress) async {
    final db = await database;
    return db.update(
      forestProgressTable,
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
