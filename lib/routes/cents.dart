import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:dollarydoo/views/create_cent.dart';
import 'package:dollarydoo/views/create_post.dart';
import 'package:dollarydoo/views/post_list.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/cent_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/database.dart';

/// Cents are the equivalent to subreddits
/// They are the main way to organize posts on Dollarydoo
///
class CentRoute {
  static Future get(HttpRequest req, HttpResponse res) async {
    final centName = (req.params['cent'] as String).toLowerCase();
    final cent = await db.cents.findOne({'idName': centName});
    if (cent == null) {
      throw AlfredException(404, {'message': 'Cent not found'});
    }
    var centObj = Cent.fromJson(cent);

    final query = SelectorBuilder()
      ..sortBy('rank', descending: true)
      ..excludeFields(['upvotes', 'downvotes', 'comments']);
    if (centName != 'all') {
      query.match('cent', centName);
    }
    final posts = await db.posts.find(query).take(100).toList();

    var postsObj = posts.map((e) => Post.fromJson(e)).toList();
    final currentUser = await User.getCurrentUser(req);

    if (req.requestedUri.queryParameters['json'] == 'true') {
      return posts;
    } else {
      res.headers.contentType = ContentType.html;
      return postListView(centObj, postsObj, user: currentUser);
    }
  }

  static Future create(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(
          401, {'message': 'You must be logged in to create a cent'});
    }
    final existingCent = await db.cents.findOne({'idName': body['idName']});
    if (existingCent != null) {
      throw AlfredException(400, {'message': 'Cent already exists'});
    }
    final newCent = Cent.fromJson(body);
    newCent.mods.add(currentUser.username);
    await db.cents.insertOne(newCent.toJson());
    return newCent.toJson();
  }

  /// Show the create cent view
  static Future createView(HttpRequest req, HttpResponse res) async {
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(
          401, {'message': 'You must be logged in to create a cent'});
    }
    res.headers.contentType = ContentType.html;
    return createCentView();
  }

  static Future createPost(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(
          401, {'message': 'You must be logged in to create a post'});
    }
    final centName = req.params['cent'];
    body['cent'] = centName;
    body['author'] = currentUser.username;
    final post = Post.fromJson(body);
    await db.posts.insertOne(post.toJson());
    return post.toJson();
  }

  static Future createPostViewRoute(HttpRequest req, HttpResponse res) async {
    final centName = req.params['cent'] as String;
    final output = await createPostView(cent: centName);
    res.headers.contentType = ContentType.html;
    return output;
  }
}
