import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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
          //食べた物のデータベース
          "CREATE TABLE eat(date TEXT, foodid INTEGER, eiyo TEXT ,FOREIGN KEY(foodid) REFERENCES food(id))",
        );
        await db.execute(
          //一日の合計のデータベース
          "CREATE TABLE total(date TEXT PRIMARY KEY, cal REAL,protein TEXT, lipids TEXT,carb TEXT,mineral TEXT,bitamin TEXT)",
        );
        await db.execute(
          //ステータス
          "CREATE TABLE status(date TEXT PRIMARY KEY, growth INTEGER, status TEXT)",
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

  static Future<void> insertFood() async {
    String loadData = await rootBundle.loadString('json/food.json');
    List<dynamic> jsonArray = jsonDecode(loadData);
    Database db = await database;
    for (var item in jsonArray) {
      await db.insert(
        'food',
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
  String eiyo;

  Eat({required this.date, required this.foodid, required this.eiyo});
  Map<String, dynamic> toMap() {
    return {'date': date, 'foodid': foodid, 'eiyo': eiyo};
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

  static Future<List<Map<String, dynamic>>> getcal(String date) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT food.cal FROM eat INNER JOIN food ON eat.foodid = food.id WHERE eat.date = ?',
        [date]);

    return maps;
  }
}

//ステータス
class Status {
  String date;
  int growth;
  String status;

  Status({required this.date, required this.growth, required this.status});

  Map<String, dynamic> toMap() {
    return {'date': date, 'growth': growth, 'status': status};
  }

  static Future<Database> get database async {
    Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'food_database.db'),
      version: 1,
    );
    return _database;
  }

  static Future<void> insertStatus() async {
    var test = {
      "date": "2021/01/01",
      "growth": 100,
      "status":
          "{'cal': 100, 'protein': 5,'lipids': 4,'carb': 3,'mineral': 2,'bitamin':1}"
    };
    Database db = await database;
    await db.insert('status', test,
        conflictAlgorithm: ConflictAlgorithm.replace);
    // for (var item in jsonArray) {
    //   await db.insert(
    //     'status',
    //     item,
    //     conflictAlgorithm: ConflictAlgorithm.replace,
    //   );
    // }
  }

  static Future<void> updateStatus(Status status) async {
    Database db = await database;
    await db.update('status', status.toMap(),
        where: "date = ?", whereArgs: [status.date]);
  }

  static Future<List<Status>> getStatus() async {
    Database db = await database;
    //名前が一致する物を返す処理を書く必要がある
    List<Map<String, dynamic>> maps = await db.query("status");

    return List.generate(maps.length, (i) {
      return Status(
        date: maps[i]["date"],
        growth: maps[i]["growth"],
        status: maps[i]["status"],
      );
    });
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
