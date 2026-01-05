import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'today_comic_view_model.dart';
export 'today_comic_view_model.dart';

class TodayComicViewWidget extends StatefulWidget {
  const TodayComicViewWidget({
    super.key,
    required this.image,
    required this.id,
    required this.title,
    required this.date,
    required this.altText,
  });

  final String? image;
  final int? id;
  final String? title;
  final DateTime? date;
  final String? altText;

  @override
  State<TodayComicViewWidget> createState() => _TodayComicViewWidgetState();
}

class _TodayComicViewWidgetState extends State<TodayComicViewWidget> {
  late TodayComicViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TodayComicViewModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 0.0),
          child: AutoSizeText(
            '${widget.id?.toString()} • ${widget.title}',
            maxLines: 2,
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 5.0),
          child: Text(
            valueOrDefault<String>(
              dateTimeFormat("relative", widget.date),
              '[Date]',
            ),
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelSmall.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0.0, -1.0),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Image.network(
                valueOrDefault<String>(
                  widget.image,
                  'https://imgs.xkcd.com/comics/memo_spike_connector.png',
                ),
                fit: BoxFit.scaleDown,
                alignment: Alignment(-1.0, -1.0),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              valueOrDefault<String>(
                widget.altText,
                '[AltText]',
              ),
              textAlign: TextAlign.start,
              maxLines: 20,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle: FontStyle.italic,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle: FontStyle.italic,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
