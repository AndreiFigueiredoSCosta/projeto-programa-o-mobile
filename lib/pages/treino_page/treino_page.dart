import 'package:flutter/material.dart';
import 'package:projeto_mobile/models/Exercicio.dart';
import 'package:projeto_mobile/models/Treino.dart';
import 'package:projeto_mobile/pages/historico/historico_page.dart';
import 'package:projeto_mobile/pages/treino_page/card_exercicio.dart';
import 'package:projeto_mobile/service/exercicio_service.dart';
import 'package:projeto_mobile/service/historico_service.dart';
import 'package:projeto_mobile/service/treino_service.dart';

class TreinoPage extends StatefulWidget {
  final Treino treino;
  const TreinoPage({super.key, required this.treino});

  @override
  State<TreinoPage> createState() => _TreinoPageState();
}

class _TreinoPageState extends State<TreinoPage> {
  final TreinoService _treinoService = TreinoService();
  final HistoricoService _historicoService = HistoricoService();
  final ExercicioService _exercicioService = ExercicioService();
  final TextEditingController _treinoEditController = TextEditingController();

  late String _nomeAtual;
  List<Exercicio> exercicios = [];

  @override
  void initState() {
    super.initState();
    _nomeAtual = widget.treino.nome;
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    final lista = await _exercicioService.listarExerciciosDoTreino(widget.treino.id!);
    setState(() {
      exercicios = lista;
    });
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
              await _historicoService.marcarComoFeito(widget.treino.id!);
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
        builder: (_) => HistoricoPage(treino: widget.treino),
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

              if (nome.isNotEmpty) {
                final novoExercicio = Exercicio(
                  treinoId: widget.treino.id!,
                  nome: nome,
                  series: series,
                  repeticoesMin: repMin,
                  repeticoesMax: repMax,
                  descansoSegundos: descanso,
                );
                await _exercicioService.adicionarExercicio(novoExercicio);
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
    _treinoEditController.text = _nomeAtual;
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
              final novoNome = _treinoEditController.text.trim();
              if (novoNome.isNotEmpty) {
                final atualizado = Treino(
                  id: widget.treino.id,
                  nome: novoNome,
                  usuarioId: widget.treino.usuarioId,
                );
                await _treinoService.editarTreino(atualizado);
                setState(() {
                  _nomeAtual = novoNome;
                });
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
    await _treinoService.deletarTreino(widget.treino);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_nomeAtual, style: const TextStyle(color: Colors.white)),
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
                  child: Text(
                    "Nenhum exercício adicionado!",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: exercicios.length,
                  itemBuilder: (ctx, i) => CardExercicio(
                    key: ValueKey(exercicios[i].id),
                    exercicio: exercicios[i],
                    onRefresh: _carregarExercicios,
                  ),
                ),
              ),
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
