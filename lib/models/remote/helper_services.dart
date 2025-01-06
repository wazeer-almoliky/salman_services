import 'package:sqflite/sqflite.dart';

class ServicesHelper {
    static final ServicesHelper instance = ServicesHelper._internal();

  static Database? _database;

  ServicesHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/service.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onConfigure: _onConfigure
    );
  }


  Future<void> _createDatabase(Database db, int version) async {
    final sql = db.batch();
      sql.execute('''
        CREATE TABLE foundation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
        )
      ''');
      sql.execute('''
        CREATE TABLE visa (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          created_at TEXT NOT NULL,
          foundation_id INTEGER NOT NULL,
          price INTEGER NOT NULL,
          FOREIGN KEY (foundation_id) REFERENCES foundation (id) 
        )
      ''');
      sql.execute('''
        CREATE TABLE customer (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          mobile TEXT NOT NULL
         
        )
      ''');
      sql.execute('''
        CREATE TABLE customer_visa (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_id INTEGER NOT NULL,
          visa_id INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          FOREIGN KEY (customer_id) REFERENCES customer (id),
          FOREIGN KEY (visa_id) REFERENCES visa (id)
         
        )
      ''');
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
}
}