import 'package:flutter/material.dart';
import 'package:projeto_mobile/pages/login_register/login_register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treino App',
      initialRoute: '/login_register',
      routes: {
        '/login_register': (_) => const LoginRegisterScreen(),
        // outras rotas se necessário
      },
    );
  }
}
