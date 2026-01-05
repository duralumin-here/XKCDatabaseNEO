import '/backend/sqlite/sqlite_manager.dart';
import '/components/my_comic_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'all_comics_widget.dart' show AllComicsWidget;
import 'package:flutter/material.dart';

class AllComicsModel extends FlutterFlowModel<AllComicsWidget> {
  ///  Local state fields for this page.

  bool comicsLoaded = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - SQLite (GetAll)] action in AllComics widget.
  List<GetAllRow>? all;
  // State field(s) for TitleCheckbox widget.
  bool? titleCheckboxValue1;
  // State field(s) for IDCheckbox widget.
  bool? iDCheckboxValue1;
  // State field(s) for DateCheckbox widget.
  bool? dateCheckboxValue1;
  // State field(s) for AltTextCheckbox widget.
  bool? altTextCheckboxValue1;
  // Models for MyComicView dynamic component.
  late FlutterFlowDynamicModels<MyComicViewModel> myComicViewModels;
  // State field(s) for TitleCheckbox widget.
  bool? titleCheckboxValue2;
  // State field(s) for IDCheckbox widget.
  bool? iDCheckboxValue2;
  // State field(s) for DateCheckbox widget.
  bool? dateCheckboxValue2;
  // State field(s) for AltTextCheckbox widget.
  bool? altTextCheckboxValue2;

  @override
  void initState(BuildContext context) {
    myComicViewModels = FlutterFlowDynamicModels(() => MyComicViewModel());
  }

  @override
  void dispose() {
    myComicViewModels.dispose();
  }
}
