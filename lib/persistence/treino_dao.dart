import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/models/Treino.dart';
import '../service/auth_service.dart';

class TreinoDAO{
  static const String baseUrl = 'http://localhost:8080';
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<int> criarTreino(Treino treino) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/usuario/${treino.usuarioId}/treinos/adicionar'),
      headers: headers,
      body: jsonEncode(treino.toMap()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Erro ao inserir treino');
    }
  }

  Future<List<Treino>> listarTreinosDoUsuario(int idUsuario) async {
    final headers = await _getHeaders();
    final response = await http.get(
        Uri.parse('$baseUrl/usuario/$idUsuario/treinos'),
        headers: headers
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Treino.fromMap(json)).toList();
    } else {
      throw Exception('Erro ao buscar treinos do usuario');
    }
  }

  Future<void> editarTreino(Treino treino) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/treino/${treino.id}/editar'),
      headers: headers,
      body: jsonEncode(treino.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao editar treino');
    }
  }

  Future<void> deletarTreino(Treino treino) async {
    print("tentou deletar");
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/treino/${treino.id}/deletar'),
      headers: headers,
      body: jsonEncode(treino.toMap()),
    );

    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar treino');
    }
  }
}
