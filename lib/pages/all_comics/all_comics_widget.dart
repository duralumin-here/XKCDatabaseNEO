import '/backend/sqlite/sqlite_manager.dart';
import '/components/my_comic_view_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'all_comics_model.dart';
export 'all_comics_model.dart';

class AllComicsWidget extends StatefulWidget {
  const AllComicsWidget({super.key});

  static String routeName = 'AllComics';
  static String routePath = '/all';

  @override
  State<AllComicsWidget> createState() => _AllComicsWidgetState();
}

class _AllComicsWidgetState extends State<AllComicsWidget> {
  late AllComicsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AllComicsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.all = await SQLiteManager.instance.getAll();
      _model.comicsLoaded = true;
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
    context.watch<FFAppState>();

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
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Comics',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              if (MediaQuery.sizeOf(context).width >= 500.0 ? true : false)
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              value: _model.titleCheckboxValue2 ??=
                                  FFAppState().showTitle,
                              onChanged: (newValue) async {
                                safeSetState(() =>
                                    _model.titleCheckboxValue2 = newValue!);
                                if (newValue!) {
                                  FFAppState().showTitle = true;
                                  safeSetState(() {});
                                } else {
                                  FFAppState().showTitle = false;
                                  safeSetState(() {});
                                }
                              },
                              side: (Colors.white != null)
                                  ? BorderSide(
                                      width: 2,
                                      color: Colors.white,
                                    )
                                  : null,
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().showTitle =
                                  !(FFAppState().showTitle ?? true);
                              safeSetState(() {
                                _model.titleCheckboxValue2 =
                                    FFAppState().showTitle;
                              });
                            },
                            child: Text(
                              'Title',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              value: _model.iDCheckboxValue2 ??=
                                  FFAppState().showID,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.iDCheckboxValue2 = newValue!);
                                if (newValue!) {
                                  FFAppState().showID = true;
                                  safeSetState(() {});
                                } else {
                                  FFAppState().showID = false;
                                  safeSetState(() {});
                                }
                              },
                              side: (Colors.white != null)
                                  ? BorderSide(
                                      width: 2,
                                      color: Colors.white,
                                    )
                                  : null,
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().showID =
                                  !(FFAppState().showID ?? true);
                              safeSetState(() {
                                _model.iDCheckboxValue2 = FFAppState().showID;
                              });
                            },
                            child: Text(
                              'ID',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              value: _model.dateCheckboxValue2 ??=
                                  FFAppState().showDate,
                              onChanged: (newValue) async {
                                safeSetState(() =>
                                    _model.dateCheckboxValue2 = newValue!);
                                if (newValue!) {
                                  FFAppState().showDate = true;
                                  safeSetState(() {});
                                } else {
                                  FFAppState().showDate = false;
                                  safeSetState(() {});
                                }
                              },
                              side: (Colors.white != null)
                                  ? BorderSide(
                                      width: 2,
                                      color: Colors.white,
                                    )
                                  : null,
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().showDate =
                                  !(FFAppState().showDate ?? true);
                              safeSetState(() {
                                _model.dateCheckboxValue2 =
                                    FFAppState().showDate;
                              });
                            },
                            child: Text(
                              'Date',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                              value: _model.altTextCheckboxValue2 ??=
                                  FFAppState().showAltText,
                              onChanged: (newValue) async {
                                safeSetState(() =>
                                    _model.altTextCheckboxValue2 = newValue!);
                                if (newValue!) {
                                  FFAppState().showAltText = true;
                                  safeSetState(() {});
                                } else {
                                  FFAppState().showAltText = false;
                                  safeSetState(() {});
                                }
                              },
                              side: (Colors.white != null)
                                  ? BorderSide(
                                      width: 2,
                                      color: Colors.white,
                                    )
                                  : null,
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().showAltText =
                                  !(FFAppState().showAltText ?? true);
                              safeSetState(() {
                                _model.altTextCheckboxValue2 =
                                    FFAppState().showAltText;
                              });
                            },
                            child: Text(
                              'Alt Text',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ToggleIcon(
                          onPressed: () async {
                            safeSetState(() => FFAppState().sortAscending =
                                !FFAppState().sortAscending);
                          },
                          value: FFAppState().sortAscending,
                          onIcon: Icon(
                            Icons.arrow_circle_up_rounded,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          offIcon: Icon(
                            Icons.arrow_circle_down_rounded,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 10.0)),
                  ),
                ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (valueOrDefault<bool>(
                MediaQuery.sizeOf(context).width < 500.0 ? true : false,
                true,
              ))
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                            child: Checkbox(
                              value: _model.titleCheckboxValue1 ??=
                                  FFAppState().showTitle,
                              onChanged: (newValue) async {
                                safeSetState(() =>
                                    _model.titleCheckboxValue1 = newValue!);
                                if (newValue!) {
                                  FFAppState().showTitle = true;
                                  safeSetState(() {});
                                } else {
                                  FFAppState().showTitle = false;
                                  safeSetState(() {});
                                }
                              },
                              side: (FlutterFlowTheme.of(context).primary !=
                                      null)
                                  ? BorderSide(
                                      width: 2,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().showTitle =
                                  !(FFAppState().showTitle ?? true);
                              safeSetState(() {
                                _model.titleCheckboxValue1 =
                                    FFAppState().showTitle;
                              });
                            },
                            child: Text(
                              'Title',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                            child: Checkbox(
                              value: _model.iDCheckboxValue1 ??=
                                  FFAppState().showID,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.iDCheckboxValue1 = newValue!);
                                if (newValue!) {
                                  FFAppState().showID = true;
                                  safeSetState(() {});
                                } else {
                                  FFAppState().showID = false;
                                  safeSetState(() {});
                                }
                              },
                              side: (FlutterFlowTheme.of(context).primary !=
                                      null)
                                  ? BorderSide(
                                      width: 2,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().showID =
                                  !(FFAppState().showID ?? true);
                              safeSetState(() {
                                _model.iDCheckboxValue1 = FFAppState().showID;
                              });
                            },
                            child: Text(
                              'ID',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                            child: Checkbox(
                              value: _model.dateCheckboxValue1 ??=
                                  FFAppState().showDate,
                              onChanged: (newValue) async {
                                safeSetState(() =>
                                    _model.dateCheckboxValue1 = newValue!);
                                if (newValue!) {
                                  FFAppState().showDate = true;
                                  safeSetState(() {});
                                } else {
                                  FFAppState().showDate = false;
                                  safeSetState(() {});
                                }
                              },
                              side: (FlutterFlowTheme.of(context).primary !=
                                      null)
                                  ? BorderSide(
                                      width: 2,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().showDate =
                                  !(FFAppState().showDate ?? true);
                              safeSetState(() {
                                _model.dateCheckboxValue1 =
                                    FFAppState().showDate;
                              });
                            },
                            child: Text(
                              'Date',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                            child: Checkbox(
                              value: _model.altTextCheckboxValue1 ??=
                                  FFAppState().showAltText,
                              onChanged: (newValue) async {
                                safeSetState(() =>
                                    _model.altTextCheckboxValue1 = newValue!);
                                if (newValue!) {
                                  FFAppState().showAltText = true;
                                  safeSetState(() {});
                                } else {
                                  FFAppState().showAltText = false;
                                  safeSetState(() {});
                                }
                              },
                              side: (FlutterFlowTheme.of(context).primary !=
                                      null)
                                  ? BorderSide(
                                      width: 2,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().showAltText =
                                  !(FFAppState().showAltText ?? true);
                              safeSetState(() {
                                _model.altTextCheckboxValue1 =
                                    FFAppState().showAltText;
                              });
                            },
                            child: Text(
                              'Alt Text',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ToggleIcon(
                          onPressed: () async {
                            safeSetState(() => FFAppState().sortAscending =
                                !FFAppState().sortAscending);
                          },
                          value: FFAppState().sortAscending,
                          onIcon: Icon(
                            Icons.arrow_circle_up_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          offIcon: Icon(
                            Icons.arrow_circle_down_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 10.0)),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                  child: Builder(
                    builder: (context) {
                      final allComicData = _model.all?.toList() ?? [];
                      if (allComicData.isEmpty) {
                        return Image.asset(
                          'assets/images/waving.gif',
                          width: 30.0,
                          height: 30.0,
                        );
                      }

                      return MasonryGridView.builder(
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: () {
                            if (MediaQuery.sizeOf(context).width <
                                kBreakpointSmall) {
                              return 2;
                            } else if (MediaQuery.sizeOf(context).width <
                                kBreakpointMedium) {
                              return 3;
                            } else if (MediaQuery.sizeOf(context).width <
                                kBreakpointLarge) {
                              return 4;
                            } else {
                              return 5;
                            }
                          }(),
                        ),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        itemCount: allComicData.length,
                        padding: EdgeInsets.fromLTRB(
                          0,
                          valueOrDefault<double>(
                            MediaQuery.sizeOf(context).width >= 500.0
                                ? 10.0
                                : 0.0,
                            0.0,
                          ),
                          0,
                          10.0,
                        ),
                        itemBuilder: (context, allComicDataIndex) {
                          final allComicDataItem =
                              allComicData[allComicDataIndex];
                          return Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  SingleComicViewWidget.routeName,
                                  queryParameters: {
                                    'ids': serializeParam(
                                      _model.all
                                          ?.map((e) => e.comicID)
                                          .withoutNulls
                                          .toList(),
                                      ParamType.int,
                                      isList: true,
                                    ),
                                    'startIndex': serializeParam(
                                      allComicDataIndex,
                                      ParamType.int,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.scale,
                                      alignment: Alignment.bottomCenter,
                                      duration: Duration(milliseconds: 300),
                                    ),
                                  },
                                );
                              },
                              child: wrapWithModel(
                                model: _model.myComicViewModels.getModel(
                                  allComicDataIndex.toString(),
                                  allComicDataIndex,
                                ),
                                updateCallback: () => safeSetState(() {}),
                                child: MyComicViewWidget(
                                  key: Key(
                                    'Keyyws_${allComicDataIndex.toString()}',
                                  ),
                                  image: allComicDataItem.imgLink!,
                                  id: allComicDataItem.comicID!,
                                  title: allComicDataItem.title!,
                                  altText: allComicDataItem.altText!,
                                  date: functions
                                      .strToDate(allComicDataItem.date!)!,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
