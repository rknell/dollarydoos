import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dollarydoo/services/database.dart';
import 'package:dollarydoo/views/registration.dart';

import '../models/user_model.dart';

/// Users hold the users accounts and their data.
///
///

class UserRoutes {
  // Login in the user
  static Future login(HttpRequest req, res) async {
    final body = await req.bodyAsJsonMap;
    final user = await db.users.findOne({'username': body['username']});
    if (user == null) {
      throw AlfredException(401, {'message': 'User not found'});
    }
    if (BCrypt.checkpw(body['password'], user['password']) == false) {
      throw AlfredException(401, {'message': 'Incorrect password'});
    }
    final userObj = User.fromJson(user);
    res.cookies.add(Cookie('token', userObj.jwt)..path = '/');
    return {"token": userObj.jwt};
  }

  static Future loginView(HttpRequest req, HttpResponse res) async {
    res.headers.contentType = ContentType.html;
    return registationView();
  }

  /// Register a new user
  static Future create(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final existingUser = await db.users.findOne({'username': body['username']});
    if (existingUser != null) {
      throw AlfredException(400, {'message': 'User already exists'});
    }

    final user = User.fromJson(body);

    /// salt the users password
    user.password = BCrypt.hashpw(body['password'], BCrypt.gensalt());

    /// save the user
    await db.users.insertOne(user.toJson());
    res.cookies.add(Cookie('token', user.jwt)..path = '/');
    return {"token": user.jwt};
  }

  /// Get a logged in users details
  static Future getCurrentUser(HttpRequest req, HttpResponse res) async {
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(401, {'message': 'Not logged in'});
    } else {
      return currentUser.toJsonSanitized();
    }
  }

  /// Get another users details

  static Future<Map<String, dynamic>> getUser(
      HttpRequest req, HttpResponse res) async {
    final username = req.params['username'];
    final user = await db.users.findOne({'username': username});
    if (user == null) {
      throw AlfredException(404, {'message': 'User not found'});
    }
    return User.fromJson(user).toJsonSanitized();
  }

  static Future logout(HttpRequest req, HttpResponse res) async {
    res.cookies.add(Cookie('token', '')
      ..path = '/'
      ..expires = DateTime(1970));
    if (req.requestedUri.queryParameters.containsKey('json')) {
      return {'message': 'Logged out'};
    } else {
      res.redirect(Uri.parse('/'));
    }
  }
}
