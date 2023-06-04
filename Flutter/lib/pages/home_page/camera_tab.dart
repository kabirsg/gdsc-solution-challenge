import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:recycle_right/backend/backend.dart';
import '../../backend/schema/systems_record.dart';
import 'package:geopoint/geopoint.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as FirebaseFirestore;
import 'package:latlong2/latlong.dart' as latLng;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../add_system/add_system_model.dart';

class CameraTab extends StatefulWidget {
  @override
  _CameraTabState createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    //_initializeControllerFuture = initializeCamera();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.QR)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    parseQR(barcodeScanRes);
    print(barcodeScanRes);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> parseQR(barcodeScanRes) async {
    print("Connected to firebase");
    final parsed = barcodeScanRes.split('/');
    if (parsed[0] != "RecycleRight") {
      return;
    }
    final latlong = parsed[3].split(',');
    final lat = double.parse(latlong[0]);
    final long = double.parse(latlong[1]);
    final geopoint = FirebaseFirestore.GeoPoint(lat, long);
    final systemsCreateData = createSystemsRecordData(
      systemName: parsed[1],
      systemLocation: LatLng(lat, long),
      bin1type: parsed[4],
      bin1capacity: '0',
      bin1deposited: '0',
      bin2type: parsed[5],
      bin2capacity: '0',
      bin2deposited: '0',
      bin3type: parsed[6],
      bin3capacity: '0',
      bin3deposited: '0',
    );
    await FirebaseFirestore.FirebaseFirestore.instance
        .collection('systems')
        .doc()
        .set(systemsCreateData);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.

    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    print(barcodeScanRes);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () => scanQR(),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF52528C),
                        ),
                        child: Text('Start QR scan')),
                    Text('Scan result : $_scanBarcode\n',
                        style: TextStyle(fontSize: 20))
                  ]));
        })));
  }
}
