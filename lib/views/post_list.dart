import 'package:calendar_time/calendar_time.dart';
import 'package:dollarydoo/models/cent_model.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';

/// Returns a HTML rendering of the post list view.
/// This is the current posts in a cent
///
String postListView(Cent cent, List<Post> posts, {User? user}) {
  return """
  <html>
    <head>
      <title>${cent.displayName}</title>
          <style>
         body {
            font-family: Arial, sans-serif;
            margin: 0;
        }
        
        .top-bar {
          background-color: black;
          padding: 5px;
        }
        
        .top-bar a {
          color: white;
        }

        .header {
            background-color: #0079D3;
            color: white;
            padding: 10px 0;
            margin-bottom: 20px;
            text-align: center;
        }

        .reddit-post {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
            display: flex;
        }

        .reddit-post-title {
            font-size: 20px;
            color: #0079D3;
        }

        .reddit-post-details {
            font-size: 14px;
            color: #888;
            margin-bottom: 10px;
        }

        .reddit-post-content {
            margin-left: 25px;
            font-size: 16px;
        }

        .vote-buttons {
            margin-right: 10px;
        }

        .vote-buttons i {
            display: block;
            width: 20px;
            cursor: pointer;
        }

        .vote-count {
            text-align: center;
            font-size: 20px;
            margin-bottom: 10px;
        }
        
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/fontawesome.min.js"></script>
    <link rel='stylesheet' href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    </head>
    <body>
    <div>
      ${topBar(user, cent)}
    </div>
    <div class='header'>
      <h1>${cent.displayName}</h1>
    </div>
    
      <ul>
        ${posts.map((post) => postListItemView(post)).join()}
      </ul>
      <script>
        \$(".upvote-button").click(function() {
            var postId = \$(this).closest(".reddit-post").attr("id");
            var cent = \$(this).closest(".reddit-post").attr("cent");
            \$.ajax({
                url: '/c/'+ cent + '/comments/'+ postId +'/upvote',
                type: 'POST',
                data: JSON.stringify({ "postId": postId }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(result) {
                    console.log(result);
                    alert('Upvoted!');
                },
                error: function(request,msg,error) {
                    console.log(msg);
                    alert('Error in upvoting');
                }
            });
        });

        \$(".downvote-button").click(function() {
            var postId = \$(this).closest(".reddit-post").attr("id");
            var cent = \$(this).closest(".reddit-post").attr("cent");
            \$.ajax({
                url: '/c/'+ cent + '/comments/'+ postId +'/downvote',
                type: 'POST',
                data: JSON.stringify({ "postId": postId }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(result) {
                    console.log(result);
                    alert('Downvoted!');
                },
                error: function(request,msg,error) {
                    console.log(msg);
                    alert('Error in downvoting');
                }
            });
        });
    </script>
    </body>
  </html>
  """;
}

/// Return a html rendering of a post list item
String postListItemView(Post post) {
  return """
      <div class="reddit-post" id="${post.id.toHexString()}" cent="${post.cent}">
        <div class="vote-buttons">
            <i class="fa-solid fa-circle-up upvote-button"></i>
            <div class="vote-count">${post.score}</div>
            <i class="fa-solid fa-circle-down downvote-button"></i>
        </div>
        <div class='reddit-post-content'>
          <div class="reddit-post-title">
            <a href="${post.linkUrl}">${post.title}</a> 
            ${post.isCommentPost == false ? '(${Uri.parse(post.url!).host})' : ''}
          </div>
          <div class="reddit-post-details">submitted ${CalendarTime(post.timestamp).toHuman} by ${post.author} to <a href='/c/${post.cent}'>/c/${post.cent}</a> </div>
          <div class="reddit-post-content">${post.body}</div>
          <div class="reddit-post-details"><a href="/c/${post.cent}/comments/${post.id.toHexString()}">${post.commentCount} comments</a> share save hide report</div>
        </div>
    </div>
  """;
}

String topBar(User? user, Cent cent) {
  if (user == null) {
    return """
    <div class="top-bar">
      <a href="/account/login">Login | Signup</a>
    </div>
    """;
  } else {
    return """
    <div class="top-bar">
      <a href='/'>Front Page</a>
      <a href="/c/${cent.idName}/create">Create Post</a>
      <a href="/c/create">Create Community</a>
      <a href="/account/logout">Logout</a>
    </div>
    """;
  }
}
