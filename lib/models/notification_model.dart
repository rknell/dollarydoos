/// A message is a notification for a user, usually a response to a post or
/// comment

import 'package:json_annotation/json_annotation.dart';

import 'db_model.dart';
import 'json_helpers.dart';

part 'notification_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification extends DbModel {
  final String postId;
  final String? commentId;
  final bool isRead;
  Notification(
      {required this.postId, required this.isRead, this.commentId, super.id});

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  Notification fromJson(Map<String, dynamic> json) =>
      Notification.fromJson(json);
}
