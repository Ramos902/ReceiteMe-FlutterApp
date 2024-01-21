import 'package:flutter/material.dart';
import 'package:receiteme_project/helpers/recipe_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:receiteme_project/screens/content/home.dart';

class TelaReceitas extends StatefulWidget {
  @override
  _TelaReceitasState createState() => _TelaReceitasState();
}

class _TelaReceitasState extends State<TelaReceitas> {
  List<Recipe> receitas = []; // Lista de receitas vinda do banco de dados

  @override
  void initState() {
    super.initState();
    _loadRecipesFromDB();
  }

  Future<void> _loadRecipesFromDB() async {
    try {
      RecipeHelper recipeHelper = RecipeHelper();
      List<Recipe> recipes = await recipeHelper.getAllRecipes();
      setState(() {
        receitas = recipes;
      });
    } catch (e) {
      print('Erro ao carregar receitas: $e');
      // Trate o erro conforme necessário
    }
  }

  void _verDetalhesReceita(BuildContext context, Recipe receita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhesReceita(
          receita: receita,
          onRecipeUpdated: (updatedRecipe) {
            _loadRecipesFromDB();
          },
          onRecipeDeleted: (deletedRecipe) {
            setState(() {
              receitas.removeWhere((recipe) => recipe.id == deletedRecipe.id);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: receitas.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            _verDetalhesReceita(context, receitas[index]);
          },
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: receitas[index].foto != null
                            ? Image.file(
                                File(receitas[index].foto!),
                                fit: BoxFit.cover,
                              )
                            : Placeholder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receitas[index].nome ?? 'Nome não encontrado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TelaDetalhesReceita extends StatefulWidget {
  final Recipe receita;
  final Function(Recipe) onRecipeUpdated;
  final Function(Recipe) onRecipeDeleted;

  const TelaDetalhesReceita({
    Key? key,
    required this.receita,
    required this.onRecipeUpdated,
    required this.onRecipeDeleted,
  }) : super(key: key);

  @override
  _TelaDetalhesReceitaState createState() => _TelaDetalhesReceitaState();
}

class _TelaDetalhesReceitaState extends State<TelaDetalhesReceita> {
  void _editarReceita(BuildContext context, Recipe receita) async {
    final updatedRecipe = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaEditarReceita(receita: receita),
      ),
    );

    if (updatedRecipe != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receita atualizada!')),
      );

      // Atualiza a receita com os dados atualizados
      setState(() {
        receita.nome = updatedRecipe.nome;
        receita.ingredientes = updatedRecipe.ingredientes;
        receita.instrucoes = updatedRecipe.instrucoes;
        receita.foto = updatedRecipe.foto;
      });

      // Chama a função de callback para notificar a tela inicial sobre a alteração
      widget.onRecipeUpdated(receita);
    }
  }

  void _excluirReceita(BuildContext context, Recipe receita) async {
    await _excluirReceitaDoBanco(receita.id!);

    widget.onRecipeDeleted(receita);

    Navigator.of(context).pop();
  }

  Future<void> _excluirReceitaDoBanco(int id) async {
    RecipeHelper helper = RecipeHelper();
    await helper.deleteRecipe(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receita.nome ?? 'Nome não encontrado'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.receita.foto != null
                ? SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(widget.receita.foto!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Placeholder(
                    fallbackHeight: 200, fallbackWidth: double.infinity),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredientes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.receita.ingredientes ??
                            'Lista de ingredientes não encontrada',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instruções:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.receita.instrucoes ??
                            'Instruções não encontradas',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _editarReceita(context, widget.receita);
                  },
                  child: Text('Editar Receita'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _excluirReceita(context, widget.receita);
                  },
                  child: Text('Excluir Receita'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _excluirReceita(BuildContext context, Recipe receita) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Excluir Receita'),
        content: const Text('Tem certeza que deseja excluir esta receita?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              RecipeHelper helper = RecipeHelper();
              await helper.deleteRecipe(
                  receita.id!); // Exclui a receita do banco de dados
              Navigator.of(context).pop(); // Fecha o diálogo de confirmação
              Navigator.of(context).pop(); // Fecha a tela de detalhes
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

class TelaEditarReceita extends StatefulWidget {
  final Recipe receita;

  const TelaEditarReceita({required this.receita});

  @override
  _TelaEditarReceitaState createState() => _TelaEditarReceitaState();
}

class _TelaEditarReceitaState extends State<TelaEditarReceita> {
  late TextEditingController _tituloController;
  late TextEditingController _imagemController;
  late TextEditingController _ingredientesController;
  late TextEditingController _instrucoesController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.receita.nome);
    _imagemController = TextEditingController(text: widget.receita.foto ?? '');
    _ingredientesController =
        TextEditingController(text: widget.receita.ingredientes ?? '');
    _instrucoesController =
        TextEditingController(text: widget.receita.instrucoes ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Receita'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Título'),
              controller: _tituloController,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'URL da Imagem'),
              controller: _imagemController,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Ingredientes'),
              controller: _ingredientesController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Instruções'),
              controller: _instrucoesController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: null,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Recipe editedRecipe = Recipe(
                      id: widget.receita.id,
                      nome: _tituloController.text,
                      foto: _imagemController.text,
                      ingredientes: _ingredientesController.text,
                      instrucoes: _instrucoesController.text,
                    );
                    RecipeHelper helper = RecipeHelper();
                    await helper.updateRecipe(editedRecipe);
                    Navigator.pop(
                        context, editedRecipe); // Retorna com o resultado
                  },
                  child: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _imagemController.dispose();
    _ingredientesController.dispose();
    _instrucoesController.dispose();
    super.dispose();
  }
}

class TelaCriarReceita extends StatefulWidget {
  @override
  _TelaCriarReceitaState createState() => _TelaCriarReceitaState();
}

class _TelaCriarReceitaState extends State<TelaCriarReceita> {
  String _imageUrl = '';
  String _title = '';
  String _ingredients = '';
  String _instructions = '';
  final _imagePicker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _saveRecipe() async {
    if (_imageUrl.isEmpty ||
        _title.isEmpty ||
        _ingredients.isEmpty ||
        _instructions.isEmpty) {
      return;
    }

    Recipe newRecipe = Recipe(
      nome: _title,
      ingredientes: _ingredients,
      instrucoes: _instructions,
      foto: _imageUrl,
    );

    RecipeHelper recipeHelper = RecipeHelper();
    Recipe savedRecipe = await recipeHelper.saveRecipe(newRecipe);

    if (savedRecipe.id != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      ); // Retorna para a tela anterior (tela inicial)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReceiteMe'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'URL da Imagem',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Insira a URL da imagem da receita',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _imageUrl = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _getImage,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: 200,
              child: _imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        File(_imageUrl),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    )
                  : Container(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Título da Receita',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Insira o título da sua receita',
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingredientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Insira os ingredientes da receita',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  _ingredients = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Modo de Preparo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Insira o modo de preparo da receita',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  _instructions = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveRecipe,
                  child: const Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
