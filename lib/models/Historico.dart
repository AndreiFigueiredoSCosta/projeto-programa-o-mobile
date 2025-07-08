class Historico {
  final int? id;
  final int? treinoId;
  final String data;

  Historico({
    this.id,
    this.treinoId,
    required this.data,
  });

  factory Historico.fromMap(Map<String, dynamic> map) {
    return Historico(
      id: map['id'] as int?,
      data: map['data'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'data': data,
    };
  }
}
