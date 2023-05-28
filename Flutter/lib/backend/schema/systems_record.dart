import 'dart:async';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SystemsRecord extends FirestoreRecord {
  SystemsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "system_name" field.
  String? _systemName;
  String get systemName => _systemName ?? '';
  bool hasSystemName() => _systemName != null;

  // "system_location" field.
  LatLng? _systemLocation;
  LatLng? get systemLocation => _systemLocation;
  bool hasSystemLocation() => _systemLocation != null;

  // "bin1" field.
  List<String>? _bin1;
  List<String> get bin1 => _bin1 ?? const [];
  bool hasBin1() => _bin1 != null;

  // "bin2" field.
  List<String>? _bin2;
  List<String> get bin2 => _bin2 ?? const [];
  bool hasBin2() => _bin2 != null;

  // "bin3" field.
  List<String>? _bin3;
  List<String> get bin3 => _bin3 ?? const [];
  bool hasBin3() => _bin3 != null;

  void _initializeFields() {
    _systemName = snapshotData['system_name'] as String?;
    _systemLocation = snapshotData['system_location'] as LatLng?;
    _bin1 = getDataList(snapshotData['bin1']);
    _bin2 = getDataList(snapshotData['bin2']);
    _bin3 = getDataList(snapshotData['bin3']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('systems');

  static Stream<SystemsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SystemsRecord.fromSnapshot(s));

  static Future<SystemsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SystemsRecord.fromSnapshot(s));

  static SystemsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SystemsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SystemsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SystemsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SystemsRecord(reference: ${reference.path}, data: $snapshotData)';
}

Map<String, dynamic> createSystemsRecordData({
  String? systemName,
  LatLng? systemLocation,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'system_name': systemName,
      'system_location': systemLocation,
    }.withoutNulls,
  );

  return firestoreData;
}
