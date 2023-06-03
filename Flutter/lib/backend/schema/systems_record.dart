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

  // "bin1type" field.
  String? _bin1type;
  String get bin1type => _bin1type ?? '';
  bool hasBin1type() => _bin1type != null;

  // "bin1capacity" field.
  String? _bin1capacity;
  String get bin1capacity => _bin1capacity ?? '';
  bool hasBin1capacity() => _bin1capacity != null;

  // "bin1deposited" field.
  String? _bin1deposited;
  String get bin1deposited => _bin1deposited ?? '';
  bool hasBin1deposited() => _bin1deposited != null;

  // "bin2type" field.
  String? _bin2type;
  String get bin2type => _bin2type ?? '';
  bool hasBin2type() => _bin2type != null;

  // "bin2capacity" field.
  String? _bin2capacity;
  String get bin2capacity => _bin2capacity ?? '';
  bool hasBin2capacity() => _bin2capacity != null;

  // "bin2deposited" field.
  String? _bin2deposited;
  String get bin2deposited => _bin2deposited ?? '';
  bool hasBin2deposited() => _bin2deposited != null;

  // "bin3type" field.
  String? _bin3type;
  String get bin3type => _bin3type ?? '';
  bool hasBin3type() => _bin3type != null;

  // "bin3capacity" field.
  String? _bin3capacity;
  String get bin3capacity => _bin3capacity ?? '';
  bool hasBin3capacity() => _bin3capacity != null;

  // "bin3deposited" field.
  String? _bin3deposited;
  String get bin3deposited => _bin3deposited ?? '';
  bool hasBin3deposited() => _bin3deposited != null;

  void _initializeFields() {
    _systemName = snapshotData['system_name'] as String?;
    _systemLocation = snapshotData['system_location'] as LatLng?;
    _bin1 = getDataList(snapshotData['bin1']);
    _bin2 = getDataList(snapshotData['bin2']);
    _bin3 = getDataList(snapshotData['bin3']);
    _bin1type = snapshotData['bin1type'] as String?;
    _bin1capacity = snapshotData['bin1capacity'] as String?;
    _bin1deposited = snapshotData['bin1deposited'] as String?;
    _bin2type = snapshotData['bin2type'] as String?;
    _bin2capacity = snapshotData['bin2capacity'] as String?;
    _bin2deposited = snapshotData['bin2deposited'] as String?;
    _bin3type = snapshotData['bin3type'] as String?;
    _bin3capacity = snapshotData['bin3capacity'] as String?;
    _bin3deposited = snapshotData['bin3deposited'] as String?;
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
  String? bin1type,
  String? bin1capacity,
  String? bin1deposited,
  String? bin2type,
  String? bin2capacity,
  String? bin2deposited,
  String? bin3type,
  String? bin3capacity,
  String? bin3deposited,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'system_name': systemName,
      'system_location': systemLocation,
      'bin1type': bin1type,
      'bin1capacity': bin1capacity,
      'bin1deposited': bin1deposited,
      'bin2type': bin2type,
      'bin2capacity': bin2capacity,
      'bin2deposited': bin2deposited,
      'bin3type': bin3type,
      'bin3capacity': bin3capacity,
      'bin3deposited': bin3deposited,
    }.withoutNulls,
  );

  return firestoreData;
}
