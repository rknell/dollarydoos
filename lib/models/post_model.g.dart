// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      title: json['title'] as String,
      body: json['body'] as String,
      author: json['author'] as String,
      cent: json['cent'] as String,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      url: json['url'] as String?,
      upvotes:
          (json['upvotes'] as List<dynamic>?)?.map((e) => e as String).toSet(),
      downvotes: (json['downvotes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toSet(),
      commentCount: json['commentCount'] as int? ?? 0,
      rank: (json['rank'] as num?)?.toDouble() ?? 0,
      score: json['score'] as int? ?? 0,
      id: JSONHelpers.fromJsonObjectId(json['_id']),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      '_id': JSONHelpers.toJsonObjectId(instance.id),
      'title': instance.title,
      'body': instance.body,
      'author': instance.author,
      'cent': instance.cent,
      'url': instance.url,
      'comments': instance.comments.map((e) => e.toJson()).toList(),
      'upvotes': instance.upvotes.toList(),
      'downvotes': instance.downvotes.toList(),
      'score': instance.score,
      'rank': instance.rank,
      'commentCount': instance.commentCount,
    };
