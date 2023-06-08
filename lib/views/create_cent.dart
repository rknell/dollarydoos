String createCentView() => """
<html>
<head>
    <title>Create a Subreddit</title>
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
        .form-group .description {
            font-size: 0.8em;
            color: #888;
        }
        .error-message {
            color: red;
            display: none;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Create a Subreddit</h2>
        <form id="myForm">
            <div class="form-group">
                <label for="displayName">Display Name</label>
                <input type="text" id="displayName" name="displayName">
                <div class="description">A user-friendly name for the sub.</div>
            </div>
            <div class="form-group">
                <label for="idName">ID Name</label>
                <input type="text" id="idName" name="idName" maxlength="20">
                <div class="description">The name in the URL, character limit is 20.</div>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description"></textarea>
                <div class="description">A description for users when they visit the sub to explain what it's about and the community guidelines.</div>
            </div>
            <button type="submit">Create</button>
            <div id="errorMessage" class="error-message"></div>
        </form>
    </div>

    <script>
        \$(document).ready(function(){
            \$("#myForm").on('submit', function(e) {
                e.preventDefault();
                
                \$.ajax({
                    type: "POST",
                    url: "/c",
                    data: \$(this).serialize(),
                    dataType: "json",
                    success: function(data) {
                        window.location.href = "/c/" + \$("#idName").val();
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
""";
