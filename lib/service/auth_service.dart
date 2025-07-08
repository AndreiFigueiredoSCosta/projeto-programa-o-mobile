import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projeto_mobile/models/Usuario.dart';
import 'package:projeto_mobile/persistence/usuario_dao.dart';

class AuthService{
  final UsuarioDao _dao = UsuarioDao();
  final _storage = FlutterSecureStorage();

  Future<bool?> cadastrar(Usuario usuario) async {
    try {
      await _dao.cadastrarUsuario(usuario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool?> login(String email, String password) async {
    return await _dao.logarUsuario(email, password);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<Usuario?> getUsuarioLogado() async {
    try {
      return await _dao.buscarUsuarioLogado();
    } catch (e) {// <<<<<< DEBUG
      return null;
    }
  }

}
