import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'comics',
      'XKCDatabaseNEO.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<GetLatestRow>> getLatest() => performGetLatest(
        _database,
      );

  Future<List<GetSameDayRow>> getSameDay({
    String? currentDate,
  }) =>
      performGetSameDay(
        _database,
        currentDate: currentDate,
      );

  Future<List<GetAllRow>> getAll() => performGetAll(
        _database,
      );

  Future<List<GetAFewRow>> getAFew({
    int? id1,
    int? id2,
    int? id3,
  }) =>
      performGetAFew(
        _database,
        id1: id1,
        id2: id2,
        id3: id3,
      );

  Future<List<GetByIDRow>> getByID({
    int? id,
  }) =>
      performGetByID(
        _database,
        id: id,
      );

  Future<List<GetAllAscRow>> getAllAsc() => performGetAllAsc(
        _database,
      );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  /// END UPDATE QUERY CALLS
}
