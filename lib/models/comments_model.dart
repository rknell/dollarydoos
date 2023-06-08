import 'package:json_annotation/json_annotation.dart';

import 'db_model.dart';
import 'json_helpers.dart';

part 'comments_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment extends DbModel {
  String body;
  String author;
  final List<Comment> comments;
  final Set<String> upvotes;
  final Set<String> downvotes;
  int score;
  double rank;

  Comment(
      {required this.body,
      required this.author,
      List<Comment>? comments,
      Set<String>? upvotes,
      Set<String>? downvotes,
      this.score = 0,
      this.rank = 0,
      super.id})
      : upvotes = upvotes ?? <String>{},
        downvotes = downvotes ?? <String>{},
        comments = comments ?? <Comment>[];

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  Comment fromJson(Map<String, dynamic> json) => Comment.fromJson(json);

  void calculateScore() {
    score = upvotes.length - downvotes.length;
    rank = score / DateTime.now().difference(id.dateTime).inMinutes;
  }
}
