import 'package:mongo_dart/mongo_dart.dart';

class JSONHelpers {
  static ObjectId fromJsonObjectId(dynamic input) {
    if (input is ObjectId) {
      return input;
    } else if (input is String) {
      return ObjectId.fromHexString(input);
    } else if (input == null) {
      // This may cause some bugs if used improperly. But if the user
      // submits a new record, and the id is null, then we want to
      // generate a new id for them.
      return ObjectId();
    } else {
      throw FieldNotObjectIdException();
    }
  }

  static ObjectId toJsonObjectId(ObjectId input) {
    return input;
  }

  static ObjectId? fromJsonObjectIdNullable(dynamic input) {
    if (input is ObjectId) {
      return input;
    } else if (input is String) {
      return ObjectId.fromHexString(input);
    } else if (input == null) {
      return null;
    } else {
      throw FieldNotObjectIdException();
    }
  }

  static ObjectId? toJsonObjectIdNullable(ObjectId? input) {
    return input;
  }
}

class FieldNotObjectIdException implements Exception {}
