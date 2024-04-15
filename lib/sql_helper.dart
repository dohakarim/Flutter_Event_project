import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
  await database.execute("""CREATE TABLE evenement(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      titre TEXT,
      description TEXT,
      lieu TEXT,
      type TEXT,
      date_evenement TEXT,
      
      image TEXT,  

      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  // print('Table "evenement" created successfully.');
}


// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbevents.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String titre, String? description, String lieu, String type, String dateEvenement, String image) async {
  final db = await SQLHelper.db();

  final data = {
    'titre': titre,
    'description': description,
    'lieu': lieu,
    'type': type,
    'date_evenement': dateEvenement,
    'image': image 
  };

  final id = await db.insert('evenement', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  return id;
}


  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('evenement', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('evenement', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String titre, String? description, String lieu, String type, String image, String dateEvenement) async {
  final db = await SQLHelper.db();

  final data = {
    'titre': titre,
    'description': description,
    'lieu': lieu,
    'type': type,
    'image': image, // Ajout du champ image
    'date_evenement': dateEvenement.toString(), // Conversion de la date en String
    'createdAt': DateTime.now().toString()
  };

  final result = await db.update('evenement', data, where: "id = ?", whereArgs: [id]);
  return result;
}

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("evenement", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
