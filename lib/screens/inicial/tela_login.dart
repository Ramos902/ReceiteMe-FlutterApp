import 'package:flutter/material.dart';
import 'package:receiteme_project/screens/content/home.dart';
import 'package:receiteme_project/screens/inicial/tela_registro.dart';
import 'package:receiteme_project/helpers/user_database.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _senhaOculta = false;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Definição do GlobalKey
  final AuthService _authService =
      AuthService(); // Instância do seu AuthService
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              right: 25,
              left: 25,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 50,
                      bottom: 25,
                    ),
                    //Topo da tela de login
                    //Login da parte superior
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //email label
                  const Text(
                    'Email',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.left,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: "Digite seu e-mail",
                        labelStyle: TextStyle(color: Colors.black)),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 15),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu e-mail';
                      }
                      return null;
                    },
                  ),

                  //senha label
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 40,
                      bottom: 1,
                    ),
                    child: Text(
                      'Senha',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua Senha!';
                      }
                      return null;
                    },
                    obscureText: !_senhaOculta, //ocultar a senha
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Digite sua senha',

                      //Mostrar/Ocultar senha
                      //Variavel do tipo boolean que muda o estado de visivel para invisivel
                      suffixIcon: IconButton(
                        icon: Icon(
                          _senhaOculta
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _senhaOculta = !_senhaOculta;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
                    child: FloatingActionButton.extended(
                      label: const Text(
                        "Entrar",
                        style: TextStyle(fontSize: 20),
                      ),
                      backgroundColor: Colors.deepOrange,
                      onPressed: (() async {
                        if (_formKey.currentState!.validate()) {
                          final String email = _emailController.text.trim();
                          final String senha = _passwordController.text;

                          // Verificar a autenticação
                          bool isAuthenticated =
                              await _authService.signIn(email, senha);

                          if (isAuthenticated) {
                            // Se autenticado com sucesso, redirecione para a página do perfil
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          } else {
                            // Se a autenticação falhar, exiba uma mensagem de erro
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Erro"),
                                  content: const Text("Falha no Login"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }),
                    ),
                  ),
                  const Text(
                    'Não possuí cadastro?',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                    child: FloatingActionButton.extended(
                      label: const Text(
                        "Crie uma conta",
                        style: TextStyle(fontSize: 20),
                      ),
                      backgroundColor: Colors.green,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const RegistrationScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
