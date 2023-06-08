import '../models/comments_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

String postView(Post post, {User? user}) {
  return """
<html>
<head>
    <title>${post.title}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/fontawesome.min.js"></script>
    <link rel='stylesheet' href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin-top: 0;
        }
        .top-bar {
          background-color: black;
          padding: 5px;
          margin-bottom: 10px;
        }
        .post-title {
            font-size: 1.5em;
            color: #5f99cf;
        }
        .post-header {
          display: flex
        }
        .post-body {
          padding: 20px;background: lightgray;
        }
        .username {
            color: #888;
        }
        .username a {
            color: #888;
        }
        .upvotes {
            color: #888;
        }
        .comment-text {
            margin-bottom: 10px;
        }
        .nested {
            margin-left: 20px;
        }
        .toggle {
            color: #888;
            cursor: pointer;
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
        
        .comment {
          display: flex;
        }
    </style>
</head>
<body>
<div class='top-bar'>
  <a href='/'>Front Page </a>
  <a href='/c/${post.cent}'>/c/${post.cent}</a>
  ${renderAccountButtons(post: post, user: user)}
</div>
    <div class="container">
        <div class='post-header'>
          <div class="vote-buttons">
              <i class="fa-solid fa-circle-up upvote-button"></i>
              <div class="vote-count">${post.score}</div>
              <i class="fa-solid fa-circle-down downvote-button"></i>
          </div>
          <div>
             <div class="post-title">${post.title}</div>
            <hr>
            <div class="post-details">
                <div class="username"><a href="/u/${post.author}">submitted by: /u/${post.author}</a></div>
            </div> 
            <hr>
            <div class="post-body">${post.body}</div> 
          </div>

        </div>

        <hr>
        ${addCommentToPostUI(user)}
        
        ${renderComments(post.comments, user)}
    </div>
    
    <script>
        var cent = "${post.cent}"; // replace with actual cent
        var postId = "${post.id.toHexString()}"; // replace with actual postId
        \$(document).ready(function(){
            \$('.toggle').click(function() {
                \$(this).closest('.comment').slideToggle();
                if (\$(this).text() == '[–]') {
                    \$(this).text('[+]');
                } else {
                    \$(this).text('[–]');
                }
            });
            
            \$('#submitComment').click(function(e) {
                e.preventDefault();
                
                \$('.reply-form').remove();
                
                var url = "/c/" + cent + "/comments/" + postId;
                
                \$.ajax({
                    type: "POST",
                    url: url,
                    data: { body: \$('#newComment').val() },
                    success: function(data) {
                        \$('#message').text("Comment submitted successfully").css('color', 'green');
                    },
                    error: function(xhr) {
                        var json = JSON.parse(xhr.responseText);
                        \$('#message').text(json.message).css('color', 'red');
                    }
                });
            });
            
            \$('.reply-link').click(function(e) {
                console.log('reply link clicked');
                e.preventDefault();
                
                var replyForm = '<div class="form-group reply-form">' +
                                    '<textarea class="reply-text form-control"></textarea>' +
                                    '<button class="submit-reply btn btn-primary mt-2">Submit</button>' +
                                    '<div class="reply-message mt-2"></div>' +
                                '</div>';
                
                \$(this).after(replyForm);
            });
            
            \$(".upvote-button").click(function() {
    
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
            \$.ajax({
                url: '/c/'+ cent + '/comments/'+ postId +'/upvote',
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
        
            \$(".upvote-button-comment").click(function() {
            var commentId = \$(this).closest(".comment").attr("id");
            \$.ajax({
                url: '/c/'+ cent + '/comments/'+ postId +'/comment/' + commentId + '/upvote',
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

        \$(".downvote-button-comment").click(function() {
            var commentId = \$(this).closest(".comment").attr("id");
            \$.ajax({
                url: '/c/'+ cent + '/comments/'+ postId +'/comment/' + commentId + '/downvote',
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
            
            \$(document).on('click', '.submit-reply', function(e) {
                e.preventDefault();
                
                var commentId = \$(this).closest('.comment').attr('id');
           
                var url = "/c/" + cent + "/comments/" + postId + "/comment/" + commentId;
                var replyText = \$(this).siblings('.reply-text').val();
                
                \$.ajax({
                    type: "POST",
                    url: url,
                    data: { body: replyText },
                    success: function(data) {
                        var newComment = '<div class="comment nested">' +
                                             '<div class="upvotes">0 upvotes</div>' +
                                             '<div class="username"><a href="/u/${user?.username}">${user?.username}</a> replied:</div>' +
                                             '<div class="comment-text">' + replyText + '</div>' +
                                         '</div>';
                        \$(e.target).parent().siblings('.nested').append(newComment);
                    },
                    error: function(xhr) {
                        var json = JSON.parse(xhr.responseText);
                        \$(e.target).siblings('.reply-message').text(json.message).css('color', 'red');
                    }
                });
            });
        });
    </script>
</body>
</html>
  """;
}

/// Recurisvely render comments on the post, indenting each level of comments
/// also include the ability to collapse comments
///
String renderComments(List<Comment> comments, User? user) {
  final commentsHtml = comments.map((comment) {
    return """
        <div class="comment" id='${comment.id.toHexString()}'>
          <div class="toggle">[–]</div>
          <div class="vote-buttons">
              <i class="fa-solid fa-circle-up upvote-button-comment"></i>
              <div class="vote-count">${comment.score}</div>
              <i class="fa-solid fa-circle-down downvote-button-comment"></i>
          </div>
          <div class='comment-content'>
            <div class="username"><a href="#">/u/${comment.author}</a></div>
            <div class="comment-text">${comment.body}</div>
            ${(user != null) ? "<a href='#' class='reply-link'>reply</a>" : ""}
            <div class="nested">
                ${renderComments(comment.comments, user)}
            </div>
          </div>
        </div>
    """;
  }).join("\n");

  return commentsHtml;
}

String renderAccountButtons({User? user, required Post post}) {
  if (user == null) {
    return '';
  }
  return """
  <a href='/c/${post.cent}/comments'>Create Post</a>
  <a href='/c'>Create Community</a>
  """;
}

String addCommentToPostUI(User? user) {
  final html = """
  <div class="form-group">
            <label for="newComment">Add a comment:</label>
            <textarea id="newComment" class="form-control"></textarea>
            <button id="submitComment" class="btn btn-primary mt-2">Submit</button>
            <div id="message" class="mt-2"></div>
        </div>
  """;
  if (user != null) {
    return html;
  } else {
    return "Sign in or create an account to leave a comment.";
  }
}
