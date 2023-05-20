import 'package:ponto_eletronico/database/database_provider.dart';
import 'package:ponto_eletronico/model/ponto.dart';
import 'package:sqflite/sqflite.dart';

class PontoDao{

  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Ponto ponto) async {
    final database = await dbProvider.database;
    final valores = ponto.toMap();
    if (ponto.id == null) {
      ponto.id = await database.insert(Ponto.nomeTabela, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        Ponto.nomeTabela,
        valores,
        where: '${Ponto.campoId} = ?',
        whereArgs: [ponto.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final database = await dbProvider.database;
    final registrosAtualizados = await database.delete(
      Ponto.nomeTabela,
      where: '${Ponto.campoId} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  Future<List<Ponto>> listar(
  {String filtro = '',
  String campoOrdenacao = Ponto.campoId,
    bool usarOrdemDecrescente = false
  }) async {
    String? where;
    if(filtro.isNotEmpty){
      where = "UPPER(${Ponto.campoLatitude}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;

    if(usarOrdemDecrescente){
      orderBy += ' DESC';
    }
    final database = await dbProvider.database;
    final resultado = await database.query(Ponto.nomeTabela,
      columns: [Ponto.campoId, Ponto.campoLongitude, Ponto.campoLatitude, Ponto.campoHorario],
    where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => Ponto.fromMap(m)).toList();
  }

}