import '/backend/sqlite/sqlite_manager.dart';
import '/components/today_comic_view_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'aa_widget.dart' show AaWidget;
import 'package:flutter/material.dart';

class AaModel extends FlutterFlowModel<AaWidget> {
  ///  Local state fields for this page.

  bool latestLoaded = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - SQLite (GetLatest)] action in Aa widget.
  List<GetLatestRow>? latest;
  // Stores action output result for [Backend Call - SQLite (GetSameDay)] action in Aa widget.
  List<GetSameDayRow>? today;
  // Model for LatestComicView.
  late TodayComicViewModel latestComicViewModel;
  // Models for TodaysComicView.
  late FlutterFlowDynamicModels<TodayComicViewModel> todaysComicViewModels;

  @override
  void initState(BuildContext context) {
    latestComicViewModel = createModel(context, () => TodayComicViewModel());
    todaysComicViewModels =
        FlutterFlowDynamicModels(() => TodayComicViewModel());
  }

  @override
  void dispose() {
    latestComicViewModel.dispose();
    todaysComicViewModels.dispose();
  }
}
