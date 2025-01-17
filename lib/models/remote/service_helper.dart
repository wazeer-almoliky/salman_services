/*import 'dart:developer';
import 'package:pharmacy/core/services/app_config.dart';
import 'package:pharmacy/model/remote/parent_model.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_sqlcipher/sqflite.dart';
class PharmacyHelper {
  PharmacyHelper._constructor();
  static final PharmacyHelper instance = PharmacyHelper._constructor();
  factory PharmacyHelper() {
    return instance;
  }
  static const dbName = 'pharmacy.db';
  // static const _dbVersion =2;
  // static final _now = DateTime.now().toString().substring(0,10);
  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // String app = await AppConfigure.appName();
    String dir = await AppConfigure.databaseDirectory();
    final path = dir += '/$dbName';
    // final pw = DateTime.now().toString().substring(0,10);
    // int psw=0;
    //  pw.split('-').forEach((element) {psw += int.parse(element);});
    // final psw2 = psw/10;
    return openDatabase(
      path,
      version:2,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade
      // password: psw2.toString()
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    batch.execute("""
           CREATE TABLE unit(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0)
        """);
    batch.execute("""
           CREATE TABLE user(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          password TEXT NOT NULL,
          state TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0)
        """);
    batch.execute("""
           CREATE TABLE authorize(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          action TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0)
        """);
    batch.execute("""
           CREATE TABLE supplier(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          phone TEXT NOT NULL,
          type TEXT NOT NULL,
          state TEXT DEFAULT 0,
          date TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0)
        """);
    batch.execute('''
      CREATE TABLE customer(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      status TEXT DEFAULT 0,
      phone TEXT NOT NULL,
      max INTEGER NOT NULL,
      date TEXT NOT NULL,
      isAsync INTEGER DEFAULT 0)
      ''');
    batch.execute("""
           CREATE TABLE expense(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          state TEXT DEFAULT 0,
          isAsync INTEGER DEFAULT 0)
        """);
    batch.execute("""
          CREATE TABLE app_authorize(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          state TEXT DEFAULT 0,
          date TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0)
        """);
    batch.execute("""
          CREATE TABLE active(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL)
        """);
    batch.execute("""
          CREATE TABLE appSetting(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          address TEXT NOT NULL,
          phone TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0)
        """);
    batch.execute("""
           CREATE TABLE item(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          barcode TEXT DEFAULT 0,
          value INTEGER DEFAULT 1,
          unit TEXT DEFAULT 0,
          type TEXT DEFAULT 0,
          isAsync INTEGER DEFAULT 0)
        """);
    batch.execute('''
          CREATE TABLE bill(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customerID INTEGER,
          date TEXT NOT NULL,
          total INTEGER NOT NULL,
          type TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0)
      '''); //FOREIGN KEY (customerID) REFERENCES customer (id) ON UPDATE CASCADE ON DELETE CASCADE
    batch.execute('''
      CREATE TABLE customerBalance(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customerID INTEGER NOT NULL,
      debitor INTEGER NOT NULL,
      creditor INTEGER NOT NULL,
      date TEXT NOT NULL,
      note TEXT NOT NULL,
      isAsync INTEGER DEFAULT 0,
      FOREIGN KEY (customerID) REFERENCES customer (id) ON UPDATE CASCADE ON DELETE CASCADE)
      ''');
    batch.execute('''
      CREATE TABLE supplierBalance(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      supplierID INTEGER NOT NULL,
      debitor INTEGER NOT NULL,
      creditor INTEGER NOT NULL,
      date TEXT NOT NULL,
      note TEXT NOT NULL,
      image TEXT,
      isAsync INTEGER DEFAULT 0,
      FOREIGN KEY (supplierID) REFERENCES supplier (id) ON UPDATE CASCADE ON DELETE CASCADE)
      ''');
    batch.execute("""
          CREATE TABLE bill_item(
          billID INTEGER NOT NULL,
          itemID INTEGER NOT NULL,
          unitID INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          discount INTEGER DEFAULT 0,
          isAsync INTEGER DEFAULT 0)
        """);
    /*
         PRIMARY KEY(billID,itemID),
          FOREIGN KEY (billID) REFERENCES bill (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (itemID) REFERENCES selling_item (id) ON UPDATE CASCADE ON DELETE CASCADE 
         */
    batch.execute("""
           CREATE TABLE expense_details(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          expenseID INTEGER NOT NULL,
          value INTEGER NOT NULL,
          date TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0,
          FOREIGN KEY (expenseID) REFERENCES expense (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.execute("""
           CREATE TABLE store(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          supplierID INTEGER NOT NULL,
          itemID INTEGER NOT NULL,
          unitID INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          date INTEGER NOT NULL,
          isAsync INTEGER DEFAULT 0,
          FOREIGN KEY (unitID) REFERENCES unit (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (itemID) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (supplierID) REFERENCES supplier (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.execute("""
           CREATE TABLE item_unit(
          itemID INTEGER NOT NULL,
          unitID INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          isAsync INTEGER DEFAULT 0,
          PRIMARY KEY(unitID,itemID),
          FOREIGN KEY (unitID) REFERENCES unit (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (itemID) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.execute("""
           CREATE TABLE purchase(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itemID INTEGER NOT NULL,
          unitID INTEGER NOT NULL,
          supplierID INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          type TEXT NOT NULL,
          date TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0,
          FOREIGN KEY (itemID) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (unitID) REFERENCES unit (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (supplierID) REFERENCES supplier (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.execute("""
           CREATE TABLE returnItem(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itemID INTEGER NOT NULL,
          unitID INTEGER NOT NULL,
          supplierID INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          note TEXT NOT NULL,
          type TEXT NOT NULL,
          date TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0,
          FOREIGN KEY (itemID) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (unitID) REFERENCES unit (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (supplierID) REFERENCES supplier (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.execute("""
           CREATE TABLE authorize_user(
          userID INTEGER NOT NULL,
          authorizeID INTEGER NOT NULL,
          action TEXT NOT NULL,
          isAsync INTEGER DEFAULT 0,
          PRIMARY KEY(userID,authorizeID),
          FOREIGN KEY (authorizeID) REFERENCES authorize (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (userID) REFERENCES user (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.execute("""
          CREATE TABLE storeReturn(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itemID INTEGER NOT NULL,
          unitID INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          date INTEGER NOT NULL,
          isAsync INTEGER DEFAULT 0,
          FOREIGN KEY (unitID) REFERENCES unit (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (itemID) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.commit(noResult: true);
  }

  Future<void> _onConfigure(Database db) async {
    // await db.rawQuery('SELECT PRAGMA cipher_migrate');
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('PRAGMA case_sensitive_like = true');
    // await db.execute('PRAGMA cipher_migrate = true');
  }
  Future<void> _onUpgrade(Database db, int oldVersion,int newVersion) async {
    final batch = db.batch();
    batch.execute("""
          CREATE TABLE storeReturn(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itemID INTEGER NOT NULL,
          unitID INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          date INTEGER NOT NULL,
          isAsync INTEGER DEFAULT 0,
          FOREIGN KEY (unitID) REFERENCES unit (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (itemID) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.execute("""
          CREATE TABLE percentage(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          value REAL DEFAULT 0.3)
        """);
    batch.execute("""
          CREATE TABLE operation(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          table TEXT NOT NULL,
          count INTEGER DEFAULT 0
          increment_number INTEGER DEFAULT 10)
        """);
    batch.execute("""
          CREATE TABLE user(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT,
          type TEXT ,
          status INTEGER DEFAULT 1,
          password TEXT DEFAULT 0)
        """);
    batch.commit(noResult: true);
    // for (int version = oldVersion; version < 3; version++) {
    //     await _onDBUpgrade(db,version);
    // }
  log('تحديــث قاعـدة البيانـات...');
  }
  /*
  Future<void> _onDBUpgrade(Database db, int upgradeToVersion) async {
    switch (upgradeToVersion) {
      case 2:
            await _dbUpgrade(db);
        break;
      case 3:
            await _dbUpgrade(db);
        break;
      default:
    }
  }
  Future<void> _dbUpgrade(Database db) async {
    final batch = db.batch();
    batch.execute("""
           CREATE TABLE storeReturn(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itemID INTEGER NOT NULL,
          unitID INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          date INTEGER NOT NULL,
          isAsync INTEGER DEFAULT 0,
          FOREIGN KEY (unitID) REFERENCES unit (id) ON UPDATE CASCADE ON DELETE CASCADE,
          FOREIGN KEY (itemID) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE)
        """);
    batch.commit(noResult: true);
  }
  */
  Future<int> insertMultiData(
      Map<String, dynamic> rowsBill, List<BillItem> rowsBillItem) async {
    try {
      final db = await database;
      var buffer = StringBuffer();
      final billID = await db.insert("bill", rowsBill);
      for (var c in rowsBillItem) {
        if (buffer.isNotEmpty) {
          buffer.write(",\n");
        }
        buffer.write("(");
        buffer.write(billID); //billID
        buffer.write(", ");
        buffer.write(c.itemID);
        buffer.write(", ");
        buffer.write(c.unitID);
        buffer.write(", ");
        buffer.write(c.count.text);
        buffer.write(", ");
        buffer.write(c.price);
        buffer.write(", ");
        buffer.write(c.discount.text);
        buffer.write(" ) ");
      }
      
      var row = await db.rawInsert("INSERT INTO bill_item (billID,itemID,unitID,quantity,price,discount)"
              " VALUES ${buffer.toString()}");
      log('Rows101 >>> $row');
      return row;
    } catch (e) {
      return 0;
    }
  }
}*/