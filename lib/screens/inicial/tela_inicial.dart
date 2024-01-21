import 'package:flutter/material.dart';
import 'package:receiteme_project/screens/inicial/tela_login.dart';
import 'package:receiteme_project/screens/inicial/tela_registro.dart';

class Inicial extends StatefulWidget {
  const Inicial({super.key});

  @override
  State<Inicial> createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'OpenSans'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 150, 0, 25),
                child: const Image(
                  image: AssetImage('images/icon.png'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 200),
                child: const Text(
                  'Explore sabores em ReceiteMe: Peça e nós entregamos na palma da sua mão',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                width: 250,
                height: 50,
                child: FloatingActionButton.extended(
                  label: const Text('Entrar'), // <-- Text
                  backgroundColor: Colors.green,
                  icon: const Icon(
                    Icons.account_circle,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                width: 250,
                height: 50,
                child: FloatingActionButton.extended(
                  label: const Text('Registrar'), // <-- Text
                  backgroundColor: Colors.green,
                  icon: const Icon(
                    Icons.add_circle,
                    size: 25.0,
                  ),
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
    );
  }
}
