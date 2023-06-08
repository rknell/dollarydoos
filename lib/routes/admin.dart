import 'package:alfred/alfred.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../services/database.dart';

class AdminRoute {
  static Future rankPosts(HttpRequest req, HttpResponse res) async {
    await for (var post
        in db.posts.find(SelectorBuilder().fields(['upvotes', 'downvotes']))) {
      // Rank is defined by total score (upvotes length - downvotes length) / minutes since post
      final upvotesLength = (post['upvotes'] as List).length;
      final downvotesLength = (post['downvotes'] as List).length;
      final minutesSincePost = DateTime.now()
          .difference((post['_id'] as ObjectId).dateTime)
          .inMinutes;
      final rank = (upvotesLength - downvotesLength) / minutesSincePost;
      await db.posts.updateOne({
        '_id': post['_id']
      }, {
        '\$set': {'rank': rank}
      });
    }
    return {'message': 'complete'};
  }
}
