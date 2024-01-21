import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String tableName = 'users';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'user_database.db');

    return await openDatabase(dbPath, version: 1,
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            password TEXT
          )
          ''');
    });
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

class AuthService {
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  static String? _loggedInUserEmail; // E-mail do usuário logado

  Future<bool> signUp(String nome, String email, String password) async {
    final db = await _databaseProvider.database;
    try {
      await db.insert(
        DatabaseProvider.tableName,
        {'name': nome, 'email': email, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    final db = await _databaseProvider.database;
    try {
      final result = await db.query(
        DatabaseProvider.tableName,
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isNotEmpty) {
        // Caso exista um usuário com o email fornecido, verifique se a senha está correta
        final user = result.first;
        if (user['password'] == password) {
          print('Usuário logado com sucesso: $email');
          _loggedInUserEmail = email;
          return true; // Credenciais corretas, autenticação bem-sucedida
        } else {
          print('Senha incorreta para o email: $email');
          return false; // Senha incorreta
        }
      } else {
        print('Usuário não encontrado com o email: $email');
        return false; // Usuário não encontrado
      }
    } catch (e) {
      print('Erro ao verificar usuário: $e');
      return false;
    }
  }

  static String? getLoggedInUserEmail() {
    return _loggedInUserEmail;
  }

  static bool isUserLoggedIn() {
    return _loggedInUserEmail != null;
  }

  Future<Map<String, dynamic>> getUserData(String email) async {
    final db = await _databaseProvider.database;
    try {
      final result = await db.query(
        DatabaseProvider.tableName,
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isNotEmpty) {
        return result.first;
      } else {
        throw ('Usuário não encontrado com o email: $email');
      }
    } catch (e) {
      throw ('Erro ao obter dados do usuário: $e');
    }
  }

  Future<void> signOut() async {
    // Implemente a lógica de logout, se necessário
  }
}
