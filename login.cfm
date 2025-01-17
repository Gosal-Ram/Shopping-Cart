<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Log in to Shopping Cart</title>
        <link rel="stylesheet" href="assets/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link href="assets/images/shopping-cart.png" rel="icon">
        <script src="assets/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery-3.7.1.min.js"></script>
    </head>
    <body>
      <cfinclude  template="header.cfm">
      <main>
        <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow-lg">
          <h3 class= "text-center">Admin Login</h3>
          <form class="d-flex flex-column my-5" method="POST" onsubmit = "return loginValidate()">
            <input type="text" name="userInput" id="userInput" class="form-control my-3 p-2" placeholder="Email address or phone number ">
            <span class="text-danger " id="userInputError"></span>
            <input type="password" name="password" id="password" class="form-control my-3 p-2" placeholder="Password">
            <span class="text-danger " id="passwordError"></span>
            <input type="submit" name="submitBtn"  class="btn btn-primary rounded mt-4" value = "Log in">
          </form>
          <cfif structKeyExists(form,"submitBtn")>   
            <cfset loginResult = application.shoppingCart.logIn(form.userInput,form.password)>
            <cfoutput>
                <span>
                  #loginResult#
                </span>
            </cfoutput>
          </cfif>
          <div class="text-center">
            Didn't have a account <a href="" class="text-decoration-none ">Register here</a>
          </div>
        </div>
      </main>
      <script src="assets/js/login.js"></script>
    </body>
</html>






