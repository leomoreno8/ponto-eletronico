import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dao/ponto_dao.dart';
import '../model/ponto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HistoricoPage extends StatefulWidget {
  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  static const ACAO_VISUALIZAR = 'visualizar';
  List<Ponto> _pontos = [];
  // final _pontos = <Ponto>[];
  final _dao = PontoDao();

   @override
   void initState(){
     super.initState();
    //  carregarRegistros();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico'),
      ),
      body: FutureBuilder<List<Ponto>>(
        future: _carregarRegistros(),
        builder: (BuildContext context, AsyncSnapshot<List<Ponto>> snapshot) {
          if (snapshot.hasData) {
            final pontos = snapshot.data;
            return ListView.separated(
              itemCount: pontos?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final ponto = pontos![index];
                return ListTile(
                  title: Text('${ponto.id} / Logintude: ${ponto.longitude} / Latidude:  ${ponto.latitude} / Horario:  ${ponto.horario} '),
                  // onTap: openMaps(ponto.longitude, ponto.latitude)
                  trailing: IconButton(
                    onPressed: openMaps(ponto.longitude, ponto.latitude),
                    icon: Icon(Icons.map)),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }



  void _atualizarLista() async {
    final pontos = await _dao.listar();

    setState(() {
      _pontos.clear();
      if (pontos.isNotEmpty) {
        _pontos.addAll(pontos);
      }
    });

  }
  
  List<PopupMenuEntry<String>> criarItensMenuPopup(){
    return[
      PopupMenuItem<String>(
          value: ACAO_VISUALIZAR,
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Visualizar'),
              )
            ],
          )
      )
    ];
  }


  Future<List<Ponto>> _carregarRegistros() async {
    var databasePath = await getDatabasesPath();
    var database = await openDatabase('$databasePath/registros.db', version: 1);

    List<Map<String, dynamic>> pontos = await database.rawQuery('SELECT * FROM Registros');

    List<Ponto> _pontos = [];

    pontos.forEach((ponto) {
      _pontos.add(Ponto(
        id: ponto['id'],
        latitude: ponto['latitude'],
        longitude: ponto['longitude'],
        horario: DateTime.parse(ponto['horario']),
      ));
    });

    return _pontos;
  }

  openMaps(double lat, double lng) {
    MapsLauncher.launchCoordinates(lng, lat);
  }

}