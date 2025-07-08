class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String? senha;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    this.senha,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email']
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'email': email,
      'senha': senha,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
