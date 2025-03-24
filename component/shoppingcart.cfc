<cfcomponent>
    <!--- COMMON--->
    <cffunction  name="logIn" access = "public" returnType="string" >
        <cfargument name ="userInput" type="string" required ="true">
        <cfargument name ="password" type="string" required = "true">
        <cfargument name ="productId" type="string" required = "false">
        <cfargument name ="buyNow" type="integer" required = "false">

        <cfset isAdmin = structKeyExists(session, "admin") AND structKeyExists(session.admin, "isLoggedIn") AND session.admin.isLoggedIn>
        <cfset isUser = structKeyExists(session, "user") AND structKeyExists(session.user, "isLoggedIn") AND session.user.isLoggedIn>
        <cfif isAdmin>
            <cfset userData = session.admin>
        <cfelseif isUser>
            <cfset userData = session.user>
        </cfif>

        <cfset local.loginResult = "">
        <cfquery name ="local.queryUserLogin">
            SELECT 
                fldUser_Id,
                fldFirstName,
                fldLastName,
                fldEmail,
                fldPhone,
                fldRoleId,
                fldHashedPassword,
                fldUserSaltString
            FROM 
                tblUser 
            WHERE(
                fldEmail = <cfqueryparam value = "#arguments.userInput#" cfsqltype="VARCHAR"> 
                OR fldPhone = <cfqueryparam value = "#arguments.userInput#" cfsqltype="VARCHAR">)
                AND fldActive = 1       
        </cfquery>
        <!---Validation--->
        <cfif len(trim(arguments.userInput)) EQ 0 OR len(trim(arguments.password)) EQ 0>
            <cfset local.loginResult = "Please provide both username/email and password.">
        <cfelseif local.queryUserLogin.recordcount GT 0>
        <!--- if username exists--->
            <cfif local.queryUserLogin.fldHashedPassword EQ hash(arguments.password & local.queryUserLogin.fldUserSaltString, "SHA-512")>
                <cfset local.loginResult = "User Login Successful">

                <cfif local.queryUserLogin.fldRoleId EQ 1>
                    <!--- Admin Login ---> 
                    <cfset session.admin.isLoggedIn = true>
                    <cfset session.admin.firstName = local.queryUserLogin.fldFirstName>
                    <cfset session.admin.lastName = local.queryUserLogin.fldLastName>
                    <cfset session.admin.email = local.queryUserLogin.fldEmail>
                    <cfset session.admin.phone = local.queryUserLogin.fldPhone>
                    <cfset session.admin.userId = local.queryUserLogin.fldUser_Id>
                    <cfset session.admin.roleId = local.queryUserLogin.fldRoleId>
                <cfelse>
                    <!--- Regular User Login ---> 
                    <cfset session.user.isLoggedIn = true>
                    <cfset session.user.firstName = local.queryUserLogin.fldFirstName>
                    <cfset session.user.lastName = local.queryUserLogin.fldLastName>
                    <cfset session.user.email = local.queryUserLogin.fldEmail>
                    <cfset session.user.phone = local.queryUserLogin.fldPhone>
                    <cfset session.user.userId = local.queryUserLogin.fldUser_Id>
                    <cfset session.user.roleId = local.queryUserLogin.fldRoleId>
                </cfif>
                <cfif structKeyExists(arguments, "productId")>
                    <!--- to add product to the cart of a not logged in user(after logging in)--->
                    <cfset local.productId = decrypt(arguments.productId,application.key,"AES","Base64")>
                    <cfset local.CartResult = addToCart(local.productId)>
                    <cfif structKeyExists(arguments, "buyNow")>
                        <!--- to order a product of a  not logged in user(after logging in)--->
                        <cfset local.encodedCartId = local.CartResult.cartId>
                        <cfset local.quantityCount = local.CartResult.quantity>
                        <cfset local.encodedProductId = encodeForURL(arguments.productId)>
                        <cflocation  url="order.cfm?productId=#local.encodedProductId#&cartId=#local.encodedCartId#" addToken="no">
                    </cfif>
                    <cflocation  url="/cart.cfm" addtoken = "no">
                    <!---return msg for debugging purpose--->
                    <!---<cfset local.loginResult &= local.CartResult.resultMsg > --->
                </cfif>
                <!--- updating cart count for header display purpose--->
                <cfset session.cartCount = getUserCartCount()>
                <!---redirecting user based on roleId--->
                <cfif local.queryUserLogin.fldRoleId EQ 1>
                    <cflocation url = "/admin/category.cfm" addToken="no">
                <cfelse>
                    <cflocation url = "/home.cfm" addToken="no">   
                </cfif>
            <cfelse>
                <cfset local.loginResult = "Your email and password do not match.">
            </cfif>
        <cfelse>
            <cfset local.loginResult = "User name doesn't exist">
        </cfif>
        <cfreturn local.loginResult>
    </cffunction>   

    <cffunction  name="logOut" access="remote" returnType = "void" >
        <cfset isAdmin = structKeyExists(session, "admin") AND structKeyExists(session.admin, "isLoggedIn") AND session.admin.isLoggedIn>
        <cfset isUser = structKeyExists(session, "user") AND structKeyExists(session.user, "isLoggedIn") AND session.user.isLoggedIn>
        <cfif isAdmin>
            <cfset userData = session.admin>
        <cfelseif isUser>
            <cfset userData = session.user>
        </cfif>
        <cfif isAdmin>
            <cfset structClear(session.admin)>
        <cfelseif isUser>
            <cfset structClear(session.user)>
        </cfif>
    </cffunction>
 
    <cffunction  name="signUp" access = "public" returnType="string" >
         <cfargument name="firstName" type="string" required="yes">
         <cfargument name="lastName" type="string" required="yes">
         <cfargument name="emailId" type="string" required="yes">
         <cfargument name="pwd1" type="string" required="yes">
         <cfargument name="pwd2" type="string" required="yes">
         <cfargument name="phone" type="string" required="yes">
 
         <!---Validation--->
         <cfset local.signUpResult = "">
         <cfif len(trim(arguments.firstName)) EQ 0>
             <cfset local.signUpResult = "First Name is required.">
         </cfif>
         <cfif len(trim(arguments.lastName)) EQ 0>
             <cfset local.signUpResult = "Last Name is required.">
         </cfif>
         <cfif isValid("email", arguments.emailId) EQ  0>
             <cfset local.signUpResult = "Enter a valid Email ID.">
         </cfif> 
         <cfif arguments.pwd1 NEQ arguments.pwd2>
             <cfset local.signUpResult = "Passwords do not match.">
         </cfif>
         <cfif NOT isNumeric(arguments.phone) OR len(trim(arguments.phone)) NEQ 10 >
             <cfset local.signUpResult = "Enter a valid 10-digit phone number.">
         </cfif>
         <cfquery name ="local.queryUserUniqueCheck">
             SELECT 
                 fldEmail,
                 fldPhone
             FROM 
                 tblUser 
             WHERE(
                 fldEmail = <cfqueryparam value = "#arguments.emailId#" cfsqltype="VARCHAR"> 
                 OR fldPhone = <cfqueryparam value = "#arguments.phone#" cfsqltype="VARCHAR">)
                 AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">       
         </cfquery>
 
         <cfif local.queryUserUniqueCheck.recordcount GT 0>
             <cfset local.signUpResult = "User mail or phone already exists">
         </cfif>
 
         <cfif len(trim(local.signUpResult)) GT 0>
             <cfreturn local.signUpResult>
         <cfelse>
             <cfset local.saltString = generateSecretKey("AES")>
             <cfset local.hashedPassword = hash(arguments.pwd1 & local.saltString, "SHA-512")>
             <cfquery name ="local.queryInsertUserDetails" datasource = "ShoppingCart">
                 INSERT INTO 
                     tblUser(fldFirstName,
                             fldLastName,
                             fldEmail,
                             fldPhone,
                             fldRoleId,
                             fldHashedPassword,
                             fldUserSaltString)
                 VALUES(
                     <cfqueryparam value = "#arguments.firstName#" cfsqltype = "VARCHAR">,
                     <cfqueryparam value = "#arguments.lastName#" cfsqltype = "VARCHAR">,
                     <cfqueryparam value = "#arguments.emailId#" cfsqltype = "VARCHAR">,
                     <cfqueryparam value = "#arguments.phone#" cfsqltype = "VARCHAR">,
                     <cfqueryparam value = "2" cfsqltype = "INTEGER">,
                     <cfqueryparam value = "#local.hashedPassword#" cfsqltype = "VARCHAR">,
                     <cfqueryparam value = "#local.saltString#" cfsqltype = "VARCHAR">
                 )
             </cfquery>
             <cfset local.signUpResult = "New User created Successfully">
         </cfif>
         <cfreturn local.signUpResult>
    </cffunction>

    <cffunction name="fetchCategories" access="public" returnType="array">
        <cfargument name="categoryId" type="integer" required="false">
        
        <cfquery name="local.queryGetCategories">
            SELECT 
                fldCategoryName,
                fldCategory_Id
            FROM 
                tblcategory
            WHERE 
                fldActive = 1
                <cfif structKeyExists(arguments, "categoryId") AND val(arguments.categoryId)>
                    AND fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                </cfif>
        </cfquery>
        <cfset local.categoriesArray = []>
        <cfloop query="local.queryGetCategories">
            <cfset local.category = {
                "categoryName" = local.queryGetCategories.fldCategoryName,
                "categoryId" = local.queryGetCategories.fldCategory_Id
            }>
            <cfset arrayAppend(local.categoriesArray, local.category)>
        </cfloop>
        <cfreturn local.categoriesArray>
    </cffunction>

    <cffunction name="fetchSubCategories" access="remote" returnFormat="JSON" returnType="array">
        <cfargument name="categoryId" type="integer" required="false">
        <cfargument name="subCategoryId" type="integer" required="false">
        <cfargument name="getFromCache" type="boolean" required="false" default = "true">
        
        <cfquery name="local.queryGetSubCategories"  
         cachedWithin = "#(arguments.getFromCache EQ true ? createTimespan(0, 1, 0, 0): createTimespan(0, 0, 0, 0))#">
            SELECT 
                SC.fldSubCategoryName,
                C.fldCategoryName,
                SC.fldSubCategory_Id,
                SC.fldCategoryId
            FROM 
                tblSubCategory SC
                INNER JOIN tblcategory C ON C.fldCategory_Id = SC.fldCategoryId
            WHERE 
                SC.fldActive = 1
                AND C.fldActive = 1
            <cfif structKeyExists(arguments, "subCategoryId") AND val(arguments.subCategoryId)>
                AND SC.fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "INTEGER">
            <cfelseif structKeyExists(arguments, "categoryId") AND val(arguments.categoryId)>
                AND SC.fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="INTEGER">
            </cfif>
        </cfquery>
        <cfset local.subCategoriesArray = []>
        <cfloop query="local.queryGetSubCategories">
            <cfset local.subCategory = {
                "subCategoryName" = local.queryGetSubCategories.fldSubCategoryName,
                "categoryName" = local.queryGetSubCategories.fldCategoryName,
                "subCategoryId" = local.queryGetSubCategories.fldSubCategory_Id,
                "categoryId" = local.queryGetSubCategories.fldCategoryId
            }>
            <cfset arrayAppend(local.subCategoriesArray, local.subCategory)>
        </cfloop>
        <cfreturn local.subCategoriesArray>
    </cffunction>

    <cffunction name="fetchProducts" access="remote" returnFormat="JSON" returnType="array">
        <cfargument name="subCategoryId" type="integer" required="false">
        <cfargument name="categoryId" type="integer" required="false">
        <cfargument name="sortFlag" type="integer" required="false">
        <cfargument name="filterMin" type="integer" required="false">
        <cfargument name="filterMax" type="integer" required="false">
        <cfargument name="searchInput" type="string" required="false">
        <cfargument name="random" type="integer" required="false">
        <cfargument name="productId" type="integer" required="false">
        <cfargument name="offset" type="integer" required="false">
        <cfargument name="limit" type="integer" required="false">
        <cfargument name="page" type="integer" required="false">

        <cfset local.priceDescendingOrder = "P.fldPrice DESC">
        <cfset local.priceAscendingOrder = "P.fldPrice ASC">
        <cfset local.productsAscendingOrder = "P.fldProductName ASC"> 
    
        <cfquery name="local.queryGetProducts">
            SELECT 
                P.fldProductName,
                P.fldProduct_Id,
                P.fldSubCategoryId,
                SC.fldSubCategoryName,
                C.fldCategory_Id,
                C.fldCategoryName,
                P.fldBrandId,
                P.fldDescription,
                P.fldPrice,
                P.fldTax,
                B.fldBrandName,
                GROUP_CONCAT(DISTINCT PI.fldImageFilename ORDER BY PI.fldDefaultImage DESC) AS fldAllImages
            FROM 
                tblproduct P      
                INNER JOIN tblbrands B ON P.fldBrandId = B.fldBrand_Id
                INNER JOIN tblsubcategory SC ON SC.fldSubCategory_Id = P.fldSubCategoryId
                INNER JOIN tblcategory C ON C.fldCategory_Id = SC.fldCategoryId
                INNER JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId 
            WHERE 
                P.fldActive = 1 
                AND PI.fldActive = 1
                <cfif structKeyExists(arguments, "productId") AND val(arguments.productId)>
                    AND P.fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="INTEGER">
                </cfif>
                <cfif structKeyExists(arguments, "subCategoryId") AND val(arguments.subCategoryId)>
                    AND P.fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="INTEGER">
                </cfif>
                <cfif structKeyExists(arguments, "categoryId") AND val(arguments.categoryId)>
                    AND C.fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="INTEGER">
                </cfif>
                <cfif structKeyExists(arguments, "searchInput") AND len(trim(arguments.searchInput))>
                    AND (P.fldProductName LIKE <cfqueryparam value="%#arguments.searchInput#%" cfsqltype="varchar">
                        OR P.fldDescription LIKE <cfqueryparam value="%#arguments.searchInput#%" cfsqltype="varchar">
                        OR B.fldBrandName LIKE <cfqueryparam value="%#arguments.searchInput#%" cfsqltype="varchar">)
                </cfif>
                <cfif structKeyExists(arguments, "filterMin")>
                    AND P.fldPrice >= <cfqueryparam value="#val(arguments.filterMin)#" cfsqltype="INTEGER">  
                </cfif>
                <cfif structKeyExists(arguments, "filterMax") AND val(arguments.filterMax)>
                    AND P.fldPrice <= <cfqueryparam value="#val(arguments.filterMax)#" cfsqltype="INTEGER">  
                </cfif>
            GROUP BY 
                P.fldProduct_Id
            ORDER BY
                <cfif (structKeyExists(arguments, "random") AND val(arguments.random) EQ 1)>
                    RAND()
                <cfelseif structKeyExists(arguments, "sortFlag")>
                    <cfif arguments.sortFlag EQ 2>  
                        #local.priceDescendingOrder# 
                    <cfelse>
                        #local.priceAscendingOrder#
                    </cfif>
                <cfelse>
                    #local.productsAscendingOrder#
                </cfif>
            LIMIT
                <cfif structKeyExists(arguments, "limit") AND val(arguments.limit)>
                    <cfqueryparam value="#arguments.limit#" cfsqltype="INTEGER">
                <cfelse>
                    10
                </cfif>
            OFFSET 
                <cfif structKeyExists(arguments, "offset") AND val(arguments.offset)>
                    <cfqueryparam value="#arguments.offset#" cfsqltype="INTEGER">
                <cfelseif structKeyExists(arguments, "page") AND val(arguments.page)>
                    <cfset local.offset = (arguments.page - 1) * 10>
                    #local.offset#
                <cfelse>
                    0
                </cfif>
        </cfquery>
    
        <cfset local.productsArray = []>
        <cfloop query="local.queryGetProducts">
            <cfset local.encryptedProductId = encrypt(local.queryGetProducts.fldProduct_Id, application.key, "AES", "Base64")>
            <cfset arrayAppend(local.productsArray, {
                "productName" = local.queryGetProducts.fldProductName,
                "subCategoryName" = local.queryGetProducts.fldSubCategoryName,
                "categoryName" = local.queryGetProducts.fldCategoryName,
                "productId" = local.encryptedProductId,
                "subCategoryId" = local.queryGetProducts.fldSubCategoryId,
                "categoryId" = local.queryGetProducts.fldCategory_Id,
                "brandId" = local.queryGetProducts.fldBrandId,
                "description" = local.queryGetProducts.fldDescription,
                "price" = local.queryGetProducts.fldPrice,
                "tax" = local.queryGetProducts.fldTax,
                "brandName" = local.queryGetProducts.fldBrandName,
                "imageFilenames" = listToArray(local.queryGetProducts.fldAllImages) 
            })>
        </cfloop>
    
        <cfreturn local.productsArray>
    </cffunction>
    
    <cffunction  name="getUserCartCount" access = "public" returnType = "numeric"> 
        <cfset isAdmin = structKeyExists(session, "admin") AND structKeyExists(session.admin, "isLoggedIn") AND session.admin.isLoggedIn>
        <cfset isUser = structKeyExists(session, "user") AND structKeyExists(session.user, "isLoggedIn") AND session.user.isLoggedIn>
        <cfif isAdmin>
            <cfset userData = session.admin>
        <cfelseif isUser>
            <cfset userData = session.user>
        </cfif>
        <cfquery name ="local.querygetCartCount">
            SELECT 
                fldProductId
            FROM 
                tblcart 
            WHERE
                fldUserId = <cfqueryparam value = "#userData.userId#" cfsqltype = "integer">     
        </cfquery>
        <cfreturn local.querygetCartCount.recordCount>
    </cffunction>

    <cffunction  name="addToCart" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name="productId" type="integer" required="false">
        
        <cfset local.addToCartResult = { "resultMsg" = "","cartId" = "", "quantity" = ""}>
        <cfif structKeyExists(arguments, "productId")>
            <!---  EXISTING PRODUCT IN CART CHECK  --->
            <cfquery name ="local.queryAddToCartNewProductCheck">
                SELECT 
                    fldQuantity,fldCart_Id
                FROM 
                    tblcart 
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldUserId = <cfqueryparam value = "#userData.userId#" cfsqltype = "integer">     
            </cfquery>
            <cfif local.queryAddToCartNewProductCheck.recordcount GT 0>
                <cfset local.updatedQuantity = local.queryAddToCartNewProductCheck.fldQuantity + 1>
                <cfset variables.encryptedCartId = encrypt("#local.queryAddToCartNewProductCheck.fldCart_Id#",application.key,"AES","Base64")>
                <cfset variables.encodedCartId = encodeForURL(variables.encryptedCartId)>
                <cfset local.addToCartResult["cartId"] = variables.encodedCartId>
                <!--- PRODUCT UPDATE--->
                <cfquery name ="local.queryUpdateCart">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = <cfqueryparam value = "#local.updatedQuantity#"  cfsqltype = "integer">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#userData.userId#" cfsqltype="integer"> 
                </cfquery>
                <cfset local.addToCartResult["resultMsg"] = "Cart Updated">
                <cfset local.addToCartResult["quantity"] = local.updatedQuantity>

            <cfelse>
                <!--- NEW PRODUCT ADD TO CART     --->
                <cfquery name ="local.queryAddToCart" result = "local.resultqueryAddToCart">
                    INSERT INTO 
                        tblcart(fldUserId,
                                fldProductId,
                                fldQuantity
                            )
                    VALUES(
                        <cfqueryparam value = "#userData.userId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                        <cfqueryparam value = "1" cfsqltype = "integer">
                    )
                </cfquery>
                <cfset local.addToCartResult["resultMsg"] = "Product added to the Cart">
                <cfset variables.encryptedCartId = encrypt("#local.resultqueryAddToCart.generated_Key#",application.key,"AES","Base64")>
                <cfset variables.encodedCartId = encodeForURL(variables.encryptedCartId)>
                <cfset local.addToCartResult["cartId"] = variables.encodedCartId>
                <cfset local.addToCartResult["quantity"] = 1>
            </cfif>
        </cfif>
        <!--- updating cart count for header display purpose--->
        <cfset session.cartCount = getUserCartCount() >
        <cfreturn local.addToCartResult>
    </cffunction> 

</cfcomponent>
