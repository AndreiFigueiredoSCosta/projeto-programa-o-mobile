import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Treino.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Exercicio.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Serie.dart';

class SqliteController {
  static final SqliteController _instance = SqliteController._internal();
  static Database? _db;

  factory SqliteController() {
    return _instance;
  }

  SqliteController._internal();

  Future<void> initDb() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'treino_app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE treino (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE exercicio (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            treino_id INTEGER NOT NULL,
            nome TEXT NOT NULL,
            series INTEGER NOT NULL,
            repeticoes_min INTEGER NOT NULL,
            repeticoes_max INTEGER NOT NULL,
            descanso_segundos INTEGER NOT NULL,
            FOREIGN KEY (treino_id) REFERENCES treino(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE serie (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exercicio_id INTEGER NOT NULL,
            numero_serie INTEGER NOT NULL,
            carga REAL NOT NULL,
            repeticoes INTEGER NOT NULL,
            data TEXT NOT NULL,
            FOREIGN KEY (exercicio_id) REFERENCES exercicio(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Database get db {
    if (_db == null) {
      throw Exception('Banco de dados não foi inicializado. Chame initDb() antes de usar.');
    }
    return _db!;
  }

  // --- TREINOS ---
  Future<void> insertTreino(Treino treino) async {
    await db.insert('treino', treino.toMap());
    printDatabase();
  }

  Future<List<Treino>> getTreinos() async {
    final result = await db.query('treino');
    return result.map((e) => Treino.fromMap(e)).toList();
  }

  Future<void> updateTreino(Treino treino) async {
    await db.update('treino', treino.toMap(), where: 'id = ?', whereArgs: [treino.id]);
    printDatabase();
  }

  Future<void> deleteTreino(int id) async {
    await db.delete('treino', where: 'id = ?', whereArgs: [id]);
    printDatabase();
  }

  // --- EXERCÍCIOS ---
  Future<void> insertExercicio(Exercicio exercicio) async {
    await db.insert('exercicio', exercicio.toMap());
    printDatabase();
  }

  Future<List<Exercicio>> getExerciciosByTreino(int treinoId) async {
    final result = await db.query('exercicio', where: 'treino_id = ?', whereArgs: [treinoId]);
    return result.map((e) => Exercicio.fromMap(e)).toList();
  }

  Future<void> updateExercicio(Exercicio exercicio) async {
    await db.update('exercicio', exercicio.toMap(), where: 'id = ?', whereArgs: [exercicio.id]);
    printDatabase();
  }

  Future<void> deleteExercicio(int id) async {
    await db.delete('exercicio', where: 'id = ?', whereArgs: [id]);
    printDatabase();
  }

  // --- SÉRIES ---
  Future<void> insertSerie(Serie serie) async {
    await db.insert('serie', serie.toMap());
    printDatabase();
  }

  Future<List<Serie>> getSeriesByExercicio(int exercicioId) async {
    final result = await db.query(
      'serie',
      where: 'exercicio_id = ?',
      whereArgs: [exercicioId],
      orderBy: 'data DESC, numero_serie ASC',
    );
    return result.map((e) => Serie.fromMap(e)).toList();
  }

  Future<void> updateSerie(Serie serie) async {
    await db.update('serie', serie.toMap(), where: 'id = ?', whereArgs: [serie.id]);
    printDatabase();
  }

  Future<void> deleteSerie(int id) async {
    await db.delete('serie', where: 'id = ?', whereArgs: [id]);
    printDatabase();
  }

  // --- DEBUG ---
  Future<void> printDatabase() async {
    print('--- Treinos ---');
    final treinos = await db.query('treino');
    for (var t in treinos) {
      print('ID: ${t['id']}, Nome: ${t['nome']}');
    }

    print('--- Exercícios ---');
    final exercicios = await db.query('exercicio');
    for (var e in exercicios) {
      print('ID: ${e['id']}, Nome: ${e['nome']}, Treino ID: ${e['treino_id']}');
    }

    print('--- Séries ---');
    final series = await db.query('serie');
    for (var s in series) {
      print('ID: ${s['id']}, Carga: ${s['carga']}, Reps: ${s['repeticoes']}, Exercicio ID: ${s['exercicio_id']}');
    }
  }
}
