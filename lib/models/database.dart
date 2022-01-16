import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

//食べ物の情報
class Food {
  int id;
  String name;
  double cal;
  double protein;
  double lipids;
  double carb;
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
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE food(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, cal REAL,protein REAL, lipids REAL,carb REAL,mineral TEXT,bitamin TEXT)",
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

  static Future<List<Food>> getFoods() async {
    Database db = await database;
    //名前が一致する物を返す処理を書く必要がある
    List<Map<String, dynamic>> maps = await db.query('food');
    return List.generate(10, (i) {
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
//カロリー消費
//ステータス
//ユーザー情報