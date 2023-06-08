// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      id: JSONHelpers.fromJsonObjectId(json['_id']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': JSONHelpers.toJsonObjectId(instance.id),
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
    };
