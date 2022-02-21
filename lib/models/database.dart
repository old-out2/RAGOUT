import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../importer.dart';

//食べ物の情報
class Food {
  int id;
  String name;
  double cal;
  String protein;
  String lipids;
  String carb;
  String mineral;
  String bitamin;

  Food(
      {required this.id,
      required this.name,
      required this.cal,
      required this.protein,
      required this.lipids,
      required this.carb,
      required this.mineral,
      required this.bitamin});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cal': cal,
      'protein': protein,
      'lipids': lipids,
      'carb': carb,
      'mineral': mineral,
      'bitamin': bitamin,
    };
  }

  static Future<Database> get database async {
    Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'food_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          //食品データベース
          "CREATE TABLE food(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, cal REAL,protein TEXT, lipids TEXT,carb TEXT,mineral TEXT,bitamin TEXT)",
        );
        await db.execute(
          //バーコード食品データベース
          "CREATE TABLE barcode(code TEXT PRIMARY KEY, name TEXT, cal REAL,protein TEXT, lipids TEXT,carb TEXT,mineral TEXT,bitamin TEXT)",
        );
        await db.execute(
          //食べた物のデータベース
          "CREATE TABLE eat(date TEXT, foodid INTEGER, barcode TEXT , FOREIGN KEY(foodid) REFERENCES food(id), FOREIGN KEY(barcode) REFERENCES barcode(code))",
        );
        await db.execute(
          //一日の合計のデータベース
          "CREATE TABLE total(date TEXT PRIMARY KEY, cal REAL,protein TEXT, lipids TEXT,carb TEXT,mineral TEXT,bitamin TEXT)",
        );
        await db.execute(
          //ステータス date TEXT PRIMARY KEY,
          "CREATE TABLE status(power REAL, physical REAL, wisdom REAL, speed REAL, luck REAL)",
        );
        await db.execute(
          //敵のステータス
          "CREATE TABLE enemy(name INTEGER, HP INTEGER,power INTEGER,speed INTEGER,defenses INTEGER)",
        );
        await db.execute(
          //トロフィー
          "CREATE TABLE trophy(name TEXT, permission BOOLEAN)",
        );
      },
      version: 1,
    );
    return _database;
  }

  //食べ物とステータスの初期登録
  static Future<void> insertFood() async {
    Database db = await database;

    String loadData = await rootBundle.loadString('json/food.json');
    List<dynamic> jsonArray = jsonDecode(loadData);

    String barcode = await rootBundle.loadString('json/barcode.json');
    List<dynamic> barcodeArray = jsonDecode(barcode);

    String enemy = await rootBundle.loadString('json/enemy.json');
    List<dynamic> enemyArray = jsonDecode(enemy);

    Map<String, dynamic> status = {
      // "date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
      "power": 0,
      "physical": 0,
      "wisdom": 0,
      "speed": 0,
      "luck": 0
    };
    await db.insert('status', status,
        conflictAlgorithm: ConflictAlgorithm.replace);
    for (var item in jsonArray) {
      await db.insert(
        'food',
        item,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var item in barcodeArray) {
      await db.insert(
        'barcode',
        item,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var item in enemyArray) {
      await db.insert(
        'enemy',
        item,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Food>> getFoods(name) async {
    Database db = await database;
    //名前が一致する物を返す処理を書く必要がある
    List<Map<String, dynamic>> maps =
        await db.query('food', where: 'name LIKE ?', whereArgs: ['%$name%']);

    return List.generate(maps.length, (i) {
      return Food(
        id: maps[i]["id"],
        name: maps[i]["name"],
        cal: maps[i]["cal"],
        protein: maps[i]["protein"],
        lipids: maps[i]["lipids"],
        carb: maps[i]["carb"],
        mineral: maps[i]["mineral"],
        bitamin: maps[i]["bitamin"],
      );
    });
  }
}

//摂取カロリー
class Eat {
  String date;
  int foodid;
  String barcode;

  Eat({required this.date, required this.foodid, required this.barcode});
  Map<String, dynamic> toMap() {
    return {'date': date, 'foodid': foodid, 'barcode': barcode};
  }

  static Future<Database> get database async {
    Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'food_database.db'),
      version: 1,
    );
    return _database;
  }

  static Future<void> insertEat(List<Map<String, String>> eatfood) async {
    Database db = await database;

    for (var element in eatfood) {
      await db.insert('eat', element,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<List<Map<String, dynamic>>> getEat(String date) async {
    Database db = await database;
    List<Map<String, Object?>> maps = await db.rawQuery(
        'SELECT date,food.* FROM eat INNER JOIN food ON eat.foodid = food.id WHERE eat.date = ?',
        [date]);

    return maps;
  }

  static Future<List<Map<String, dynamic>>> getfoodcal(String date) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT food.cal FROM eat INNER JOIN food ON eat.foodid = food.id WHERE eat.date = ?',
        [date]);

    return maps;
  }

  static Future<List<Map<String, dynamic>>> getcodecal(String date) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT barcode.cal FROM eat INNER JOIN barcode ON eat.barcode = barcode.code WHERE eat.date = ?',
        [date]);

    return maps;
  }

  static Future<Map<String, dynamic>> getbarcode(String barcode) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT code, name , cal  FROM barcode WHERE code = ?', [barcode]);

    var map = {
      "barcode": maps[0]["code"],
      "name": maps[0]["name"],
      "cal": maps[0]["cal"],
    };
    return map;
  }

  static Future<void> Insertbarcode(Map<String, dynamic> maps) async {
    Database db = await database;

    await db.insert('eat', maps, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

//ステータス
class Status {
  // String date;
  double power;
  double physical;
  double widsom;
  double speed;
  double luck;

  Status(
      {
      // required this.date,
      required this.power,
      required this.physical,
      required this.widsom,
      required this.speed,
      required this.luck});

  Map<String, dynamic> toMap() {
    return {
      // 'date': date,
      'power': power,
      'physical': physical,
      'wisdom': widsom,
      "speed": speed,
      "luck": luck
    };
  }

  static Future<Database> get database async {
    Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'food_database.db'),
      version: 1,
    );
    return _database;
  }

  static Future<void> updateStatus(Status status) async {
    Database db = await database;
    await db.update('status', status.toMap());
    // where: "date = ?", whereArgs: [status.date]);
  }

  static Future<Status> getStatus() async {
    Database db = await database;
    //名前が一致する物を返す処理を書く必要がある
    List<Map<String, dynamic>> maps = await db.query("status");

    // return List.generate(maps.length, (i) {
    return Status(
      // date: maps[i]["date"],
      physical: maps[0]["physical"],
      power: maps[0]["power"],
      widsom: maps[0]["wisdom"],
      speed: maps[0]["speed"],
      luck: maps[0]["luck"],
    );
    // });
  }
}

//一日の合計カロリー
class total {
  static Future<Database> get database async {
    Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'food_database.db'),
      version: 1,
    );
    return _database;
  }

  static insertTotal(Map<String, String> total) async {
    Database db = await database;

    await db.insert('total', total,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static updateTotal(Map<String, String> total) async {
    Database db = await database;

    await db.update('total', total,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getTotal(String date) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT cal, protein, lipids,carb,mineral,bitamin FROM total WHERE date = ?',
        [date]);

    return maps;
  }
}
