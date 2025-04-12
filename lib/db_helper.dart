import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/user.dart';
import 'models/note.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dbPath = join(await getDatabasesPath(), 'remember_location.db');
    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        address TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        locationName TEXT,
        description TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<bool> userExists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.isNotEmpty;
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final maps = await db.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
