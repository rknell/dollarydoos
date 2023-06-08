// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cent _$CentFromJson(Map<String, dynamic> json) => Cent(
      displayName: json['displayName'] as String,
      idName: json['idName'] as String,
      description: json['description'] as String,
      mods: (json['mods'] as List<dynamic>?)?.map((e) => e as String).toSet(),
      id: JSONHelpers.fromJsonObjectId(json['_id']),
    );

Map<String, dynamic> _$CentToJson(Cent instance) => <String, dynamic>{
      '_id': JSONHelpers.toJsonObjectId(instance.id),
      'displayName': instance.displayName,
      'idName': instance.idName,
      'description': instance.description,
      'mods': instance.mods.toList(),
    };
