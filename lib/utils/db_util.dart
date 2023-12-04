import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  //operações com o bd SQLite
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'championships.db'),
      onCreate: (db, version) {
        // Executa o DDL para criar o banco
        return db.execute(
          'CREATE TABLE championships (id TEXT PRIMARY KEY, name TEXT, description TEXT, location TEXT, creatorId TEXT, price REAL, imgUrl TEXT, startDate TEXT, endDate TEXT, competitors TEXT, bracketsGenerated BOOLEAN, lat REAL, lng REAL)',
        );
      },
      version: 8,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();

    List<Map<String, dynamic>> allData = await db.query(table);
    if (allData.length >= 5) {
      // remove o item mais antigo (o primeiro na lista)
      await db.delete(table, where: 'id = ?', whereArgs: [allData.first['id']]);
    }

    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateItem(
      String table, String id, Map<String, Object> newItem) async {
    final db = await DbUtil.database();
    await db.update(
      table,
      newItem,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteItem(String table, String id) async {
    final db = await DbUtil.database();
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAllItems(String table) async {
    final db = await DbUtil.database();
    await db.delete(table);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();    

    return db.query(table);
  }
}
