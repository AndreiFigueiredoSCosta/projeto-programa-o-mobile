import 'package:flutter/material.dart';
import 'package:trabalho_programacao_mobile_andrei/models/Exercicio.dart';

class CardExercicio extends StatefulWidget {
  final Exercicio exercicio;

  const CardExercicio({
    super.key,
    required this.exercicio
  });

  @override
  State<CardExercicio> createState() => _CardTreinoState();
}

class _CardTreinoState extends State<CardExercicio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFF700000),
        border: Border.all(
          color: Colors.white,
          width: 2
        )
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
          fontSize: 20
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.expand_more,
              color: Colors.white,
              size: 25
            ),
            Text(widget.exercicio.nome),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("${widget.exercicio.series} séries"),
                Text("${widget.exercicio.repeticoesMin} - ${widget.exercicio.repeticoesMax}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
