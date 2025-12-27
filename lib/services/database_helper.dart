import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mcq_model.dart';
import '../models/short_question_model.dart';
import '../models/long_question_model.dart';
import '../models/test_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('examcraft.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // MCQs table
    await db.execute('''
      CREATE TABLE mcqs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        options TEXT NOT NULL,
        correctAnswer TEXT NOT NULL,
        userAnswer TEXT,
        difficulty TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Questions table (short/long)
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        type TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Test results table
    await db.execute('''
      CREATE TABLE test_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        testTitle TEXT NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        percentage REAL NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // MCQ operations
  Future<int> insertMCQ(Map<String, dynamic> mcq) async {
    final db = await database;
    return await db.insert('mcqs', mcq);
  }

  Future<List<Map<String, dynamic>>> getAllMCQs() async {
    final db = await database;
    return await db.query('mcqs', orderBy: 'createdAt DESC');
  }

  Future<int> deleteMCQ(int id) async {
    final db = await database;
    return await db.delete('mcqs', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllMCQs() async {
    final db = await database;
    return await db.delete('mcqs');
  }

  // Question operations
  Future<int> insertQuestion(Map<String, dynamic> question) async {
    final db = await database;
    return await db.insert('questions', question);
  }

  Future<List<Map<String, dynamic>>> getQuestionsByType(String type) async {
    final db = await database;
    return await db.query(
      'questions',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'createdAt DESC',
    );
  }

  Future<int> deleteQuestion(int id) async {
    final db = await database;
    return await db.delete('questions', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteQuestionsByType(String type) async {
    final db = await database;
    return await db.delete('questions', where: 'type = ?', whereArgs: [type]);
  }

  // Test result operations
  Future<int> insertTestResult(Map<String, dynamic> result) async {
    final db = await database;
    return await db.insert('test_results', result);
  }

  Future<List<Map<String, dynamic>>> getAllTestResults() async {
    final db = await database;
    return await db.query('test_results', orderBy: 'createdAt DESC');
  }

  Future<int> deleteTestResult(int id) async {
    final db = await database;
    return await db.delete('test_results', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
