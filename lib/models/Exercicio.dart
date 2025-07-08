class Exercicio {
  int? id;
  int? treinoId;
  String nome;
  int series;
  int repeticoesMin;
  int repeticoesMax;
  int descansoSegundos;

  Exercicio({
    this.id,
    this.treinoId,
    required this.nome,
    required this.series,
    required this.repeticoesMin,
    required this.repeticoesMax,
    required this.descansoSegundos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'series': series,
      'repeticoesMin': repeticoesMin,
      'repeticoesMax': repeticoesMax,
      'descanso': descansoSegundos,
    };
  }

  factory Exercicio.fromMap(Map<String, dynamic> map) {
    return Exercicio(
      id: map['id'],
      nome: map['nome'],
      series: map['series'],
      repeticoesMin: map['repeticoesMin'],
      repeticoesMax: map['repeticoesMax'],
      descansoSegundos: map['descanso'],
    );
  }
}
