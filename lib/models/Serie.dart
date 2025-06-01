class Serie {
  int? id;
  int exercicioId;
  int numeroSerie;
  double carga;
  int repeticoes;
  DateTime data;

  Serie({
    this.id,
    required this.exercicioId,
    required this.numeroSerie,
    required this.carga,
    required this.repeticoes,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercicio_id': exercicioId,
      'numero_serie': numeroSerie,
      'carga': carga,
      'repeticoes': repeticoes,
      'data': data.toIso8601String(),
    };
  }

  factory Serie.fromMap(Map<String, dynamic> map) {
    return Serie(
      id: map['id'],
      exercicioId: map['exercicio_id'],
      numeroSerie: map['numero_serie'],
      carga: map['carga'],
      repeticoes: map['repeticoes'],
      data: DateTime.parse(map['data']),
    );
  }
}
