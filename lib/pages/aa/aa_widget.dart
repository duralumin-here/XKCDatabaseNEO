import '/backend/sqlite/sqlite_manager.dart';
import '/components/today_comic_view_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'aa_model.dart';
export 'aa_model.dart';

class AaWidget extends StatefulWidget {
  const AaWidget({super.key});

  static String routeName = 'Aa';
  static String routePath = '/home';

  @override
  State<AaWidget> createState() => _AaWidgetState();
}

class _AaWidgetState extends State<AaWidget> {
  late AaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AaModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.latest = await SQLiteManager.instance.getLatest();
      _model.today = await SQLiteManager.instance.getSameDay(
        currentDate: dateTimeFormat("y-MM-DD", getCurrentTimestamp),
      );
      _model.latestLoaded = true;
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Today',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                1.0, 0.0, 0.0, 10.0),
                            child: Text(
                              'Latest',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              SingleComicPageWidget.routeName,
                              queryParameters: {
                                'images': serializeParam(
                                  _model.latest
                                      ?.map((e) => e.imgLink)
                                      .withoutNulls
                                      .toList(),
                                  ParamType.String,
                                  isList: true,
                                ),
                                'ids': serializeParam(
                                  _model.latest
                                      ?.map((e) => e.comicID)
                                      .withoutNulls
                                      .toList(),
                                  ParamType.int,
                                  isList: true,
                                ),
                                'titles': serializeParam(
                                  _model.latest
                                      ?.map((e) => e.title)
                                      .withoutNulls
                                      .toList(),
                                  ParamType.String,
                                  isList: true,
                                ),
                                'dates': serializeParam(
                                  _model.latest
                                      ?.map((e) => e.date)
                                      .withoutNulls
                                      .toList(),
                                  ParamType.String,
                                  isList: true,
                                ),
                                'altTexts': serializeParam(
                                  _model.latest
                                      ?.map((e) => e.altText)
                                      .withoutNulls
                                      .toList(),
                                  ParamType.String,
                                  isList: true,
                                ),
                                'startIndex': serializeParam(
                                  0,
                                  ParamType.int,
                                ),
                              }.withoutNulls,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType:
                                      PageTransitionType.rightToLeft,
                                ),
                              },
                            );
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            constraints: BoxConstraints(
                              minHeight: 100.0,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Visibility(
                              visible: _model.latestLoaded,
                              child: wrapWithModel(
                                model: _model.latestComicViewModel,
                                updateCallback: () => safeSetState(() {}),
                                child: TodayComicViewWidget(
                                  image: _model.latest!.firstOrNull!.imgLink!,
                                  id: _model.latest!.firstOrNull!.comicID!,
                                  title: _model.latest!.firstOrNull!.title!,
                                  altText: _model.latest!.firstOrNull!.altText!,
                                  date: functions.strToDate(
                                      _model.latest!.firstOrNull!.date!)!,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                1.0, 0.0, 0.0, 10.0),
                            child: Text(
                              'Comics from ${dateTimeFormat("MMMMd", getCurrentTimestamp)}',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final sameDayComics = _model.today
                                    ?.where((e) => valueOrDefault<bool>(
                                          dateTimeFormat("y-MM-dd",
                                                      getCurrentTimestamp) ==
                                                  (e.date!)
                                              ? false
                                              : true,
                                          true,
                                        ))
                                    .toList()
                                    .toList() ??
                                [];

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(sameDayComics.length,
                                    (sameDayComicsIndex) {
                                  final sameDayComicsItem =
                                      sameDayComics[sameDayComicsIndex];
                                  return Stack(
                                    alignment: AlignmentDirectional(0.0, 1.0),
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            SingleComicViewWidget.routeName,
                                            queryParameters: {
                                              'ids': serializeParam(
                                                _model.today
                                                    ?.map((e) => e.comicID)
                                                    .withoutNulls
                                                    .toList(),
                                                ParamType.int,
                                                isList: true,
                                              ),
                                              'startIndex': serializeParam(
                                                sameDayComicsIndex,
                                                ParamType.int,
                                              ),
                                            }.withoutNulls,
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.scale,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                duration:
                                                    Duration(milliseconds: 300),
                                              ),
                                            },
                                          );
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.7,
                                            maxHeight:
                                                MediaQuery.sizeOf(context)
                                                        .height *
                                                    0.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: SingleChildScrollView(
                                            primary: false,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                if (_model.latestLoaded)
                                                  wrapWithModel(
                                                    model: _model
                                                        .todaysComicViewModels
                                                        .getModel(
                                                      sameDayComicsIndex
                                                          .toString(),
                                                      sameDayComicsIndex,
                                                    ),
                                                    updateCallback: () =>
                                                        safeSetState(() {}),
                                                    child: TodayComicViewWidget(
                                                      key: Key(
                                                        'Key4kf_${sameDayComicsIndex.toString()}',
                                                      ),
                                                      image: sameDayComicsItem
                                                          .imgLink!,
                                                      id: sameDayComicsItem
                                                          .comicID!,
                                                      title: sameDayComicsItem
                                                          .title!,
                                                      altText: sameDayComicsItem
                                                          .altText!,
                                                      date: functions.strToDate(
                                                          sameDayComicsItem
                                                              .date!)!,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).divide(SizedBox(width: 10.0)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ]
                      .divide(SizedBox(height: 10.0))
                      .addToStart(SizedBox(height: 10.0))
                      .addToEnd(SizedBox(height: 10.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
