// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      body: json['body'] as String,
      author: json['author'] as String,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      upvotes:
          (json['upvotes'] as List<dynamic>?)?.map((e) => e as String).toSet(),
      downvotes: (json['downvotes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toSet(),
      score: json['score'] as int? ?? 0,
      rank: (json['rank'] as num?)?.toDouble() ?? 0,
      id: JSONHelpers.fromJsonObjectId(json['_id']),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      '_id': JSONHelpers.toJsonObjectId(instance.id),
      'body': instance.body,
      'author': instance.author,
      'comments': instance.comments.map((e) => e.toJson()).toList(),
      'upvotes': instance.upvotes.toList(),
      'downvotes': instance.downvotes.toList(),
      'score': instance.score,
      'rank': instance.rank,
    };
