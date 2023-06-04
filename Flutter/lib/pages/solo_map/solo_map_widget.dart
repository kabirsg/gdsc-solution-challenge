import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'solo_map_model.dart';
export 'solo_map_model.dart';

class SoloMapWidget extends StatefulWidget {
  const SoloMapWidget({
    Key? key,
    this.parameter1,
    this.parameter2,
  }) : super(key: key);

  final LatLng? parameter1;
  final SystemsRecord? parameter2;

  @override
  _SoloMapWidgetState createState() => _SoloMapWidgetState();
}

class _SoloMapWidgetState extends State<SoloMapWidget> {
  late SoloMapModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SoloMapModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final _googleMapMarker = widget.parameter2;
      return FlutterFlowGoogleMap(
        controller: _model.googleMapsController,
        onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
        initialLocation: _model.googleMapsCenter ??= widget.parameter1!,
        markers: [
          if (_googleMapMarker != null)
            FlutterFlowMarker(
              _googleMapMarker.reference.path,
              _googleMapMarker.systemLocation!,
            ),
        ],
        markerColor: GoogleMarkerColor.blue,
        mapType: MapType.normal,
        style: GoogleMapStyle.standard,
        initialZoom: 14.0,
        allowInteraction: false,
        allowZoom: true,
        showZoomControls: true,
        showLocation: false,
        showCompass: false,
        showMapToolbar: false,
        showTraffic: false,
        centerMapOnMarkerTap: false,
      );
    });
  }
}
