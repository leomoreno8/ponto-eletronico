import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:location/location.dart';
import 'package:ponto_eletronico/model/ponto.dart';
import 'package:sqflite/sqflite.dart';
import '../dao/ponto_dao.dart';
import 'package:ponto_eletronico/pages/historico.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../dao/tarefa_dao.dart';
// import '../model/tarefa.dart';
// import '../widgets/conteudo_form_dialog.dart';
// import 'datalhes_tarefa_page.dart';

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  final _dao = PontoDao();


@override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _abrirForm,
      //   tooltip: 'Nova Tarefa',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      title: Text('Ponto Eletrônico'),
      actions: [
        // IconButton(
        //     // onPressed: _abrirPaginaFiltro,
        //     icon: Icon(Icons.filter_list)),
      ],
    );
  }

  Widget _criarBody(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Horário atual:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 1)),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text(
                '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                style: TextStyle(fontSize: 50),
              );
            },
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  registrarPonto();
                },
                child: Text('Registrar Ponto'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoricoPage()),
                );
                },
                child: Text('Histórico'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> registrarPonto() async {
    // Verifica se temos permissão para acessar a localização
    var status = await ph.Permission.location.request();
    if (status != ph.PermissionStatus.granted) {
      throw Exception('Permissão para acesso à localização negada');
    }

    // Obtém a localização atual do dispositivo
    var locationData = await Location().getLocation();
    List ponto = [
      locationData.latitude,
      locationData.longitude,
      DateTime.now().toString(),
    ];
    
    _dao.salvar(ponto as Ponto);
    // Salva a localização e a hora em que o ponto foi registrado no banco de dados
    var databasePath = await getDatabasesPath();
    var database = await openDatabase(
        '$databasePath/registros.db', version: 1,
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE Registros (id INTEGER PRIMARY KEY, latitude REAL, longitude REAL, horario TEXT)');
    });

    await database.insert('Registros', {
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'horario': DateTime.now().toString(),
    });
  }

  // void _abrirForm({Ponto? ponto}) {
  //   final key = GlobalKey<ConteudoDialogFormState>();
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text(
  //         ponto == null ? 'Nova Tarefa' : 'Alterar Tarefa ${ponto.id}',
  //       ),
  //       content: ConteudoDialogForm(
  //         key: key,
  //         tarefa: ponto,
  //       ),
  //       actions: [
  //         TextButton(
  //           child: Text('Cancelar'),
  //           onPressed: () => Navigator.pop(context),
  //         ),
  //         TextButton(
  //           child: Text('Salvar'),
  //           onPressed: () {
  //             if (key.currentState?.dadosValidos() != true) {
  //               return;
  //             }
  //             Navigator.of(context).pop();
  //             final novaTarefa = key.currentState!.novoPonto;
  //             _dao.salvar(novaTarefa).then((success) {
  //               if (success) {
  //                 _atualizarLista();
  //               }
  //             });
  //             _atualizarLista();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

}