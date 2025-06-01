import 'Exercicio.dart';

class Treino {
  final int? id;
  final String nome;
  List<Exercicio>? exercicios; // <- Adiciona a lista

  Treino({this.id, required this.nome, this.exercicios});

  factory Treino.fromMap(Map<String, dynamic> map) {
    return Treino(
      id: map['id'],
      nome: map['nome'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
