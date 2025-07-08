import 'package:projeto_mobile/models/Treino.dart';
import 'package:projeto_mobile/persistence/treino_dao.dart';

class TreinoService{
  final TreinoDAO _dao = TreinoDAO();

  Future<int> adicionarTreino(Treino treino) async{
    return await _dao.criarTreino(treino);
  }

  Future<List<Treino>> listarTreinosDoUsuario(int idUsuario) async{
    return await _dao.listarTreinosDoUsuario(idUsuario);
  }

  Future<void> editarTreino(Treino treino) async{
    return await _dao.editarTreino(treino);
  }

  Future<void> deletarTreino(Treino treino) async{
    return await _dao.deletarTreino(treino);
  }
}
