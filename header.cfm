<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <cfswitch expression = "#cgi.SCRIPT_NAME#">
          <cfcase value="/login.cfm">
            <title>Log in to Shopping Cart</title>
          </cfcase>
          <cfcase value="/signup.cfm">
            <title>Sign in</title>
          </cfcase>
          <cfcase value="/category.cfm">
            <title>Categories</title>
          </cfcase>
          <cfcase value="/subCategory.cfm">
            <title>Sub Categories</title>
          </cfcase>
          <cfcase value="/product.cfm">
            <title>Products</title>
          </cfcase>
          <cfcase value="/home.cfm">
            <title>HOME</title>
          </cfcase>
          <cfdefaultcase>
            <title>SHOPPING CART</title>
          </cfdefaultcase>
        </cfswitch>

        <link rel="stylesheet" href="assets/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/bootstrap-5.3.3-dist/js/bootstrap.bundle.js">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="assets/css/shoppingCart.css">
        <link href="assets/images/shopping-cart.png" rel="icon">
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
        <script src="assets/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery-3.7.1.min.js"></script>
    </head>
    <body class = "overflow-x-hidden">
      <cfoutput>
        <header class="d-flex p-1 justify-content-between align-items-center w-100 bg-primary sticky-top z-index-1">
            <div class="ms-2 me-4">
              <a href = "home.cfm" class = "text-light text-decoration-none">
                <img src="./assets/images/grocery-cart.png" class = "py-2" alt="" width="25">
                <span>SHOPPING CART</span>    
              </a>  
            </div>
            <cfset local.nonNavBarPages = ["/category.cfm","/subCategory.cfm","/product.cfm","/login.cfm","/signup.cfm"]>
            <cfif arrayContains(local.nonNavBarPages, cgi.SCRIPT_NAME)>
              <!---  SEARCH BAR EXCLUDED  --->
            <cfelse>
              <!--- SEARCH BAR--->
              <form action="searchResults.cfm" method="get" class="searchInputDiv"> 
                <div class="input-group my-2 " >  
                  <input class="form-control border-end-0 border rounded-pill" 
                        placeholder="Search.." 
                        type="search" 
                        value="" 
                        id="searchInput"
                        name="s">
                  <span class="ms-2">
                    <button class="btn btn-outline-secondary bg-white border-start-0 border rounded-pill" type="submit">
                      <i class="fa fa-search"></i>
                    </button>
                  </span>
                </div>
              </form>  
            </cfif>
            <cfif structKeyExists(session, "roleId") AND structKeyExists(session, "isLoggedIn")>
              <cfset variables.getUserCartDetails = application.shoppingCart.addToCart(userId = session.userId)>
              <cfset variables.userCartCount = variables.getUserCartDetails.cartItemsCount> 
              <!---               <cfdump  var="#variables.userCartCount#"> --->
              <cfif session.roleId EQ 1 AND session.isLoggedIn EQ true>
                <!-- ADMIN -->
                <div class="mx-2">
                  <span class="fw-semibold text-light">Hello #session.firstName#!</span>
                    <a class="btn text-light" href="category.cfm">
                      <img src="./assets/images/user.png" alt="" width="18" height="18" class="">
                      ADMIN
                    </a>
                    <a class="btn text-light" onClick="logOut()"> 
                      <img src="./assets/images/exit.png" alt="" width="18" height="18">
                      Logout
                    </a>          
                </div>
              <cfelseif session.roleId EQ 2 AND session.isLoggedIn EQ true>
                <!-- USER LOGGED IN -->
                <div class="mx-2">
                  <button type="button" class="btn btn-primary position-relative">
                    CART
                    <i class="bi bi-cart4"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                      #variables.userCartCount# 
                      <span class="visually-hidden">unread messages</span>
                    </span>
                  </button>

                    <a class="btn text-light" href="home.cfm">
                      <img src="./assets/images/user.png" alt="" width="18" height="18" class="">
                      <span class="fw-semibold text-light">Hello #session.firstName# !</span>
                    </a>
                    
                    <a class="btn text-light" onClick="logOut()"> 
                      <img src="./assets/images/exit.png" alt="" width="18" height="18">
                      Logout
                    </a>          
                </div>
              </cfif>
            <cfelse>
                <div class="mx-2">
                  <!-- USER NOT LOGGED IN -->
                    <a class="btn text-light" href="signup.cfm">
                      <img src="./assets/images/user.png" alt="" width="18" height="18" class="">
                      <span class="fw-semibold text-light">Hello, <span class="fw-bold text-white">Sign in</span></span>
                    </a>
                    <a class="btn text-light" href = "login.cfm"> 
                      <img src="./assets/images/exit.png" alt="" width="18" height="18">
                      Login
                    </a>        
                </div>
            </cfif> 
        </header>
        <cfif arrayContains(local.nonNavBarPages, cgi.SCRIPT_NAME)>
          <!---  NAV BAR EXCLUDED  --->
        <cfelse>
          <!---  NAV BAR  --->
          <cfset variables.getAllCategories = application.shoppingCart.fetchCategories()>
          <cfset variables.key = generateSecretKey("AES")>
          <nav class="navbar-expand-lg bg-light">
            <div class="container-fluid">
              <div class="collapse navbar-collapse">
                <ul class="navbar-nav justify-content-evenly w-100">
                  <cfloop array="#variables.getAllCategories#" item="item">
                    <cfset variables.encryptedCategoryId = encrypt("#item.categoryId#",application.key,"AES","Base64")>
                    <cfset variables.encodedCategoryId = encodeForURL(variables.encryptedCategoryId)>
                    <li class="nav-item toggleContainer">
                      <a class="nav-link" href="userCategory.cfm?categoryId=#variables.encodedCategoryId#" id="#item.categoryId#" role="button">
                          #item.categoryName#
                      </a>
                      <ul class="dropdown-menu">
                        <cfset variables.getAllSubCategories = application.shoppingCart.fetchSubCategories(categoryId ="#item.categoryId#")>
                        <cfloop array="#variables.getAllSubCategories#" item="item">
                            <cfset variables.encryptedSubCategoryId = encrypt("#item.subCategoryId#",application.key,"AES","Base64")>
                            <cfset variables.encodedSubCategoryId = encodeForURL(variables.encryptedSubCategoryId)>
                          <li>
                            <a class="dropdown-item" href = "userSubCategory.cfm?subCategoryId=#encodedSubCategoryId#" >
                              #item.subCategoryName#
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
        </cfif>
      </cfoutput>

