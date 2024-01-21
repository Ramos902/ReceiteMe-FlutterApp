import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

const String recipeTable = "receitas";
const String idColumn = "idReceita";
const String nomeColumn = "nome";
const String ingredientesColumn = "ingredientes";
const String instrucoesColumn = "instrucoes";
const String fotoColumn = "foto";

class RecipeHelper {
  static final RecipeHelper _instance = RecipeHelper.internal();
  factory RecipeHelper() => _instance;
  RecipeHelper.internal();
  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "recipes.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $recipeTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $ingredientesColumn TEXT, $instrucoesColumn TEXT, $fotoColumn TEXT)");
    });
  }

  Future<Recipe> saveRecipe(Recipe recipe) async {
    Database? dbRecipe = await db;
    recipe.id = await dbRecipe?.insert(recipeTable, recipe.toMap());
    return recipe;
  }

  Future<Recipe?> getRecipe(int id) async {
    Database? dbRecipe = await db;

    List<Map> maps = await dbRecipe!.query(recipeTable,
        columns: [
          idColumn,
          nomeColumn,
          ingredientesColumn,
          instrucoesColumn,
          fotoColumn
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Recipe.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteRecipe(int id) async {
    Database? dbRecipe = await db;
    return await dbRecipe!.delete(
      recipeTable,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    try {
      Database? dbRecipe = await db;
      int updatedRows = await dbRecipe!.update(
        recipeTable,
        recipe.toMap(),
        where: '$idColumn = ?',
        whereArgs: [recipe.id],
      );
      return updatedRows > 0; // Retorna verdadeiro se linhas foram atualizadas
    } catch (e) {
      print('Erro ao atualizar a receita: $e');
      return false; // Retorna falso se houver algum erro durante a atualização
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    Database? dbRecipe = await db;
    List listMap = await dbRecipe!.rawQuery('SELECT * FROM $recipeTable');
    List<Recipe> listRecipe = [];
    for (Map m in listMap) {
      listRecipe.add(Recipe.fromMap(m));
    }
    return listRecipe;
  }

  Future<int?> getTotalRecipes() async {
    Database? dbRecipe = await db;
    return Sqflite.firstIntValue(
        await dbRecipe!.rawQuery('SELECT COUNT(*) FROM $recipeTable'));
  }

  Future<void> close() async {
    Database? dbRecipe = await db;
    dbRecipe!.close();
  }
}

class Recipe {
  int? id;
  String? nome;
  String? ingredientes;
  String? instrucoes;
  String? foto;

  Recipe({this.id, this.nome, this.ingredientes, this.instrucoes, this.foto});

  Recipe.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    ingredientes = map[ingredientesColumn];
    instrucoes = map[instrucoesColumn];
    foto = map[fotoColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      ingredientesColumn: ingredientes,
      instrucoesColumn: instrucoes,
      fotoColumn: foto
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
