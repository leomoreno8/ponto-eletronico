import 'package:flutter/material.dart';
import 'package:ponto_eletronico/pages/home.dart';
// import 'package:ponto_eletronico/pages/lista_tarefas_page.dart';

void main() {
  runApp(const PontoApp());
}

class PontoApp extends StatelessWidget {
  const PontoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        primaryColor: Colors.amber,
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
      // routes: {
      //   FiltroPage.routeName: (BuildContext context) => FiltroPage(),
      // },
    );
  }
}