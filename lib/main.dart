import 'package:flutter/material.dart';
import 'package:trabalho_programacao_mobile_andrei/database/sqlite_controller.dart';
import 'package:trabalho_programacao_mobile_andrei/screens/home/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbController = SqliteController();
  await dbController.initDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treinos',
      theme: ThemeData(
        primaryColor: const Color(0xFF700000),
      ),
      home: const Home(),
    );
  }
}
