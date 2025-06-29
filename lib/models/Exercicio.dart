class Exercicio {
  int? id;
  int treinoId;
  String nome;
  int series;
  int repeticoesMin;
  int repeticoesMax;
  int descansoSegundos;

  Exercicio({
    this.id,
    required this.treinoId,
    required this.nome,
    required this.series,
    required this.repeticoesMin,
    required this.repeticoesMax,
    required this.descansoSegundos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'treino_id': treinoId,
      'nome': nome,
      'series': series,
      'repeticoes_min': repeticoesMin,
      'repeticoes_max': repeticoesMax,
      'descanso_segundos': descansoSegundos,
    };
  }

  factory Exercicio.fromMap(Map<String, dynamic> map) {
    return Exercicio(
      id: map['id'],
      treinoId: map['treino_id'],
      nome: map['nome'],
      series: map['series'],
      repeticoesMin: map['repeticoes_min'],
      repeticoesMax: map['repeticoes_max'],
      descansoSegundos: map['descanso_segundos'],
    );
  }
}
