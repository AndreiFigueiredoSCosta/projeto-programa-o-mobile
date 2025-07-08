import 'package:flutter/material.dart';
import 'package:projeto_mobile/models/Usuario.dart';
import 'package:projeto_mobile/pages/home/home_page.dart';
import 'package:projeto_mobile/service/auth_service.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final AuthService _authService = AuthService();

  bool _isLogin = true;
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confSenhaCtrl = TextEditingController();
  String? _error;

  Future<void> _tryLogin() async {
    final email = _emailCtrl.text.trim();
    final senha = _senhaCtrl.text;
    if (email.isEmpty || senha.isEmpty) {
      setState(() => _error = 'Preencha email e senha');
      return;
    }

    final ok = await _authService.login(email, senha);
    if (ok != true) {
      setState(() => _error = 'Email ou senha incorretos');
      return;
    }

    // busca os dados do usuário logado
    try {
      final usuario = await _authService.getUsuarioLogado();
      _goHome(usuario!);
    } catch (e) {
      setState(() => _error = 'Erro ao obter dados do usuário');
    }
  }

  Future<void> _tryRegister() async {
    final nome = _nomeCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final senha = _senhaCtrl.text;
    final conf = _confSenhaCtrl.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || conf.isEmpty) {
      setState(() => _error = 'Preencha todos os campos');
      return;
    }
    if (senha != conf) {
      setState(() => _error = 'Senhas não conferem');
      return;
    }

    final ok = await _authService.cadastrar(Usuario(nome: nome, email: email, senha: senha));
    if (ok != true) {
      setState(() => _error = 'Falha ao cadastrar usuário');
      return;
    }

    // após cadastro, já loga automaticamente
    final loginOk = await _authService.login(email, senha);
    if (loginOk != true) {
      setState(() => _error = 'Cadastro OK, mas falha ao logar');
      return;
    }

    try {
      final usuario = await _authService.getUsuarioLogado();
      _goHome(usuario!);
    } catch (e) {
      setState(() => _error = 'Erro ao obter dados do usuário');
    }
  }

  void _goHome(Usuario u) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home(usuario: u)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLogin ? 'Login' : 'Cadastro',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF700000),
        centerTitle: true,
      ),
      backgroundColor: Colors.black26,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [_isLogin, !_isLogin],
              onPressed: (i) => setState(() {
                _isLogin = i == 0;
                _error = null;
              }),
              borderRadius: BorderRadius.circular(8),
              fillColor: const Color(0xFF700000),
              selectedColor: Colors.white,
              color: Colors.white70,
              borderColor: Colors.white54,
              selectedBorderColor: Colors.white,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Login'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Cadastro'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (!_isLogin)
              TextField(
                controller: _nomeCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),

            TextField(
              controller: _emailCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            TextField(
              controller: _senhaCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.white),
              ),
              obscureText: true,
            ),

            if (!_isLogin)
              TextField(
                controller: _confSenhaCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Confirme a senha',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                obscureText: true,
              ),

            const SizedBox(height: 16),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLogin ? _tryLogin : _tryRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF700000),
                ),
                child: Text(
                  _isLogin ? 'Entrar' : 'Cadastrar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _confSenhaCtrl.dispose();
    super.dispose();
  }
}
