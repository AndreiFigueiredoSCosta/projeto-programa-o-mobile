import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Exercicio.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Treino.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Usuario.dart';
import 'package:trabalho_programacao_mobile_andrei/models/HistoricoTreino.dart';

class SqliteController {
  static final SqliteController _instance = SqliteController._internal();
  static Database? _db;

  factory SqliteController() => _instance;

  SqliteController._internal();

  Future<void> initDb() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'treino_app.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Criando tabela usuario...');
        await db.execute('''
          CREATE TABLE usuario (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL
          );
        ''');

        print('Criando tabela treino...');
        await db.execute('''
          CREATE TABLE treino (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            usuario_id INTEGER NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
          )
        ''');

        print('Criando tabela exercicio...');
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

        print('Criando tabela historico_treino...');
        await db.execute('''
          CREATE TABLE historico_treino (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            treino_id INTEGER NOT NULL,
            data TEXT NOT NULL,
            FOREIGN KEY (treino_id) REFERENCES treino(id) ON DELETE CASCADE
          )
        ''');

        print('Banco de dados criado com sucesso.');
      },
    );
  }

  Database get db {
    if (_db == null) {
      throw Exception('Banco não iniciado. Chame initDb().');
    }
    return _db!;
  }

  // --- USUÁRIOS ---
  Future<void> insertUsuario(Usuario usuario) async {
    await db.insert('usuario', usuario.toMap());
    printDatabase();
  }

  Future<Usuario?> getUsuarioById(int id) async {
    final result = await db.query('usuario', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Usuario.fromMap(result.first);
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    final res = await db.query(
      'usuario',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (res.isEmpty) return null;
    return Usuario.fromMap(res.first);
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

  Future<List<Treino>> getTreinosByUsuario(int usuarioId) async {
    final result = await db.query('treino', where: 'usuario_id = ?', whereArgs: [usuarioId]);
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

  // --- HISTÓRICO DE TREINOS ---
  Future<void> insertHistoricoTreino(HistoricoTreino historico) async {
    await db.insert('historico_treino', historico.toMap());
    printDatabase();
  }

  Future<List<HistoricoTreino>> getHistoricoByTreino(int treinoId) async {
    final result = await db.query(
      'historico_treino',
      where: 'treino_id = ?',
      whereArgs: [treinoId],
      orderBy: 'data DESC',
    );
    return result.map((e) => HistoricoTreino.fromMap(e)).toList();
  }

  Future<void> deleteHistoricoTreino(int id) async {
    await db.delete('historico_treino', where: 'id = ?', whereArgs: [id]);
    printDatabase();
  }

  // --- DEBUG ---
  Future<void> printDatabase() async {
    print('--- Usuários ---');
    final usuarios = await db.query('usuario');
    for (var u in usuarios) {
      print('ID: ${u['id']}, Nome: ${u['nome']}');
    }

    print('--- Treinos ---');
    final treinos = await db.query('treino');
    for (var t in treinos) {
      print('ID: ${t['id']}, Nome: ${t['nome']}, Usuário ID: ${t['usuario_id']}');
    }

    print('--- Exercícios ---');
    final exercicios = await db.query('exercicio');
    for (var e in exercicios) {
      print('ID: ${e['id']}, Nome: ${e['nome']}, Treino ID: ${e['treino_id']}');
    }

    print('--- Histórico de Treinos ---');
    final historicos = await db.query('historico_treino');
    for (var h in historicos) {
      print('ID: ${h['id']}, Treino ID: ${h['treino_id']}, Data: ${h['data']}');
    }
  }
}
