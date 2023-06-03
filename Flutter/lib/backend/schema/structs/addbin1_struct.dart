// ignore_for_file: unnecessary_getters_setters
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Addbin1Struct extends FFFirebaseStruct {
  Addbin1Struct({
    List<String>? bin1info,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _bin1info = bin1info,
        super(firestoreUtilData);

  // "bin1info" field.
  List<String>? _bin1info;
  List<String> get bin1info => _bin1info ?? const [];
  set bin1info(List<String>? val) => _bin1info = val;
  void updateBin1info(Function(List<String>) updateFn) =>
      updateFn(_bin1info ??= []);
  bool hasBin1info() => _bin1info != null;

  static Addbin1Struct fromMap(Map<String, dynamic> data) => Addbin1Struct(
        bin1info: getDataList(data['bin1info']),
      );

  static Addbin1Struct? maybeFromMap(dynamic data) =>
      data is Map<String, dynamic> ? Addbin1Struct.fromMap(data) : null;

  Map<String, dynamic> toMap() => {
        'bin1info': _bin1info,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'bin1info': serializeParam(
          _bin1info,
          ParamType.String,
          true,
        ),
      }.withoutNulls;

  static Addbin1Struct fromSerializableMap(Map<String, dynamic> data) =>
      Addbin1Struct(
        bin1info: deserializeParam<String>(
          data['bin1info'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'Addbin1Struct(${toMap()})';
}

Addbin1Struct createAddbin1Struct({
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    Addbin1Struct(
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

Addbin1Struct? updateAddbin1Struct(
  Addbin1Struct? addbin1, {
  bool clearUnsetFields = true,
}) =>
    addbin1
      ?..firestoreUtilData =
          FirestoreUtilData(clearUnsetFields: clearUnsetFields);

void addAddbin1StructData(
  Map<String, dynamic> firestoreData,
  Addbin1Struct? addbin1,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (addbin1 == null) {
    return;
  }
  if (addbin1.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && addbin1.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final addbin1Data = getAddbin1FirestoreData(addbin1, forFieldValue);
  final nestedData = addbin1Data.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = addbin1.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAddbin1FirestoreData(
  Addbin1Struct? addbin1, [
  bool forFieldValue = false,
]) {
  if (addbin1 == null) {
    return {};
  }
  final firestoreData = mapToFirestore(addbin1.toMap());

  // Add any Firestore field values
  addbin1.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAddbin1ListFirestoreData(
  List<Addbin1Struct>? addbin1s,
) =>
    addbin1s?.map((e) => getAddbin1FirestoreData(e, true)).toList() ?? [];
