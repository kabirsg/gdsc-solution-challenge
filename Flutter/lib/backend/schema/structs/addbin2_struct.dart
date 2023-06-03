// ignore_for_file: unnecessary_getters_setters
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Addbin2Struct extends FFFirebaseStruct {
  Addbin2Struct({
    String? type,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _type = type,
        super(firestoreUtilData);

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;
  bool hasType() => _type != null;

  static Addbin2Struct fromMap(Map<String, dynamic> data) => Addbin2Struct(
        type: data['type'] as String?,
      );

  static Addbin2Struct? maybeFromMap(dynamic data) =>
      data is Map<String, dynamic> ? Addbin2Struct.fromMap(data) : null;

  Map<String, dynamic> toMap() => {
        'type': _type,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
      }.withoutNulls;

  static Addbin2Struct fromSerializableMap(Map<String, dynamic> data) =>
      Addbin2Struct(
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'Addbin2Struct(${toMap()})';
}

Addbin2Struct createAddbin2Struct({
  String? type,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    Addbin2Struct(
      type: type,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

Addbin2Struct? updateAddbin2Struct(
  Addbin2Struct? addbin2, {
  bool clearUnsetFields = true,
}) =>
    addbin2
      ?..firestoreUtilData =
          FirestoreUtilData(clearUnsetFields: clearUnsetFields);

void addAddbin2StructData(
  Map<String, dynamic> firestoreData,
  Addbin2Struct? addbin2,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (addbin2 == null) {
    return;
  }
  if (addbin2.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && addbin2.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final addbin2Data = getAddbin2FirestoreData(addbin2, forFieldValue);
  final nestedData = addbin2Data.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = addbin2.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAddbin2FirestoreData(
  Addbin2Struct? addbin2, [
  bool forFieldValue = false,
]) {
  if (addbin2 == null) {
    return {};
  }
  final firestoreData = mapToFirestore(addbin2.toMap());

  // Add any Firestore field values
  addbin2.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAddbin2ListFirestoreData(
  List<Addbin2Struct>? addbin2s,
) =>
    addbin2s?.map((e) => getAddbin2FirestoreData(e, true)).toList() ?? [];
