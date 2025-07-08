import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_mobile/models/Historico.dart';
import 'package:projeto_mobile/models/Treino.dart';
import 'package:projeto_mobile/persistence/historico_dao.dart';

class HistoricoPage extends StatefulWidget {
  final Treino treino;
  const HistoricoPage({super.key, required this.treino});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final HistoricoDao _historicoDao = HistoricoDao();
  List<Historico> historico = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    if (widget.treino.id != null) {
      print(widget.treino.id!);
      final lista = await _historicoDao.listarHistoricoDoTreino(widget.treino.id!);
      setState(() => historico = lista);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text(
          "Histórico",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF700000),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: historico.isEmpty
              ? const Center(
            child: Text(
              "Você não concluiu esse treino nenhuma vez!",
              style: TextStyle(color: Colors.white),
            ),
          )
              : ListView.builder(
            itemCount: historico.length,
            itemBuilder: (ctx, i) {
              final dataFormatada = DateFormat('dd/MM/yyyy').format(DateTime.parse(historico[i].data));
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF700000),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  dataFormatada,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
