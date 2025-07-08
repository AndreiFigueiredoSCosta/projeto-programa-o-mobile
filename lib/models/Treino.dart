import 'Exercicio.dart';

class Treino {
  final int? id;
  final String nome;
  final int? usuarioId;

  Treino({
    this.id,
    required this.nome,
    this.usuarioId
  });

  factory Treino.fromMap(Map<String, dynamic> map) {
    return Treino(
      id: map['id'],
      nome: map['nome'],
      usuarioId : map['usuarioId']
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome
    };
    return map;
  }
}
