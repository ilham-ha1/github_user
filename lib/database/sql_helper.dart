import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE favorite(id INTEGER PRIMARY KEY NOT NULL,
       username TEXT, 
       avatarurl TEXT,
       createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('user.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //CRD
  //CREATE
  static Future<int> createItem(
      int iduser, String username, String avatarurl) async {
    final db = await SQLHelper.db();

    final data = {'id': iduser, 'username': username, 'avatarurl': avatarurl};

    final id = await db.insert('favorite', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //READ
  static Future<List<Map<String, dynamic>>> getItem() async{
    final db = await SQLHelper.db();
    return db.query('favorite', orderBy: 'id');
  } // get as map

  static Future<bool> getItemById(int id) async{
    final db = await SQLHelper.db();
    final result = await db.query('favorite', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty;
  }

  //DELETE
  static Future<void> deleteItem(int id) async{
    final db = await SQLHelper.db();
    try{
      await db.delete('favorite', where: "id = ?", whereArgs: [id]);
    }catch(err){
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

}
