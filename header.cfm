<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <cfswitch expression = "#cgi.SCRIPT_NAME#">
          <cfcase value="/login.cfm">
            <title>Log in | Shopping Cart</title>
          </cfcase>

          <cfcase value="/signup.cfm">
            <title>Sign in | ShoppingCart</title>
          </cfcase>

          <cfcase value="/admin/category.cfm">
              <title>Admin Dashboard | Categories</title>
          </cfcase>

          <cfcase value="/admin/subCategory.cfm">
              <title>Admin Dashboard | Sub Categories</title>
          </cfcase>

          <cfcase value="/admin/product.cfm">
              <title>Admin Dashboard | Products</title>
          </cfcase>

          <cfcase value="/userCategory.cfm">
              <title>Categories | ShoppingCart</title>
          </cfcase>

          <cfcase value="/userSubcategory.cfm">
              <title>Sub Categories | ShoppingCart</title>
          </cfcase>

          <cfcase value="/userProduct.cfm">
              <title>Products | ShoppingCart</title>
          </cfcase>

          <cfcase value="/cart.cfm">
              <title>Cart | ShoppingCart</title>
          </cfcase>

          <cfcase value="/order.cfm">
              <title>Checkout | ShoppingCart</title>
          </cfcase>

          <cfcase value="/orderdetails.cfm">
              <title>All Previous Orders | ShoppingCart</title>
          </cfcase>

          <cfcase value="/profile.cfm">
              <title>My Profile | ShoppingCart</title>
          </cfcase>

          <cfcase value="/searchResults.cfm">
              <title>Search Results | ShoppingCart</title>
          </cfcase>

          <cfcase value="/home.cfm">
            <title>Home | ShoppingCart</title>
          </cfcase>

          <cfdefaultcase>
            <title>SHOPPING CART</title>
          </cfdefaultcase>
        </cfswitch>
        <link rel="stylesheet" href="/assets/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/bootstrap-5.3.3-dist/js/bootstrap.bundle.js">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="/assets/css/shoppingCart.css">
        <link rel="stylesheet" href="/assets/css/alertify.min.css">
        <link href="/assets/images/shopping-cart.png" rel="icon">
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
        <script src="/assets/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
        <script src="/assets/js/jquery-3.7.1.min.js"></script>
        <script src="/assets/js/alertify.min.js"></script>
    </head>
    <body class = "overflow-x-hidden">
      <cfoutput>
        <header class="d-flex p-1 justify-content-between align-items-center w-100 bg-primary sticky-top">
            <div class="ms-2 me-4">
              <a href = "/home.cfm" class = "text-light text-decoration-none">
                <img src="/assets/images/grocery-cart.png" class = "py-2" alt="" width="25">
                <span>SHOPPING CART</span>    
              </a>  
            </div>
            <cfset local.nonNavBarPages = ["/admin/category.cfm","/admin/subCategory.cfm","/admin/product.cfm","/login.cfm","/signup.cfm"]>
            <cfif arrayContains(local.nonNavBarPages, cgi.SCRIPT_NAME)>
              <!---  SEARCH BAR EXCLUDED FOR ADMIN DASHBOARD ,LOGIN ,SIGNUP PAGES  --->
            <cfelse>
              <!--- SEARCH BAR--->
              <form action="/searchResults.cfm" method="get" class="searchInputDiv"> 
                <div class="input-group my-2 " >  
                  <input class="form-control border-end-0 border rounded-pill" placeholder="Search for Products,Brands and More" type="search" id="searchInput" name="s">
                  <span class="ms-2">
                    <button class="btn btn-outline-secondary bg-white border-start-0 border rounded-pill" type="submit">
                      <i class="fa fa-search"></i>
                    </button>
                  </span>
                </div>
              </form>  
            </cfif>
            <cfif structKeyExists(session, "roleId") AND structKeyExists(session, "isLoggedIn")>
              <cfif session.roleId EQ 1 AND session.isLoggedIn EQ true>
                <!-- ADMIN UI -->
                <div class="mx-2">
                  <a href = "/cart.cfm">
                    <button type="button" class="btn btn-primary position-relative">
                      CART
                      <i class="bi bi-cart4"></i>
                      <cfif structKeyExists(session, "cartCount")>
                          <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id = "cartCount">
                            #session.cartCount# 
                          </span>
                      </cfif>
                    </button>
                  </a>
                  <span class="fw-semibold text-light">Hello #session.firstName#!</span>
                  <a class="btn text-light" href="/profile.cfm">
                    <img src="/assets/images/user.png" alt="" width="18" height="18" class="">
                  </a>
                  <a class="btn text-light" href="/admin/category.cfm">
                    ADMIN
                  </a>
                  <a class="btn text-light" onClick="logOut()"> 
                    <img src="/assets/images/exit.png" alt="" width="18" height="18">
                    Logout
                  </a>          
                </div>
              <cfelseif session.roleId EQ 2 AND session.isLoggedIn EQ true>
                <!-- LOGGED IN USER UI-->
                <div class="mx-2">
                  <a href = "/cart.cfm">
                    <button type="button" class="btn btn-primary position-relative">
                      CART
                      <i class="bi bi-cart4"></i>
                      <cfif structKeyExists(session, "cartCount")>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id = "cartCount">
                          #session.cartCount# 
                        </span>
                      </cfif>
                    </button>
                  </a>
                  <a class="btn text-light" href= "/profile.cfm">
                    <img src="/assets/images/user.png" alt="" width="18" height="18" class="">
                    <span class="fw-semibold text-light">#session.firstName#</span>
                  </a>
                  <a class="btn text-light" onClick="logOut()"> 
                    <img src="/assets/images/exit.png" alt="" width="18" height="18">
                    Logout
                  </a>          
                </div>
              </cfif>
            <cfelse>
              <!-- NOT LOGGED IN USER UI -->
              <div class="mx-2">
                <a href = "/cart.cfm">
                  <button type="button" class="btn btn-primary position-relative">
                    CART
                    <i class="bi bi-cart4"></i>
                  </button>
                </a>
                <a class="btn text-light" href="/signup.cfm">
                  <img src="/assets/images/user.png" alt="" width="18" height="18" class="">
                  <span class="fw-semibold text-light">Hello, <span class="fw-bold text-white">Sign in</span></span>
                </a>
                <a class="btn text-light" href = "/login.cfm"> 
                  <img src="/assets/images/exit.png" alt="" width="18" height="18">
                  Login
                </a>        
              </div>
            </cfif> 
        </header>
        <cfif arrayContains(local.nonNavBarPages, cgi.SCRIPT_NAME)>
          <!---  NAV BAR EXCLUDED FOR ADMIN DASHBOARD ,LOGIN ,SIGNUP PAGES  --->
        <cfelse>
          <!---  NAV BAR  --->
          <cfif NOT structKeyExists(application, "cachedSubCategories")>
            <cflock name="cacheDataLock" type="exclusive" timeout="10">
              <cfif NOT structKeyExists(application, "cachedSubCategories")>
                <cfset application.cachedSubCategories = application.shoppingCart.fetchSubCategories()>
              </cfif>
            </cflock>
          </cfif>
          <!--- <cfset variables.getFromCache = true>
          <cfset variables.getAllSubCategories = application.shoppingCart.fetchSubCategories(getFromCache = variables.getFromCache)> --->
          <cfset variables.getAllSubCategories = application.cachedSubCategories> 
          <cfset variables.subCategoryStruct = structNew()>
          <!---storing all subcategories in a struct to skip database call inside loop --->
          <cfloop array="#variables.getAllSubCategories#" item="local.item">
              <cfset variables.categoryId = local.item.categoryId>
              <cfif NOT structKeyExists(variables.subCategoryStruct, variables.categoryId)>
                  <cfset variables.subCategoryStruct[variables.categoryId] = {
                    "categoryName" = local.item.categoryName,
                    "subCategories" = []
                }>
              </cfif>
              <cfif structKeyExists(local.item, "subCategoryId")>
                <cfset arrayAppend(variables.subCategoryStruct[variables.categoryId].subCategories, {
                    "subCategoryId" = local.item.subCategoryId,
                    "subCategoryName" = local.item.subCategoryName
                })>
            </cfif>
          </cfloop>

          <nav class="navbar-expand-lg bg-light">
            <div class="container-fluid">
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav justify-content-evenly w-100">
                        <cfloop collection="#variables.subCategoryStruct#" item="categoryId">
                            <cfset variables.encryptedCategoryId = encrypt("#categoryId#", application.key, "AES", "Base64")>
                            <cfset variables.encodedCategoryId = encodeForURL(variables.encryptedCategoryId)>
                            <li class="nav-item toggleContainer">
                                <a class="nav-link linkTxt" href="userCategory.cfm?categoryId=#variables.encodedCategoryId#">
                                    #variables.subCategoryStruct[categoryId].categoryName#
                                </a>
                                <ul class="dropdown-menu">
                                    <cfloop array="#variables.subCategoryStruct[categoryId].subCategories#" item="subItem">
                                        <cfset variables.encryptedSubCategoryId = encrypt("#subItem.subCategoryId#", application.key, "AES", "Base64")>
                                        <cfset variables.encodedSubCategoryId = encodeForURL(variables.encryptedSubCategoryId)>
                                        <li>
                                            <a class="dropdown-item linkTxt" href="userSubCategory.cfm?subCategoryId=#variables.encodedSubCategoryId#">
                                                #subItem.subCategoryName#
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

