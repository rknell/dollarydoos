import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'json_helpers.dart';

class DbModel {
  @JsonKey(
      name: '_id',
      fromJson: JSONHelpers.fromJsonObjectId,
      toJson: JSONHelpers.toJsonObjectId)
  final ObjectId id;

  DateTime get timestamp => id.dateTime;

  DbModel({required ObjectId? id}) : id = id ?? ObjectId();
}
