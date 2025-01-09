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
      <header class="d-flex p-1 justify-content-between align-items-center w-100 bg-primary sticky-top">
          <div>
              <a href = "login.cfm" class = "text-light text-decoration-none">
                <img src="./assets/images/grocery-cart.png" class = "py-2" alt="" width="25">
                <span>SHOPPING CART</span>    
              </a>  
          </div>
          <div class="ms-auto d-flex ">
            <a class="btn text-light" href="">
              Sign Up
              <img src="./assets/images/user.png" alt="" width="18" height="18" class="">
            </a>
          </div>
      </header>
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
            <cfquery name ="local.queryUserLogin">
              SELECT 
                  fldEmail,
                  fldPhone,
                  fldRoleId,
                  fldHashedPassword,
                  fldUserSaltString
              FROM 
                  tblUser 
              WHERE(
                  fldEmail = <cfqueryparam value = "#form.userInput#" cfsqltype="CF_SQL_VARCHAR"> 
              OR
                  fldPhone = <cfqueryparam value = "#form.userInput#" cfsqltype="CF_SQL_VARCHAR">)
              AND  
                  fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">       
            </cfquery>
            <cfif queryRecordCount(local.queryUserLogin)>
              <cfif local.queryUserLogin.fldHashedPassword EQ hash(form.password & local.queryUserLogin.fldUserSaltString, "SHA-512")>
                User Login Successfull
                <cfset session.isLoggedIn = true>
                <cfset session.userInput = form.userInput>
                <cfset session.roleId = local.queryUserLogin.fldRoleId>
                <!---<cflocation  url = "Home.cfm" addToken="no">   --->
              <cfelse>
                Invalid password
              </cfif>
            <cfelse>
              User name doesn't exist
            </cfif>
          </cfif>
          <div class="text-center">
            Don't have a account <a href="" class="text-decoration-none ">Register here</a>
          </div>
        </div>
      </main>
      <script src="assets/js/script.js"></script>
    </body>
</html>






