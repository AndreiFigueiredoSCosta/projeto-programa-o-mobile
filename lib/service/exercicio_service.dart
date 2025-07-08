import 'package:projeto_mobile/persistence/exercicio_dao.dart';
import '../models/Exercicio.dart';

class ExercicioService{
  final ExercicioDao _dao = ExercicioDao();

  Future<int> adicionarExercicio(Exercicio exercicio) async{
    return await _dao.criarExercicio(exercicio);
  }

  Future<List<Exercicio>> listarExerciciosDoTreino(int idTreino) async{
    return await _dao.listarExerciciosDoTreino(idTreino);
  }

  Future<void> editarExercicio(Exercicio exercicio) async{
    return await _dao.editarExercicio(exercicio);
  }

  Future<void> deletarExercicio(Exercicio exercicio) async{
    return await _dao.deletarExercicio(exercicio);
  }
}
