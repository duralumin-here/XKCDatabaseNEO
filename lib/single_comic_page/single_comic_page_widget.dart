import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'single_comic_page_model.dart';
export 'single_comic_page_model.dart';

class SingleComicPageWidget extends StatefulWidget {
  const SingleComicPageWidget({
    super.key,
    required this.images,
    required this.ids,
    required this.titles,
    required this.dates,
    required this.altTexts,
    int? startIndex,
  }) : this.startIndex = startIndex ?? 0;

  final List<String>? images;
  final List<int>? ids;
  final List<String>? titles;
  final List<String>? dates;
  final List<String>? altTexts;
  final int startIndex;

  static String routeName = 'SingleComicPage';
  static String routePath = '/comic-view';

  @override
  State<SingleComicPageWidget> createState() => _SingleComicPageWidgetState();
}

class _SingleComicPageWidgetState extends State<SingleComicPageWidget> {
  late SingleComicPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SingleComicPageModel());
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
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  final comicsById = widget.ids!.toList();

                  return PageView.builder(
                    controller: _model.pageViewController ??= PageController(
                        initialPage: max(
                            0,
                            min(
                                valueOrDefault<int>(
                                  widget.startIndex,
                                  0,
                                ),
                                comicsById.length - 1))),
                    onPageChanged: (_) async {
                      _model.currentIndex = _model.pageViewCurrentIndex;
                      safeSetState(() {});
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: comicsById.length,
                    itemBuilder: (context, comicsByIdIndex) {
                      final comicsByIdItem = comicsById[comicsByIdIndex];
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  45.0, 5.0, 0.0, 5.0),
                              child: Text(
                                '${(widget.ids?.elementAtOrNull(comicsByIdIndex))?.toString()} • ${widget.titles?.elementAtOrNull(comicsByIdIndex)}',
                                maxLines: 2,
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 50.0),
                              child: Container(
                                decoration: BoxDecoration(),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child:
                                                  FlutterFlowExpandedImageView(
                                                image: Image.network(
                                                  (widget.images!
                                                      .elementAtOrNull(
                                                          comicsByIdIndex))!,
                                                  fit: BoxFit.contain,
                                                ),
                                                allowRotation: false,
                                                tag: (widget.images!
                                                    .elementAtOrNull(
                                                        comicsByIdIndex))!,
                                                useHeroAnimation: true,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: (widget.images!.elementAtOrNull(
                                              comicsByIdIndex))!,
                                          transitionOnUserGestures: true,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            child: Image.network(
                                              (widget.images!.elementAtOrNull(
                                                  comicsByIdIndex))!,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            dateTimeFormat(
                                                "EEEE, MMMM d, y",
                                                functions.strToDate((widget
                                                    .dates!
                                                    .elementAtOrNull(
                                                        comicsByIdIndex))!)),
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFFC3C3C3),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 1.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              widget.altTexts?.elementAtOrNull(
                                                  comicsByIdIndex),
                                              '[AltText]',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Align(
                alignment: AlignmentDirectional(-1.0, -1.0),
                child: FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 40.0,
                  fillColor: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).info,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.safePop();
                  },
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        icon: Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          print('shareButton pressed ...');
                        },
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        icon: Icon(
                          Icons.folder_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          print('saveButton pressed ...');
                        },
                      ),
                      if (widget.ids!.length > 1)
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.shuffle_rounded,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            await _model.pageViewController?.animateToPage(
                              random_data.randomInteger(
                                  0,
                                  valueOrDefault<int>(
                                    widget.ids!.length - 1,
                                    0,
                                  )),
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                            _model.currentIndex = _model.pageViewCurrentIndex;
                          },
                        ),
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        icon: Icon(
                          Icons.question_mark_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          await launchURL(
                              'https://explainxkcd.com/${(widget.ids?.elementAtOrNull(_model.pageViewCurrentIndex))?.toString()}');
                        },
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        icon: Icon(
                          Icons.launch_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          await launchURL(
                              'https://xkcd.com/${(widget.ids?.elementAtOrNull(_model.pageViewCurrentIndex))?.toString()}');
                        },
                      ),
                    ],
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
