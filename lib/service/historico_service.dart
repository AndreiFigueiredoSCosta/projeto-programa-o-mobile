import 'dart:async';

import '../models/Historico.dart';
import '../persistence/historico_dao.dart';

class HistoricoService{
  final HistoricoDao _dao = HistoricoDao();

  Future<void> marcarComoFeito(int idTreino) async {
     await _dao.marcarComoFeito(idTreino);
  }

  Future<List<Historico>> listarHistoricoDoTreino(int idTreino) async{
    return await _dao.listarHistoricoDoTreino(idTreino);
  }
}
