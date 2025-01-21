<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <cfif cgi.SCRIPT_NAME EQ "/login.cfm">
          <title>Log in to Shopping Cart</title>
        <cfelseif cgi.SCRIPT_NAME EQ "/signup.cfm"> 
          <title>Sign in</title>
        <cfelseif cgi.SCRIPT_NAME EQ "/category.cfm"> 
          <title>Categories</title>
          <title>Log in to Shopping Cart</title>
        <cfelseif cgi.SCRIPT_NAME EQ "/subCategory.cfm"> 
          <title>Sub Categories</title>
        <cfelseif cgi.SCRIPT_NAME EQ "/product.cfm"> 
          <title>Products</title>
        <cfelseif cgi.SCRIPT_NAME EQ "/home.cfm"> 
          <title>HOME</title>
        <cfelse>
          <title>SHOPPING CART</title>
        </cfif> 
        <link rel="stylesheet" href="assets/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/shoppingCart.css">
        <link href="assets/images/shopping-cart.png" rel="icon">
        <script src="assets/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery-3.7.1.min.js"></script>
    </head>
    <body>
      <header class="d-flex p-1 justify-content-between align-items-center w-100 bg-primary sticky-top">
          <div class="ms-2 me-4">
            <a href = "" class = "text-light text-decoration-none">
              <img src="./assets/images/grocery-cart.png" class = "py-2" alt="" width="25">
              <span>SHOPPING CART</span>    
            </a>  
          </div>
          <cfif structKeyExists(session, "roleId") AND session.roleId EQ 2>
            <div class="input-group w-50 my-2" >
              <input class="form-control border-end-0 border rounded-pill" placeholder="Search.." type="search" value="" id="searchInput">
              <span class="ms-2">
                  <button class="btn btn-outline-secondary bg-white border-start-0 border rounded-pill" type="button">
                      <i class="fa fa-search"></i>
                  </button>
              </span>
            </div>
          </cfif>

          <cfif structKeyExists(session, "roleId") AND session.roleId EQ 1>
            <div class="mx-2">
                <a class="btn text-light" href="">
                  <img src="./assets/images/user.png" alt="" width="18" height="18" class="">
                  ADMIN
                </a>
          <cfelse>
            <div class="mx-2">
                <a class="btn text-light" href="">
                  <img src="./assets/images/user.png" alt="" width="18" height="18" class="">
                  USER
                </a>
          </cfif>
              <cfif NOT (cgi.SCRIPT_NAME EQ "/login.cfm" OR cgi.SCRIPT_NAME EQ "/signup.cfm")>
                <a class="btn text-light" onClick="logOut()"> 
                  <img src="./assets/images/exit.png" alt="" width="18" height="18">
                  Logout
                </a>
              <cfelse>
                <a class="btn text-light" href = "login.cfm"> 
                  <img src="./assets/images/exit.png" alt="" width="18" height="18">
                  Login
                </a>
              </cfif>             
            </div>
      </header>
      <!---<cfif cgi.SCRIPT_NAME EQ "/home.cfm">  --->
      <cfif structKeyExists(session, "roleId") AND session.roleId EQ 2> 
        <cfoutput>
        <cfset local.getAllCategories = application.shoppingCart.fetchCategories()>   
        <!---         <cfdump  var="#local.getAllCategories#"> --->
        <nav class="navbar-expand-lg categoriesNavbar sticky-top bg-light">
          <div class="container-fluid">
            <div class="collapse navbar-collapse" id="">
              <ul class="navbar-nav justify-content-evenly w-100">
                <cfloop query="local.getAllCategories">
                  <!---  <cfdump  var="#getAllCategories.fldCategory_Id#"> --->
                  <li class="nav-item toggleContainer">
                    <a class="nav-link" href="" id="#local.getAllCategories.fldCategory_Id#" role="button">
                        #local.getAllCategories.fldCategoryName#
                    </a>
                    <ul class="dropdown-menu">
                      <cfset local.getAllSubCategories = application.shoppingCart.fetchSubCategories(categoryId =local.getAllCategories.fldCategory_Id)>
                        <!---    <cfdump  var="#local.getAllSubCategories#"> --->
                      <cfloop query="local.getAllSubCategories">
                        <li>
                          <a class="dropdown-item" >
                            #local.getAllSubCategories.fldSubCategoryName#
                          </a>
                        </li>
                      </cfloop>
                    </ul>
                  </li>
                </cfloop>
              </ul>
            </div>
          </div>
        </nav>
        </cfoutput>
      </cfif>

<!---       <cfdump  var="#cgi#"> 

looop 1 href href="userCategories.cfm?categoryId=#getCategories.categoryId[i]#"

looop 2 href="userSubCategories.cfm?subCategoryId=#getSubCategories.subCategoryId[i]#&subCategoryName=#getSubCategories.subCategoryName[i]#"
--->

