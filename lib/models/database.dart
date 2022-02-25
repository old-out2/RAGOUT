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
          "CREATE TABLE enemy(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, HP INTEGER,power INTEGER,speed INTEGER,defense INTEGER,permission BOOLEAN)",
        );
        await db.execute(
          //トロフィー
          "CREATE TABLE trophy(name TEXT, permission BOOLEAN, enemyid INTEGER, FOREIGN KEY(enemyid) REFERENCES enemy(id))",
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

    Map<String, dynamic> status = {
      // "date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
      "power": 5,
      "physical": 5,
      "wisdom": 5,
      "speed": 5,
      "luck": 5
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

    final now = DateTime.now();
    String yesterday =
        DateFormat('yyyy/MM/dd').format(now.add(const Duration(days: 1) * -1));
    //デバッグ用 total
    Map<String, dynamic> eat = {
      'date': yesterday,
      'cal': "2000",
      'protein': "90",
      'lipids': "40",
      'carb': "130",
      'mineral': "5000",
      'bitamin': "20"
    };
    await db.insert(
      'total',
      eat,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insert() async {
    Database db = await database;
    String enemy = await rootBundle.loadString('json/enemy.json');
    List<dynamic> enemyArray = jsonDecode(enemy);

    String trophy = await rootBundle.loadString('json/trophy.json');
    List<dynamic> trophyArray = jsonDecode(trophy);

    for (var item in enemyArray) {
      await db.insert(
        'enemy',
        item,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var item in trophyArray) {
      await db.insert(
        'trophy',
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
        'SELECT * FROM eat INNER JOIN barcode ON eat.barcode = barcode.code WHERE eat.date = ?',
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
  double wisdom;
  double speed;
  double luck;

  Status(
      {
      // required this.date,
      required this.power,
      required this.physical,
      required this.wisdom,
      required this.speed,
      required this.luck});

  Map<String, dynamic> toMap() {
    return {
      // 'date': date,
      'power': power,
      'physical': physical,
      'wisdom': wisdom,
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
      power: maps[0]["power"],
      physical: maps[0]["physical"],
      wisdom: maps[0]["wisdom"],
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

  static Future<Map<String, dynamic>> getTotal(String date) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT cal, protein, lipids,carb,mineral,bitamin FROM total WHERE date = ?',
        [date]);

    if (maps.isEmpty) {
      return {
        "date": null,
        'cal': '0',
        'protein': '0',
        'lipids': '0',
        'carb': '0',
        'mineral': '0',
        'bitamin': '0'
      };
    }

    return {
      'cal': maps[0]['cal'],
      'protein': maps[0]["protein"],
      'lipids': maps[0]["lipids"],
      'carb': maps[0]["carb"],
      'mineral': maps[0]["mineral"],
      'bitamin': maps[0]["bitamin"],
    };
  }
}

class Enemy {
  static Future<Database> get database async {
    Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'food_database.db'),
      version: 1,
    );
    return _database;
  }

  static Future<Map<String, dynamic>> getEnemy() async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT id, name, HP ,power ,speed,defense FROM enemy WHERE permission = 1');

    return {
      'id': maps[0]['id'],
      'name': maps[0]['name'],
      'HP': maps[0]["HP"],
      'power': maps[0]["power"],
      'speed': maps[0]["speed"],
      'defense': maps[0]["defense"],
    };
  }

  static updateEnemy(int id) async {
    Database db = await database;

    await db.rawUpdate('UPDATE enemy SET permission = 0 WHERE id = ?', [id]);
    await db
        .rawUpdate('UPDATE enemy SET permission = 1 WHERE id = ?', [id + 1]);
  }
}

class trophy {
  static Future<Database> get database async {
    Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'food_database.db'),
      version: 1,
    );
    return _database;
  }

  static Future<List<String>> getTrophy() async {
    Database db = await database;

    List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT name FROM trophy WHERE permission = 1');

    return List.generate(maps.length, (index) => maps[index]["name"]);
  }

  static updateTrophy(int id) async {
    Database db = await database;

    await db
        .rawUpdate('UPDATE trophy SET permission = 1 WHERE enemyid = ?', [id]);
  }

  static Future<String> getNewTrophy(int id) async {
    Database db = await database;

    List<Map<String, Object?>> trophyname =
        await db.rawQuery('SELECT name FROM trophy WHERE enemyid = ?', [id]);

    print(trophyname);

    String name = trophyname.isNotEmpty ? trophyname[0]["name"].toString() : "";

    return name;
  }
}
