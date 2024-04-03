import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SQLHelper {

  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  static Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
CREATE TABLE notes (
  id INTEGER PRIMARY KEY,
  title TEXT,
  content TEXT,
  description TEXT NULL
) 
      ''');
    print('On create was called');

    batch.execute('''
CREATE TABLE todos (
  id INTEGER PRIMARY KEY,
  title TEXT,
  value BOOL
) 
      ''');
    batch.commit();

    print('On create was called');
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('ALTER TABLE notes ADD COLUMN description TEXT NULL');

    await db.execute('''
CREATE TABLE todos (
  id INTEGER PRIMARY KEY,
  title TEXT,
  value BOOL 
) 
      ''');
    print('on upgrade was called');
  }

  static Future insertNote(Note note) async {
    Database db = await getDatabase;
    await db.insert('notes', note.toMap());
        // conflictAlgorithm: ConflictAlgorithm.replace);
    print(await db.query('notes'));
  }

  static Future insertTodo(Todo todo) async {
    Database db = await getDatabase;
    await db.insert('todos', todo.toMap());
    print(await db.query('todos'));
  }

  static Future<List<Map>> loadNotes() async {
    Database db = await getDatabase;
    // List<Map> maps = 
    return await db.query('notes');
    // return List.generate(maps.length, (index) {
    //   return Note(
    //     id: maps[index]['id'],
    //     title: maps[index]['title'],
    //     content: maps[index]['content'],
    //     description: maps[index]['description'],
    //   ).toMap();
    // });
  }

  static Future<List<Map>> loadTodos() async {
    Database db = await getDatabase;
    List<Map> maps = await db.query('todos');
    return List.generate(maps.length, (index) {
      return Todo(
        id: maps[index]['id'],
        title: maps[index]['title'],
        value: maps[index]['value'],
      ).toMap();
    });
  }

  static Future updateNote(Note newNote) async {
    Database db = await getDatabase;
    await db.update('notes', newNote.toMap(),
        where: 'id=?', whereArgs: [newNote.id]);
  }

  static Future updateNoteRaw(Note newNote) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE notes SET title = ?, content = ? WHERE id = ?',
        [newNote.title, newNote.content, newNote.id]);
  }

  static Future updateTodoChecked(int id, int currentValue) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE todos SET value = ? WHERE id = ?',
        [currentValue == 0 ? 1 : 0, id]);
  }

  static Future deleteNote(int id) async {
    Database db = await getDatabase;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future deleteNoteRaw(int id) async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM notes WHERE id = ?', [id]);
  }

  static Future deleteForever() async {
    Database db = await getDatabase;
    await db.delete('notes');
  }

  static Future deleteForeverRaw() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM notes');
  }
}

class Note {
  Note({
    required this.id,
    required this.title,
    required this.content,
    this.description,
  });

  final int id;
  final String title;
  final String content;
  String? description;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, descrption: $description}';
  }
}

class Todo {
  Todo({
    this.id,
    required this.title,
    this.value = 0,
  });

  final int? id;
  final String title;
  int value;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, value: $value}';
  }
}
