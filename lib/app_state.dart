import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _showTitle = prefs.getBool('ff_showTitle') ?? _showTitle;
    });
    _safeInit(() {
      _showID = prefs.getBool('ff_showID') ?? _showID;
    });
    _safeInit(() {
      _showDate = prefs.getBool('ff_showDate') ?? _showDate;
    });
    _safeInit(() {
      _showAltText = prefs.getBool('ff_showAltText') ?? _showAltText;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  /// Whether the All Comics list should be in ascending order (starting at the
  /// lowest ComicID).
  ///
  /// False by default.
  bool _sortAscending = false;
  bool get sortAscending => _sortAscending;
  set sortAscending(bool value) {
    _sortAscending = value;
  }

  bool _showTitle = true;
  bool get showTitle => _showTitle;
  set showTitle(bool value) {
    _showTitle = value;
    prefs.setBool('ff_showTitle', value);
  }

  bool _showID = true;
  bool get showID => _showID;
  set showID(bool value) {
    _showID = value;
    prefs.setBool('ff_showID', value);
  }

  bool _showDate = true;
  bool get showDate => _showDate;
  set showDate(bool value) {
    _showDate = value;
    prefs.setBool('ff_showDate', value);
  }

  bool _showAltText = true;
  bool get showAltText => _showAltText;
  set showAltText(bool value) {
    _showAltText = value;
    prefs.setBool('ff_showAltText', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
