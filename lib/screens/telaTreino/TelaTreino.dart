import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Exercicio.dart';
import 'package:trabalho_programacao_mobile_andrei/models/HistoricoTreino.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Treino.dart';
import 'package:trabalho_programacao_mobile_andrei/screens/telaHistoricoTreino/telaHistoricoTreino.dart';
import 'package:trabalho_programacao_mobile_andrei/screens/telaTreino/CardExercicio.dart';
import 'package:trabalho_programacao_mobile_andrei/database/sqlite_controller.dart';

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

  Future<void> _carregarExercicios() async {
    if (_treinoAtual.id != null) {
      final lista = await _sqliteController.getExerciciosByTreino(_treinoAtual.id!);
      setState(() => exercicios = lista);
    }
  }

  void _marcarComoFeito() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF330000),
        title: const Text(
          'Marcar como feito',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Deseja marcar esse treino como feito hoje?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_treinoAtual.id != null) {
                final historico = HistoricoTreino(
                  treinoId: _treinoAtual.id!,
                  data: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                );
                await _sqliteController.insertHistoricoTreino(historico);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF700000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _abrirHistorico() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaHistoricoTreino(treino: _treinoAtual),
      ),
    );
  }

  void _adicionarExercicio() {
    final nomeController = TextEditingController();
    final seriesController = TextEditingController();
    final repeticoesMinController = TextEditingController();
    final repeticoesMaxController = TextEditingController();
    final descansoController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF330000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Novo Exercício',
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
            onPressed: () => Navigator.of(dialogContext).pop(),
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
                await _carregarExercicios();
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editarTreino() {
    _treinoEditController.text = _treinoAtual.nome;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF330000),
        title: const Text('Alterar nome', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _treinoEditController,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              final nome = _treinoEditController.text.trim();
              if (nome.isNotEmpty && _treinoAtual.id != null) {
                final atualizado = Treino(
                  id: _treinoAtual.id,
                  nome: nome,
                  usuarioId: _treinoAtual.usuarioId,
                );
                await _sqliteController.updateTreino(atualizado);
                setState(() => _treinoAtual = atualizado);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF700000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    ).then((_) => _treinoEditController.clear());
  }

  void _deletarTreino() async {
    if (_treinoAtual.id != null) {
      await _sqliteController.deleteTreino(_treinoAtual.id!);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_treinoAtual.nome, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF700000),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
          color: Colors.white,
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
                    onPressed: _marcarComoFeito,
                    heroTag: "marcarComoFeito",
                    child: const Icon(Icons.check, color: Colors.white),
                    backgroundColor: const Color(0xFF700000),
                  ),
                  FloatingActionButton(
                    onPressed: _abrirHistorico,
                    heroTag: "historicoDosTreinos",
                    child: const Icon(Icons.hourglass_bottom, color: Colors.white),
                    backgroundColor: const Color(0xFF700000),
                  ),
                  FloatingActionButton(
                    onPressed: _adicionarExercicio,
                    heroTag: "adicionarExercicio",
                    child: const Icon(Icons.add, color: Colors.white),
                    backgroundColor: const Color(0xFF700000),
                  ),
                  FloatingActionButton(
                    onPressed: _editarTreino,
                    heroTag: "editarTreino",
                    child: const Icon(Icons.edit, color: Colors.white),
                    backgroundColor: const Color(0xFF700000),
                  ),
                  FloatingActionButton(
                    onPressed: _deletarTreino,
                    heroTag: "deletarTreino",
                    child: const Icon(Icons.delete, color: Colors.white),
                    backgroundColor: const Color(0xFF700000),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: exercicios.isEmpty
                    ? const Center(
                  child: Text("Nenhum exercício adicionado!", style: TextStyle(color: Colors.white)),
                )
                    : ListView.builder(
                  itemCount: exercicios.length,
                  itemBuilder: (ctx, i) => CardExercicio(
                    key: ValueKey(exercicios[i].id),
                    exercicio: exercicios[i],
                    onRefresh: _carregarExercicios,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _treinoEditController.dispose();
    super.dispose();
  }
}
