// lib/components/card_exercicio.dart
import 'package:flutter/material.dart';
import 'package:projeto_mobile/models/Exercicio.dart';
import 'package:projeto_mobile/persistence/exercicio_dao.dart';
import 'package:projeto_mobile/service/exercicio_service.dart';
class CardExercicio extends StatelessWidget {
  final Exercicio exercicio;
  final VoidCallback onRefresh; // callback para recarregar lista

  const CardExercicio({
    Key? key,
    required this.exercicio,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExercicioService _exercicioService = ExercicioService();

    void _editarExercicio() {
      final nomeCtrl = TextEditingController(text: exercicio.nome);
      final seriesCtrl = TextEditingController(text: exercicio.series.toString());
      final repMinCtrl = TextEditingController(text: exercicio.repeticoesMin.toString());
      final repMaxCtrl = TextEditingController(text: exercicio.repeticoesMax.toString());
      final descansoCtrl = TextEditingController(text: exercicio.descansoSegundos.toString());

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF330000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Editar Exercício',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nomeCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: seriesCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Séries",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: repMinCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Repetições mínimas",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: repMaxCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Repetições máximas",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: descansoCtrl,
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
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF700000),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final nome = nomeCtrl.text.trim();
                final series = int.tryParse(seriesCtrl.text.trim()) ?? 0;
                final repMin = int.tryParse(repMinCtrl.text.trim()) ?? 0;
                final repMax = int.tryParse(repMaxCtrl.text.trim()) ?? 0;
                final descanso = int.tryParse(descansoCtrl.text.trim()) ?? 0;

                if (nome.isNotEmpty && exercicio.id != null) {
                  final atualizado = Exercicio(
                    id: exercicio.id,
                    treinoId: exercicio.treinoId,
                    nome: nome,
                    series: series,
                    repeticoesMin: repMin,
                    repeticoesMax: repMax,
                    descansoSegundos: descanso,
                  );
                  await _exercicioService.editarExercicio(atualizado);
                  onRefresh(); // recarrega a lista na tela-pai
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    Future<void> _deletarExercicio() async {
      await _exercicioService.deletarExercicio(exercicio);
      onRefresh();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF700000),
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(exercicio.nome),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${exercicio.series} séries"),
                Text("${exercicio.repeticoesMin}–${exercicio.repeticoesMax} reps"),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: _editarExercicio,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _deletarExercicio,
            ),
          ],
        ),
      ),
    );
  }
}
