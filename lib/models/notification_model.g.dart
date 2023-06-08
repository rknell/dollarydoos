// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      postId: json['postId'] as String,
      isRead: json['isRead'] as bool,
      commentId: json['commentId'] as String?,
      id: JSONHelpers.fromJsonObjectId(json['_id']),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      '_id': JSONHelpers.toJsonObjectId(instance.id),
      'postId': instance.postId,
      'commentId': instance.commentId,
      'isRead': instance.isRead,
    };
