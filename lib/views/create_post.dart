String createPostView({String cent = ''}) {
  return '''
    <html>
    <head>
        <title>Create a post</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <style>
            body {
                font-family: Arial, sans-serif;
            }
            .form-container {
                width: 50%;
                margin: auto;
                padding: 20px;
                border: 1px solid #ccc;
                border-radius: 5px;
                background-color: #f8f8f8;
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
            }
            .form-group input, 
            .form-group textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 3px;
            }
            .error-message {
                color: red;
                display: none;
            }
        </style>
    </head>
    <body>
    <div class="form-container">
        <h2>Create a post</h2>
        <form id="myForm">
            <div class="form-group">
                <label for="title">Title</label>
                <input type="text" id="title" name="title">
            </div>
            <div class="form-group">
                <label for="body">Body</label>
                <textarea id="body" name="body"></textarea>
            </div>
             
            <div class="form-group">
                <label for="cent">Cent</label>
                <input type="text" id="cent" name="cent" value="$cent">
            </div>
            <div class="form-group">
                <label for="url">URL</label>
                <input type="url" id="url" name="url">
            </div>
            <button type="submit">Submit</button>
            <div id="errorMessage" class="error-message"></div>
        </form>
    </div>
    
    <script>
            \$(document).ready(function(){
                \$("#myForm").on('submit', function(e) {
                    e.preventDefault();
    
                    var url = "/c/" + \$("#cent").val();
                    
                    \$.ajax({
                        type: "POST",
                        url: url,
                        data: \$(this).serialize(),
                        dataType: "json",
                        success: function(data) {
                            window.location.href = url;
                        },
                        error: function(xhr) {
                            var json = JSON.parse(xhr.responseText);
                            \$('#errorMessage').text(json.message).show();
                        }
                    });
                });
            });
        </script>
    </body>
    </html>
''';
}
