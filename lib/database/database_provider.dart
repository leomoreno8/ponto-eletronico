import 'package:flutter/cupertino.dart';
import 'package:ponto_eletronico/model/ponto.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'cadastro_ponto_teste.db';
  static const _dbVersion = 2;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE ${Ponto.nomeTabela} (
        ${Ponto.campoId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Ponto.campoLongitude} TEXT NOT NULL,
        ${Ponto.campoLatitude} TEXT NOT NULL,
        ${Ponto.campoHorario} TIMESTAMP NOT NULL;
    ''');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
