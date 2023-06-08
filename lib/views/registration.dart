String registationView() {
  return """
  <!DOCTYPE html>
<html>
<head>
    <title>Login and Signup Form</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <style>
        .form-container {
            max-width: 300px;
            margin: 0 auto;
            padding-top: 100px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <form id="loginForm">
            <h2 class="text-center">Login</h2>
            <div class="form-group">
                <input type="text" class="form-control" id="loginUsername" placeholder="Username" required>
            </div>
            <div class="form-group">
                <input type="password" class="form-control" id="loginPassword" placeholder="Password" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Login</button>
            <div class="text-center">
                <a href="#" id="signupLink">Don't have an account? Signup</a>
            </div>
        </form>

        <form id="signupForm" style="display: none;">
            <h2 class="text-center">Signup</h2>
            <div class="form-group">
                <input type="text" class="form-control" id="signupUsername" placeholder="Username" required>
            </div>
            <div class="form-group">
                <input type="password" class="form-control" id="signupPassword" placeholder="Password" required>
            </div>
            <div class="form-group">
                <input type="email" class="form-control" id="signupEmail" placeholder="Email" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Signup</button>
            <div class="text-center">
                <a href="#" id="loginLink">Already have an account? Login</a>
            </div>
        </form>
    </div>

    <script>
        \$("#signupLink").click(function() {
            \$("#loginForm").hide();
            \$("#signupForm").show();
        });

        \$("#loginLink").click(function() {
            \$("#signupForm").hide();
            \$("#loginForm").show();
        });

        \$("#loginForm").submit(function(e) {
            e.preventDefault();
            var username = \$("#loginUsername").val();
            var password = \$("#loginPassword").val();

            \$.ajax({
                type: "POST",
                url: "/account/login",
                data: JSON.stringify({username: username, password: password}),
                contentType: "application/json; charset=utf-8",
                success: function() {
                    window.location.href = "/";
                }
            });
        });

        \$("#signupForm").submit(function(e) {
            e.preventDefault();
            var username = \$("#signupUsername").val();
            var password = \$("#signupPassword").val();
            var email = \$("#signupEmail").val();

            \$.ajax({
                type: "POST",
                url: "/account/create",
                data: JSON.stringify({username: username, password: password, email: email}),
                contentType: "application/json; charset=utf-8",
                success: function() {
                    window.location.href = "/";
                }
            });
        });
    </script>
</body>
</html>
  """;
}
