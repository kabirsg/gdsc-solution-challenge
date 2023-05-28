import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'info_model.dart';
export 'info_model.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({
    Key? key,
    required this.bininfo,
  }) : super(key: key);

  final SystemsRecord? bininfo;

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  late InfoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InfoModel());
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Info',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
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
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.bininfo!.systemName,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    valueOrDefault<String>(
                      widget.bininfo!.systemLocation?.toString(),
                      '0',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Capacity:',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                            Text(
                              'Type:',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                            Text(
                              'Number Deposited:',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                        Builder(
                          builder: (context) {
                            final binInfo = widget.bininfo!.bin1.toList();
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children:
                                  List.generate(binInfo.length, (binInfoIndex) {
                                final binInfoItem = binInfo[binInfoIndex];
                                return Text(
                                  binInfoItem,
                                  textAlign: TextAlign.start,
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.bininfo!.bin2.length > 0)
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Capacity:',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              Text(
                                'Type:',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              Text(
                                'Number Deposited:',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ],
                          ),
                          Builder(
                            builder: (context) {
                              final binInfo = widget.bininfo!.bin1.toList();
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(binInfo.length,
                                    (binInfoIndex) {
                                  final binInfoItem = binInfo[binInfoIndex];
                                  return Text(
                                    binInfoItem,
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Visibility(
                      visible: widget.bininfo!.bin3.length > 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Capacity:',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              Text(
                                'Type:',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              Text(
                                'Number Deposited:',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ],
                          ),
                          Builder(
                            builder: (context) {
                              final binInfo = widget.bininfo!.bin3.toList();
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(binInfo.length,
                                    (binInfoIndex) {
                                  final binInfoItem = binInfo[binInfoIndex];
                                  return Text(
                                    binInfoItem,
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
