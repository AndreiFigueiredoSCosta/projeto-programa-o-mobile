import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/models/Exercicio.dart';
import '../service/auth_service.dart';


class ExercicioDao{
  static const String baseUrl = 'http://localhost:8080';
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<int> criarExercicio(Exercicio exercicio) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/treino/${exercicio.treinoId}/exercicios/adicionar'),
      headers: headers,
      body: jsonEncode(exercicio.toMap()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Erro ao inserir treino');
    }
  }

  Future<List<Exercicio>> listarExerciciosDoTreino(int idTreino) async {
    final headers = await _getHeaders();
    final response = await http.get(
        Uri.parse('$baseUrl/treino/$idTreino/exercicios'),
        headers: headers
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Exercicio.fromMap(json)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Erro ao buscar exercicios do treino');
    }
  }

  Future<void> editarExercicio(Exercicio exercicio) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/exercicio/${exercicio.id}/editar'),
      headers: headers,
      body: jsonEncode(exercicio.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao editar exercicio');
    }
  }

  Future<void> deletarExercicio(Exercicio exercicio) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/exercicio/${exercicio.id}/deletar'),
      headers: headers,
      body: jsonEncode(exercicio.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar exercicio');
    }
  }
}
