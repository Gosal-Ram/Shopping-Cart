<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <cfif cgi.SCRIPT_NAME EQ "/login.cfm">
          <title>Log in to Shopping Cart</title>
        <cfelseif cgi.SCRIPT_NAME EQ "/category.cfm"> 
          <title>Categories</title>
          <title>Log in to Shopping Cart</title>
        <cfelseif cgi.SCRIPT_NAME EQ "/subCategory.cfm"> 
          <title>Sub Categories</title>
        <cfelseif cgi.SCRIPT_NAME EQ "/product.cfm"> 
          <title>Products</title>
        <cfelse>
          <title>SHOPPING CART</title>
        </cfif> 
        <link rel="stylesheet" href="assets/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link href="assets/images/shopping-cart.png" rel="icon">
        <script src="assets/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery-3.7.1.min.js"></script>
    </head>
    <body>
      <header class="d-flex p-1 justify-content-between align-items-center w-100 bg-primary sticky-top">
          <div>
              <a href = "" class = "text-light text-decoration-none">
                <img src="./assets/images/grocery-cart.png" class = "py-2" alt="" width="25">
                <span>SHOPPING CART</span>    
              </a>  
          </div>
          <div class="ms-auto d-flex ">
            <a class="btn text-light" href="">
              <img src="./assets/images/user.png" alt="" width="18" height="18" class="">
              ADMIN
            </a>
          </div>
          <cfif NOT cgi.SCRIPT_NAME EQ "/login.cfm">
            <div class="loginCont">
              <a class="btn text-light" onClick="logOut()"> 
                <img src="./assets/images/exit.png" alt="" width="18" height="18">
                Logout
              </a>
            </div>
          </cfif>
      </header>

<!---       <cfdump  var="#cgi#"> --->
