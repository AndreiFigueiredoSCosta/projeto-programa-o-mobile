import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/models/Historico.dart';
import '../service/auth_service.dart';


class HistoricoDao{
  static const String baseUrl = 'http://localhost:8080';
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> marcarComoFeito(int treinoId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/treino/${treinoId}/historico/marcar'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("sem problema");
    } else {
      throw Exception('Erro ao marcar treino como feito');
    }
  }

  Future<List<Historico>> listarHistoricoDoTreino(int treinoId) async {
    final headers = await _getHeaders();
    final response = await http.get(
        Uri.parse('$baseUrl/treino/${treinoId}/historico'),
        headers: headers
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Historico.fromMap(json)).toList();
    } else {
      throw Exception('Erro ao buscar treinos do usuario');
    }
  }
}
