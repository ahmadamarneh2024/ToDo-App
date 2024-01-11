import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/NoteClass.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }


  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Notes (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        dueto TEXT
      )
    ''');
  }
  Future<int> insertNote(Notes note) async {
    try {
      Database db = await instance.database;
      return await db.insert('Notes', note.toMap());
    } catch (e) {
      print("Error inserting note: $e");
      return -1; // Return a value that indicates failure
    }
  }


  Future<List<Notes>> getAllNotes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('Notes');
    return List.generate(maps.length, (i) {
      return Notes(
        // id: maps[i]['id'],
        Notetitle: maps[i]['title'],
        NoteDescription: maps[i]['description'],
        // You may want to convert the 'dueto' string to a DateTime if needed
      );
    });
  }
  Future<int> deleteNote(int id) async {
    try {
      Database db = await instance.database;
      return await db.delete('Notes', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting note: $e");
      return -1; // Return a value that indicates failure
    }
  }
}