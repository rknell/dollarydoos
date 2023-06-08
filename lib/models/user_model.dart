import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dollarydoo/models/notification_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../services/database.dart';
import 'db_model.dart';
import 'json_helpers.dart';

part 'user_model.g.dart';

SecretKey get jwtSecretKey =>
    SecretKey(Platform.environment['JWT_SECRET'] ?? 'debugsecret');

@JsonSerializable(explicitToJson: true)
class User extends DbModel {
  String username;
  String password;
  String email;

  /// Represents a postId the user has a notification for
  final List<Notification> notifications;

  User({
    required this.username,
    required this.password,
    required this.email,
    List<Notification>? messages,
    super.id,
  }) : notifications = messages ?? <Notification>[];

  String get jwt {
    /// Generate a JWT token
    final jwt = JWT({'username': username});

    /// Return the token
    return jwt.sign(jwtSecretKey);
  }

  static Future<User?> getCurrentUser(HttpRequest req) async {
    final jwt = req.store.get('jwt') as JWT?;
    if (jwt == null) {
      return null;
    }
    final user = await db.users.findOne({'username': jwt.payload['username']});
    if (user == null) {
      throw AlfredException(401, {'message': 'User not found'});
    }
    return User.fromJson(user);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> toJsonSanitized() => toJson()..remove('password');

  User fromJson(Map<String, dynamic> json) => User.fromJson(json);
}
