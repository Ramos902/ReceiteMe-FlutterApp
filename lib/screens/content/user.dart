import 'package:flutter/material.dart';
import 'package:receiteme_project/helpers/user_database.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthService _authService = AuthService();
  late Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? loggedInUserEmail = AuthService.getLoggedInUserEmail();
    if (loggedInUserEmail != null) {
      try {
        Map<String, dynamic> userData = await _authService.getUserData(loggedInUserEmail);
        setState(() {
          _userData = userData;
        });
      } catch (e) {
        print('Erro ao carregar dados do usuário: $e');
        // Lidar com o erro conforme necessário
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuário'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome: ${_userData['name'] ?? _userData['name']}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: ${_userData['email'] ?? 'Email não encontrado'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              // Adicione mais informações aqui, se necessário
            ],
          ),
        ),
      ),
    );
  }
}
