import 'package:json_annotation/json_annotation.dart';

import '../services/database.dart';
import 'comments_model.dart';
import 'db_model.dart';
import 'json_helpers.dart';

part 'post_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Post extends DbModel {
  String title;
  String body;
  String author;
  String cent;
  String? url;
  final List<Comment> comments;
  final Set<String> upvotes;
  final Set<String> downvotes;

  /// Cached upvote length vs downvote length
  int score;

  /// Cached Calculated score / post age in minutes
  double rank;

  String get commentsUrl => '/c/$cent/comments/${id.toHexString()}';
  int commentCount;

  /// Convenience getter to help with rendering a number of areas
  bool get isCommentPost {
    var url = this.url;
    return url == null || url.isEmpty;
  }

  String get linkUrl {
    if (isCommentPost) {
      return commentsUrl;
    } else {
      return url!;
    }
  }

  Post(
      {required this.title,
      required this.body,
      required this.author,
      required this.cent,
      List<Comment>? comments,
      this.url,
      Set<String>? upvotes,
      Set<String>? downvotes,
      this.commentCount = 0,
      this.rank = 0,
      this.score = 0,
      super.id})
      : upvotes = upvotes ?? <String>{},
        downvotes = downvotes ?? <String>{},
        comments = comments ?? <Comment>[];

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  Post fromJson(Map<String, dynamic> json) => Post.fromJson(json);

  Map<String, dynamic> toJsonSanitized() {
    final json = toJson();
    json.remove('upvotes');
    json.remove('downvotes');
    json['upvotes'] = upvotes.length;
    json['downvotes'] = downvotes.length;
    _recursivelySanitizeComments(json['comments']);
    return json;
  }

  _recursivelySanitizeComments(List comments) {
    for (var comment in comments) {
      comment.remove('upvotes');
      comment.remove('downvotes');
      final children = comment['comments'] as List?;
      if (children != null) {
        _recursivelySanitizeComments(children);
      }
    }
  }

  calculateCached() {
    score = upvotes.length - downvotes.length;
    rank = score / DateTime.now().difference(id.dateTime).inMinutes;
  }

  Future<void> save() async {
    if (upvotes.isNotEmpty || downvotes.isNotEmpty) {
      //full model
      calculateCached();
    }
    sortComments(comments);
    // save to db
    await db.posts.updateOne({"_id": id}, {"\$set": toJson()}, upsert: true);
  }

  /// Recursively loop through the comments and sort them by highest rank to lowest rank
  void sortComments(List<Comment> comments) {
    comments.sort((a, b) => b.rank.compareTo(a.rank));
    for (var comment in comments) {
      sortComments(comment.comments);
    }
  }
}
