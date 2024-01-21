import 'package:flutter/material.dart';
import 'package:receiteme_project/screens/inicial/tela_login.dart';
import 'package:receiteme_project/helpers/user_database.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _senhaOculta = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService =
      AuthService(); // Instância do seu AuthService
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Definição do GlobalKey

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
                      'Registrar',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                      bottom: 1,
                    ),
                    child: Text(
                      'Nome',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: "Digite seu nome completo",
                        labelStyle: TextStyle(color: Colors.black)),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 15),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu nome';
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                      bottom: 1,
                    ),
                    //email label
                    child: Text(
                      'Email',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
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
                      top: 30,
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
                    obscureText: !_senhaOculta, //ocultar a senha
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua senha';
                      }
                      return null;
                    },
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
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                    child: FloatingActionButton.extended(
                      label: const Text(
                        "Registrar",
                        style: TextStyle(fontSize: 20),
                      ),
                      backgroundColor: Colors.deepOrange,
                      onPressed: (() async {
                        final String namecadastro = _nameController.text.trim();
                        final String emailcadastro =
                            _emailController.text.trim();
                        final String senhacadastro = _passwordController.text;

                        if (_formKey.currentState!.validate()) {
                          // Realiza o registro utilizando o método signUp do AuthService
                          final bool isRegistered = await _authService.signUp(
                              namecadastro, emailcadastro, senhacadastro);

                          if (isRegistered) {
                            // Registro bem-sucedido, redireciona para outra tela
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          } else {
                            // Tratamento caso o registro falhe
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Erro"),
                                    content: const Text("Falha no registro"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      }),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                  const Text(
                    'Já possuí uma conta?',
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
                        "Entre aqui",
                        style: TextStyle(fontSize: 20),
                      ),
                      backgroundColor: Colors.green,
                      onPressed: (() {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      }),
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
