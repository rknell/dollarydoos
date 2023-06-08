import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/comments_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/database.dart';
import '../views/post_view.dart';

class PostsRoutes {
  static Future get(HttpRequest req, HttpResponse res) async {
    final postId = req.params['postId'] as String?;
    final currentUser = await User.getCurrentUser(req);
    if (postId == null) {
      throw AlfredException(400, {'message': 'postId is required'});
    }
    final post = await db.posts.findOne({"_id": ObjectId.parse(postId)});
    if (post == null) {
      throw AlfredException(404, {'message': 'Post not found'});
    }
    if (req.requestedUri.queryParameters['json'] == 'true') {
      final postObj = Post.fromJson(post);
      return postObj.toJsonSanitized();
    } else {
      res.headers.contentType = ContentType.html;
      return postView(Post.fromJson(post), user: currentUser);
    }
  }

  static Future upvote(HttpRequest req, HttpResponse res) async {
    final postId = req.params['postId'];
    final post = await db.posts.findOne({"_id": ObjectId.parse(postId)});
    if (post == null) {
      throw AlfredException(404, {'message': 'Post not found'});
    }
    final postObj = Post.fromJson(post);
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(
          401, {'message': 'You must be logged in to upvote'});
    }
    postObj.downvotes.remove(currentUser.username);
    postObj.upvotes.add(currentUser.username);
    await postObj.save();
    return {'message': 'Upvoted'};
  }

  static Future downvote(HttpRequest req, HttpResponse res) async {
    final postId = req.params['postId'] as String?;
    if (postId == null) {
      throw AlfredException(400, {'message': 'postId is required'});
    }
    final post = await db.posts.findOne({"_id": ObjectId.parse(postId)});
    if (post == null) {
      throw AlfredException(404, {'message': 'Post not found'});
    }
    final postObj = Post.fromJson(post);
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(
          401, {'message': 'You must be logged in to downvote'});
    }

    postObj.upvotes.remove(currentUser.username);
    postObj.downvotes.add(currentUser.username);
    await postObj.save();
    return {'message': 'Downvoted'};
  }

  /// Submit a post comment
  static Future addComment(HttpRequest req, HttpResponse res) async {
    final postId = req.params['postId'] as String?;
    if (postId == null) {
      throw AlfredException(400, {'message': 'postId is required'});
    }
    final parentCommentId = req.params['commentId'] as String?;
    final post = await db.posts.findOne({"_id": ObjectId.parse(postId)});
    if (post == null) {
      throw AlfredException(404, {'message': 'Post not found'});
    }
    final postObj = Post.fromJson(post);
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(
          401, {'message': 'You must be logged in to comment'});
    }

    final body = await req.bodyAsJsonMap;
    body['author'] = currentUser.username;
    final comment = Comment.fromJson(body);
    comment.author = currentUser.username;

    if (parentCommentId != null) {
      /// recursively find the parent comment and add the new comment to it

      final parentComment = _findCommentById(postObj.comments, parentCommentId);
      if (parentComment == null) {
        throw AlfredException(404, {'message': 'Comment not found'});
      }
      parentComment.comments.add(comment);
    } else {
      postObj.comments.add(comment);
    }
    postObj.commentCount++;
    await postObj.save();
    return comment.toJson();
  }

  /// Upvote a post comment
  static Future upvoteComment(HttpRequest req, HttpResponse res) async {
    final postId = req.params['postId'];
    if (postId == null) {
      throw AlfredException(400, {'message': 'postId is required'});
    }
    final commentId = req.params['commentId'];
    final post = await db.posts.findOne({"_id": ObjectId.parse(postId)});
    if (post == null) {
      throw AlfredException(404, {'message': 'Post not found'});
    }
    final postObj = Post.fromJson(post);
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(
          401, {'message': 'You must be logged in to upvote'});
    }

    final comment = _findCommentById(postObj.comments, commentId);
    if (comment == null) {
      throw AlfredException(400, {'message': "Comment not found"});
    }

    comment.downvotes.remove(currentUser.username);
    comment.upvotes.add(currentUser.username);
    await postObj.save();
    return {'message': 'Upvoted'};
  }

  /// Downvote a post comment
  static Future downvoteComment(HttpRequest req, HttpResponse res) async {
    final postId = req.params['postId'];
    if (postId == null) {
      throw AlfredException(400, {'message': 'postId is required'});
    }
    final commentId = req.params['commentId'];
    final post = await db.posts.findOne({"_id": ObjectId.parse(postId)});
    if (post == null) {
      throw AlfredException(404, {'message': 'Post not found'});
    }
    final postObj = Post.fromJson(post);
    final currentUser = await User.getCurrentUser(req);
    if (currentUser == null) {
      throw AlfredException(
          401, {'message': 'You must be logged in to downvote'});
    }

    final comment = _findCommentById(postObj.comments, commentId);
    if (comment == null) {
      throw AlfredException(400, {'message': "Comment not found"});
    }
    comment.upvotes.remove(currentUser.username);
    comment.downvotes.add(currentUser.username);
    await postObj.save();
    return {'message': 'Downvoted'};
  }

  static Comment? _findCommentById(List<Comment> comments, String id) {
    /// recursively find a comment by id
    for (var comment in comments) {
      comment.calculateScore();
      if (comment.id.toHexString() == id) {
        return comment;
      }
      final found = _findCommentById(comment.comments, id);
      if (found != null) {
        return found;
      }
    }
    return null;
  }
}
