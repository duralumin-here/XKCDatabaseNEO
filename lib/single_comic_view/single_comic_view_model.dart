import '/flutter_flow/flutter_flow_util.dart';
import 'single_comic_view_widget.dart' show SingleComicViewWidget;
import 'package:flutter/material.dart';

class SingleComicViewModel extends FlutterFlowModel<SingleComicViewWidget> {
  ///  Local state fields for this page.

  int? currentIndex;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
