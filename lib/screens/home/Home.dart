import 'package:flutter/material.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Treino.dart';
import 'package:trabalho_programacao_mobile_andrei/database/sqlite_controller.dart';
import 'package:trabalho_programacao_mobile_andrei/screens/telaTreino/TelaTreino.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SqliteController _sqliteController = SqliteController();
  final TextEditingController _treinoEditController = TextEditingController();
  List<Treino> treinos = [];

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }

  Future<void> _carregarTreinos() async {
    final lista = await _sqliteController.getTreinos();
    setState(() {
      treinos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus treinos", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF700000),
      ),
      backgroundColor: Colors.black26,
      body: treinos.isEmpty
          ? Center(
        child: Text("Nenhum treino cadastrado", style: TextStyle(color: Colors.white)),
      )
          : ListView.builder(
        itemCount: treinos.length,
        itemBuilder: (context, index) {
          final treino = treinos[index];
          return Padding(
            padding: EdgeInsets.only(top: 20),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical:5, horizontal: 20),
              child: InkWell(
                onTap: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TelaTreino(treino: treino),
                    ),
                  );

                  if (resultado == true) {
                    _carregarTreinos();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF700000),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(
                    treino.nome,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPopup,
        heroTag: "adicionarTreino",
        backgroundColor: const Color(0xFF700000),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF330000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Novo Treino',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: TextField(
          controller: _treinoEditController,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF700000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              String nomeTreino = _treinoEditController.text.trim();
              if (nomeTreino.isNotEmpty) {
                Treino novoTreino = Treino(nome: nomeTreino);
                await _sqliteController.insertTreino(novoTreino);
                await _carregarTreinos(); // atualiza a lista
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ).then((_) {
      _treinoEditController.clear();
    });
  }
}
