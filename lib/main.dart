import 'package:flutter/material.dart';
import 'package:trabalho_programacao_mobile_andrei/screens/telaLogin/LoginRegisterScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treino App',
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginRegisterScreen(),
        // outras rotas se necessário
      },
    );
  }
}
