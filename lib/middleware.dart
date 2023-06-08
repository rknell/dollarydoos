import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:collection/collection.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dollarydoo/models/user_model.dart';

class Middleware {
  static void logRequest(HttpRequest request, HttpResponse response) {
    print('${request.method} ${request.requestedUri}');
  }

  static void parseJWTFromCookies(HttpRequest request, HttpResponse response) {
    final jwtString = request.cookies
        .firstWhereOrNull((element) => element.name == 'token')
        ?.value;
    if (jwtString == null || jwtString.isEmpty) {
      return;
    }
    final jwtResult = JWT.tryVerify(jwtString, jwtSecretKey);
    if (jwtResult == null) {
      // Clear the cookie since its invalid
      response.cookies.add(Cookie('token', ''));
      return;
    }
    request.store.set('jwt', jwtResult);
  }

  static void isAuthenticated(HttpRequest request, HttpResponse response) {
    String? jwtString = request.cookies
        .firstWhereOrNull((element) => element.name == 'token')
        ?.value;
    if (jwtString == null) {
      final authoirzationHeader = request.headers['Authorization'];
      if (authoirzationHeader == null) {
        throw AlfredException(401, {'message': 'Not authenticated'});
      }
      final splitResult = authoirzationHeader[0].split(' ');
      if (splitResult.length != 2) {
        throw AlfredException(401, {'message': 'Not authenticated'});
      }
      jwtString = splitResult[1]; // Eg Bearer 1234567890
    }

    final jwtResult = JWT.tryVerify(jwtString, jwtSecretKey);
    if (jwtResult == null) {
      throw AlfredException(401, {'message': 'Not authenticated'});
    }
    request.store.set('jwt', jwtResult);
  }

  static void isAdmin(HttpRequest req, HttpResponse res) {
    final apiKey = req.requestedUri.queryParameters['apikey'];

    if (apiKey == null || apiKey != Platform.environment['APIKEY']) {
      throw AlfredException(401, {'message': 'yeah nah son'});
    }
  }
}
