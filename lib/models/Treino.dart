import 'Exercicio.dart';

class Treino {
  final int? id;
  final String nome;
  final int usuarioId;
  List<Exercicio>? exercicios;

  Treino({
    this.id,
    required this.nome,
    required this.usuarioId,
    this.exercicios,
  });

  factory Treino.fromMap(Map<String, dynamic> map) {
    return Treino(
      id: map['id'],
      nome: map['nome'],
      usuarioId: map['usuario_id'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'usuario_id': usuarioId,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
