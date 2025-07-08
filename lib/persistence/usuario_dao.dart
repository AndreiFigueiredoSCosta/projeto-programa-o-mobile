import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/Usuario.dart';
import 'package:http/http.dart' as http;

import '../service/auth_service.dart';

class UsuarioDao{
  static const String baseUrl = 'http://localhost:8080';
  final _storage = FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception('Token não encontrado');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    print("tentou inserir");
    final response = await http.post(
      Uri.parse('$baseUrl/usuario/cadastrar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toMap()),

    );

    print("chegou aqui");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("inseriu");
      String token = jsonDecode(response.body)['token'];
      await _storage.write(key: 'jwt_token', value: token);
      return true;
    } else {
      throw Exception('Erro ao registrar usuário');
    }
  }

  Future<bool?> logarUsuario(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['token'];
      await _storage.write(key: 'jwt_token', value: token);
      return true;
    } else {
      return null;
    }
  }

  Future<Usuario> buscarUsuarioLogado() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/usuario'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      Usuario usuario = Usuario.fromMap(jsonDecode(response.body));
      return Usuario.fromMap(jsonDecode(response.body));
    }
    throw Exception('Erro ao buscar usuário logado: ${response.statusCode}');
  }
}

