class HistoricoTreino {
  final int? id;
  final int treinoId;
  final String data;

  HistoricoTreino({
    this.id,
    required this.treinoId,
    required this.data,
  });

  factory HistoricoTreino.fromMap(Map<String, dynamic> map) {
    return HistoricoTreino(
      id: map['id'] as int?,
      treinoId: map['treino_id'] as int,
      data: map['data'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'treino_id': treinoId,
      'data': data,
    };
  }
}
