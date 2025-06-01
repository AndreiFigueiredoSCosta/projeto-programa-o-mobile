import 'package:flutter/material.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Exercicio.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Treino.dart';
import 'package:trabalho_programacao_mobile_andrei/screens/telaTreino/CardExercicio.dart';
import '../../database/sqlite_controller.dart';

class TelaTreino extends StatefulWidget {
  const TelaTreino({super.key, required this.treino});
  final Treino treino;

  @override
  State<TelaTreino> createState() => _TelaTreinoState();
}

class _TelaTreinoState extends State<TelaTreino> {
  final SqliteController _sqliteController = SqliteController();
  final TextEditingController _treinoEditController = TextEditingController();

  List<Exercicio> exercicios = [];
  late Treino _treinoAtual;

  @override
  void initState() {
    super.initState();
    _treinoAtual = widget.treino;
    _carregarExercicios();
  }

  void _carregarExercicios() async {
    if (_treinoAtual.id != null) {
      final lista = await _sqliteController.getExerciciosByTreino(_treinoAtual.id!);
      setState(() {
        exercicios = lista;
      });
    }
  }

  void _adicionarExercicio() {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController seriesController = TextEditingController();
    final TextEditingController repeticoesMinController = TextEditingController();
    final TextEditingController repeticoesMaxController = TextEditingController();
    final TextEditingController descansoController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF330000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Novo Exercicio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: seriesController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Séries",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: repeticoesMinController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Repetições mínimas",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: repeticoesMaxController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Repetições máximas",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: descansoController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Descanso (segundos)",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
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
              final nome = nomeController.text.trim();
              final series = int.tryParse(seriesController.text.trim()) ?? 0;
              final repMin = int.tryParse(repeticoesMinController.text.trim()) ?? 0;
              final repMax = int.tryParse(repeticoesMaxController.text.trim()) ?? 0;
              final descanso = int.tryParse(descansoController.text.trim()) ?? 0;

              if (nome.isNotEmpty && _treinoAtual.id != null) {
                final novoExercicio = Exercicio(
                  treinoId: _treinoAtual.id!,
                  nome: nome,
                  series: series,
                  repeticoesMin: repMin,
                  repeticoesMax: repMax,
                  descansoSegundos: descanso,
                );

                await _sqliteController.insertExercicio(novoExercicio);
                _carregarExercicios();
              }

              Navigator.of(dialogContext).pop();
            },
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deletarTreino() async {
    final id = _treinoAtual.id;
    if (id != null) {
      await _sqliteController.deleteTreino(id);
    }
  }

  void _editarTreino() {
    _treinoEditController.text = _treinoAtual.nome;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF330000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Alterar nome',
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
              if (nomeTreino.isNotEmpty && _treinoAtual.id != null) {
                Treino treinoAtualizado = Treino(
                  id: _treinoAtual.id,
                  nome: nomeTreino,
                );
                await _sqliteController.updateTreino(treinoAtualizado);
                setState(() {
                  _treinoAtual = treinoAtualizado;
                });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _treinoAtual.nome,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF700000),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      backgroundColor: Colors.black26,
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color(0xFF700000),
                    heroTag: "iniciarTreino",
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                  ),
                  FloatingActionButton(
                    onPressed: _adicionarExercicio,
                    backgroundColor: const Color(0xFF700000),
                    heroTag: "adicionarExercicio",
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 50),
                  FloatingActionButton(
                    onPressed: _editarTreino,
                    backgroundColor: const Color(0xFF700000),
                    heroTag: "editarTreino",
                    child: const Icon(Icons.edit, color: Colors.white, size: 24),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _deletarTreino();
                      Navigator.pop(context, true);
                    },
                    backgroundColor: const Color(0xFF700000),
                    heroTag: "deletarTreino",
                    child: const Icon(Icons.delete, color: Colors.white, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: (exercicios.isEmpty)
                    ? const Center(
                  child: Text(
                    "Nenhum exercício adicionado!",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  itemCount: exercicios.length,
                  itemBuilder: (context, index) {
                    final exercicio = exercicios[index];
                    return CardExercicio(exercicio: exercicio);
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
