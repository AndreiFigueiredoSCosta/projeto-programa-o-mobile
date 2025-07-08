import 'package:flutter/material.dart';
import 'package:projeto_mobile/models/Treino.dart';
import 'package:projeto_mobile/models/Usuario.dart';
import 'package:projeto_mobile/pages/treino_page/treino_page.dart';
import 'package:projeto_mobile/service/auth_service.dart';
import 'package:projeto_mobile/service/treino_service.dart';

class Home extends StatefulWidget {
  final Usuario usuario;
  const Home({super.key, required this.usuario});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _treinoEditController = TextEditingController();
  final TreinoService _treinoService = TreinoService();
  final AuthService _authService = AuthService();
  List<Treino> treinos = [];

  @override
  void initState() {
    super.initState();
    _loadTreinos();
  }

  Future<void> _loadTreinos() async {
    final list = await _treinoService.listarTreinosDoUsuario(widget.usuario.id!);
    setState(() {
      treinos = list;
    });
  }

  Future<void> _addTreino() async {
    _treinoEditController.clear();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF330000),
        title: const Text(
            'Novo Treino',
            style: TextStyle( color: Colors.white),
        ),
        content: TextField(
          controller: _treinoEditController,
          decoration: InputDecoration(
              labelText: 'Nome do treino',
              labelStyle: TextStyle(color: Colors.white)
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(onPressed: () =>
              Navigator.pop(ctx),
              child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
              )
          ),
          ElevatedButton(
            onPressed: () async {
              final nome = _treinoEditController.text.trim();
              if (nome.isNotEmpty) {
                await _treinoService.adicionarTreino(
                  Treino(
                      nome: nome,
                      usuarioId: widget.usuario.id!),
                );
                await _loadTreinos();
              }
              Navigator.pop(ctx);
            },
            child: const Text(
                'Criar',
                style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF700000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    _authService.logout();
    Navigator.pushReplacementNamed(context, '/login_register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Treinos de ${widget.usuario.nome}',
            style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF700000),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.black26,
      body: treinos.isEmpty
          ? const Center(
        child: Text(
          "Nenhum treino cadastrado",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: treinos.length,
        itemBuilder: (ctx, i) {
          final t = treinos[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: InkWell(
              onTap: () async {
                final changed = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TreinoPage(treino: t)),
                );
                if (changed == true) _loadTreinos();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF700000),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  t.nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTreino,
        heroTag: "adicionarTreino",
        backgroundColor: const Color(0xFF700000),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
