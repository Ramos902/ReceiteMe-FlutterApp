import 'package:flutter/material.dart';
import 'package:receiteme_project/screens/content/home.dart';
import 'screens/inicial/tela_inicial.dart';
import 'screens/inicial/tela_login.dart';
import 'screens/inicial/tela_registro.dart';
import 'screens/receita/recipe.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: "/inicial/tela_inicial",
      routes: {
        "/inicial/tela_inicial": (context) => const Inicial(),
        "/inicial/tela_login": (context) => const Login(),
        "/inicial/tela_registro": (context) => const RegistrationScreen(),
        "/content/HomePage": (context) => const HomePage(),
        "/receita/recipe.dart": (context) => TelaCriarReceita(),
      },
    );
  }
}
