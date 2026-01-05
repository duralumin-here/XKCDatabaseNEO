import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN GETLATEST
Future<List<GetLatestRow>> performGetLatest(
  Database database,
) {
  final query = '''
SELECT *
FROM Comics
ORDER BY ComicID DESC
LIMIT 1;
''';
  return _readQuery(database, query, (d) => GetLatestRow(d));
}

class GetLatestRow extends SqliteRow {
  GetLatestRow(Map<String, dynamic> data) : super(data);

  int? get comicID => data['ComicID'] as int?;
  String? get title => data['Title'] as String?;
  String? get date => data['Date'] as String?;
  String? get imgLink => data['ImgLink'] as String?;
  String? get altText => data['AltText'] as String?;
}

/// END GETLATEST

/// BEGIN GETSAMEDAY
Future<List<GetSameDayRow>> performGetSameDay(
  Database database, {
  String? currentDate,
}) {
  final query = '''
SELECT *
FROM Comics
WHERE strftime('%m-%d', Date) = strftime('%m-%d', '${currentDate}')
ORDER BY strftime('%Y', Date) DESC, Date DESC;
''';
  return _readQuery(database, query, (d) => GetSameDayRow(d));
}

class GetSameDayRow extends SqliteRow {
  GetSameDayRow(Map<String, dynamic> data) : super(data);

  int? get comicID => data['ComicID'] as int?;
  String? get title => data['Title'] as String?;
  String? get date => data['Date'] as String?;
  String? get imgLink => data['ImgLink'] as String?;
  String? get altText => data['AltText'] as String?;
}

/// END GETSAMEDAY

/// BEGIN GETALL
Future<List<GetAllRow>> performGetAll(
  Database database,
) {
  final query = '''
SELECT *
FROM Comics
ORDER BY ComicID DESC
''';
  return _readQuery(database, query, (d) => GetAllRow(d));
}

class GetAllRow extends SqliteRow {
  GetAllRow(Map<String, dynamic> data) : super(data);

  int? get comicID => data['ComicID'] as int?;
  String? get title => data['Title'] as String?;
  String? get date => data['Date'] as String?;
  String? get imgLink => data['ImgLink'] as String?;
  String? get altText => data['AltText'] as String?;
}

/// END GETALL

/// BEGIN GETAFEW
Future<List<GetAFewRow>> performGetAFew(
  Database database, {
  int? id1,
  int? id2,
  int? id3,
}) {
  final query = '''
SELECT *
FROM Comics
Where ComicID = ${id1}
 OR ComicID = ${id2} + 1 OR ComicID = ${id3} - 1;
''';
  return _readQuery(database, query, (d) => GetAFewRow(d));
}

class GetAFewRow extends SqliteRow {
  GetAFewRow(Map<String, dynamic> data) : super(data);

  int? get comicID => data['ComicID'] as int?;
  String? get title => data['Title'] as String?;
  String? get date => data['Date'] as String?;
  String? get imgLink => data['ImgLink'] as String?;
  String? get altText => data['AltText'] as String?;
}

/// END GETAFEW

/// BEGIN GETBYID
Future<List<GetByIDRow>> performGetByID(
  Database database, {
  int? id,
}) {
  final query = '''
SELECT *
FROM Comics
Where ComicID = ${id}
LIMIT 1;
''';
  return _readQuery(database, query, (d) => GetByIDRow(d));
}

class GetByIDRow extends SqliteRow {
  GetByIDRow(Map<String, dynamic> data) : super(data);

  int? get comicID => data['ComicID'] as int?;
  String? get title => data['Title'] as String?;
  String? get date => data['Date'] as String?;
  String? get imgLink => data['ImgLink'] as String?;
  String? get altText => data['AltText'] as String?;
}

/// END GETBYID

/// BEGIN GETALLASC
Future<List<GetAllAscRow>> performGetAllAsc(
  Database database,
) {
  final query = '''
SELECT *
FROM Comics
ORDER BY ComicID ASC
''';
  return _readQuery(database, query, (d) => GetAllAscRow(d));
}

class GetAllAscRow extends SqliteRow {
  GetAllAscRow(Map<String, dynamic> data) : super(data);

  int? get comicID => data['ComicID'] as int?;
  String? get title => data['Title'] as String?;
  String? get date => data['Date'] as String?;
  String? get imgLink => data['ImgLink'] as String?;
  String? get altText => data['AltText'] as String?;
}

/// END GETALLASC
