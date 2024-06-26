import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cache.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE Cache (
  id $idType,
  url $textType,
  data $textType,
  method $textType
)
''');
  }

  Future<List<Map<String, dynamic>>> getAllCachedData() async {
    final db = await instance.database;
    return await db.query('Cache');
  }

  Future<int> insert(Map<String, dynamic> entity) async {
    final db = await instance.database;
    return await db.insert('Cache', entity);
  }

  Future<void> deleteCachedData(int id) async {
    final db = await instance.database;
    await db.delete(
      'Cache',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
