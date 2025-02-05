<cfcomponent>
    <!--- ADMIN DASHBOARD --->
    <cffunction  name="logIn" access = "public" returnType="string" >
        <cfargument name ="userInput" type="string" required ="true">
        <cfargument name ="password" type="string" required = "true">
        <cfargument name ="productId" type="string" required = "false">
        <cfargument name ="buyNow" type="string" required = "false">

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

        <cfif Len(Trim(arguments.userInput)) EQ 0 OR Len(Trim(arguments.password)) EQ 0>
            <cfset local.loginResult = "Please provide both username/email and password.">
        <cfelseif local.queryUserLogin.recordcount GT 0>
            <cfif local.queryUserLogin.fldHashedPassword EQ hash(arguments.password & local.queryUserLogin.fldUserSaltString, "SHA-512")>
                <cfset local.loginResult = "User Login Successful">
                <cfset session.isLoggedIn = true>
                <cfset session.firstName = local.queryUserLogin.fldFirstName>
                <cfset session.lastName = local.queryUserLogin.fldLastName>
                <cfset session.email = local.queryUserLogin.fldEmail>
                <cfset session.phone = local.queryUserLogin.fldPhone>
                <cfset session.userId = local.queryUserLogin.fldUser_Id>
                <cfset session.roleId = local.queryUserLogin.fldRoleId>
                <cfif structKeyExists(arguments, "productId")>
                    <cfset local.CartResult = addToCart(arguments.productId)>
                    <cfif structKeyExists(arguments, "buyNow")>
                        <cfset local.encodedCartId = local.CartResult.cartId>
                        <cfset local.quantityCount = local.CartResult.quantity>
                        <cfset local.encryptedProductId = encrypt("#arguments.productId#",application.key,"AES","Base64")>
                        <cfset local.encodedProductId = encodeForURL(local.encryptedProductId)>
                        <!--- <cflocation  url="order.cfm?productId=#local.encodedProductId#&cartId=#local.encodedCartId#&quantityCount=#local.quantityCount#">--->
                        <cflocation  url="order.cfm?productId=#local.encodedProductId#&cartId=#local.encodedCartId#">
                    </cfif>
                    <cflocation  url="cart.cfm"> 
                    <!---<cfset local.loginResult &= local.CartResult.resultMsg > --->
                </cfif>
                <cfset session.cartCount = getUserCartCount()>
                <cfif local.queryUserLogin.fldRoleId EQ 1>
                    <cflocation url = "category.cfm" addToken="no">
                <cfelse>
                    <cflocation url = "home.cfm" addToken="no">   
                </cfif>
            <cfelse>
                <cfset local.loginResult = "Invalid password">
            </cfif>
        <cfelse>
            <cfset local.loginResult = "User name doesn't exist">
        </cfif>
        <cfreturn local.loginResult>
    </cffunction>

    <cffunction name="fetchCategories" access="public" returnType="array">
        <cfargument name="categoryId" type="string" required="false">
        
        <cfquery name="local.queryGetCategories">
            SELECT 
                fldCategoryName,
                fldCategory_Id
            FROM 
                tblcategory
            WHERE 
                fldActive = 1
                <cfif structKeyExists(arguments, "categoryId") AND len(trim(arguments.categoryId)) NEQ 0>
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

    <cffunction  name="fetchBrands" access = "public" returnType="query">
        <cfquery name="local.queryGetBrands">
            SELECT 
                fldBrand_Id,
                fldBrandName
            FROM 
                tblbrands
            WHERE 
                fldActive = 1
        </cfquery> 
        <cfreturn local.queryGetBrands>
    </cffunction>

    <cffunction name="fetchSubCategories" access="remote" returnFormat="JSON" returnType="array">
        <cfargument name="categoryId" type="integer" required="false">
        <cfargument name="subCategoryId" type="integer" required="false">
        
        <cfquery name="local.queryGetSubCategories">
            SELECT 
                fldSubCategoryName,
                fldSubCategory_Id,
                fldCategoryId
            FROM 
                tblSubCategory
            WHERE 
                fldActive = 1 
            <cfif structKeyExists(arguments, "subCategoryId") AND Len(trim(arguments.subCategoryId)) GT 0 AND arguments.subCategoryId NEQ 0>
                AND fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "INTEGER">
            <cfelseif structKeyExists(arguments, "categoryId") AND Len(trim(arguments.categoryId)) GT 0 AND arguments.categoryId NEQ 0>
                AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="INTEGER">
            </cfif>
        </cfquery>

        <cfset local.subCategoriesArray = []>

        <cfloop query="local.queryGetSubCategories">
            <cfset local.subCategory = {
                "subCategoryName" = local.queryGetSubCategories.fldSubCategoryName,
                "subCategoryId" = local.queryGetSubCategories.fldSubCategory_Id,
                "categoryId" = local.queryGetSubCategories.fldCategoryId
            }>
            <cfset arrayAppend(local.subCategoriesArray, local.subCategory)>
        </cfloop>

        <cfreturn local.subCategoriesArray>
    </cffunction>

    <cffunction  name="fetchProducts" access = "remote" returnFormat = "JSON" returnType="query">
        <cfargument name="subCategoryId" type="string" required="false">
        <cfargument name="sortFlag" type="string" required="false">
        <cfargument name="filterMin" type="string" required="false">
        <cfargument name="filterMax" type="string" required="false">
        <cfargument name="searchInput" type="string" required="false">
        <cfargument name="random" type="string" required="false">
        <cfargument name="productId" type="string" required="false">
        <cfargument name="offset" type="string" required="false">
        <cfargument name="limit" type="numeric" required="false">

        <cfquery name="local.queryGetProducts">
            SELECT 
                p.fldProductName,
                p.fldProduct_Id,
                p.fldSubCategoryId,
                p.fldBrandId,
                p.fldDescription,
                p.fldPrice,
                p.fldTax,
                b.fldBrandName,
                pi.fldImageFilename
            FROM 
                tblproduct p      
                INNER JOIN tblbrands b ON p.fldBrandId = b.fldBrand_Id
                INNER JOIN tblproductimages pi ON p.fldProduct_Id = pi.fldProductId 
            WHERE 
                p.fldActive = 1 
                AND pi.fldDefaultImage = 1

            <cfif structKeyExists(arguments, "productId") AND Len(trim(arguments.productId)) GT 0 AND arguments.productId NEQ 0>
                AND fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "VARCHAR">
            </cfif>

            <cfif structKeyExists(arguments, "subCategoryId") AND  len(trim(arguments.subCategoryId)) GT 0 AND arguments.subCategoryId NEQ 0>
				AND p.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "VARCHAR">
			<cfelseif structKeyExists(arguments, "productId") AND  len(trim(arguments.productId)) GT 0 AND arguments.productId NEQ 0>
				AND p.fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
			</cfif>
            
            <cfif structKeyExists(arguments, "searchInput") AND len(trim(arguments.searchInput))>
                AND (p.fldProductName LIKE <cfqueryparam value = "%#arguments.searchInput#%" cfsqltype = "varchar">
                    OR p.fldDescription LIKE <cfqueryparam value = "%#arguments.searchInput#%" cfsqltype = "varchar">
                    OR b.fldBrandName LIKE <cfqueryparam value = "%#arguments.searchInput#%" cfsqltype = "varchar">)
			</cfif>

            <cfif structKeyExists(arguments, "filterMin") AND structKeyExists(arguments, "filterMax")
                AND LEN(TRIM(arguments.filterMin)) GT 0 AND LEN(TRIM(arguments.filterMax)) GT 0>
                AND p.fldPrice BETWEEN <cfqueryparam value = "#arguments.filterMin#" cfsqltype = "INTEGER"> 
                AND <cfqueryparam value = "#arguments.filterMax#" cfsqltype = "INTEGER">  
                ORDER BY
                    p.fldProductName
            </cfif>
                
            <cfif structKeyExists(arguments, "sortFlag")>
                <cfif arguments.sortFlag EQ 1>  
                    ORDER BY
                        p.fldPrice
                        <cfelseif arguments.sortFlag EQ 2 >
                    ORDER BY
                        p.fldPrice DESC
                </cfif>
            </cfif>

            <cfif structKeyExists(arguments, "random") AND Len(trim(arguments.random)) GT 0 AND  arguments.random EQ 1>
                ORDER BY RAND()
                LIMIT 8
            </cfif>
 
            <cfif structKeyExists(arguments, "offset") AND Len(trim(arguments.offset)) GT 0>
                LIMIT <cfqueryparam value="#arguments.limit#" cfsqltype="INTEGER"> 
                OFFSET <cfqueryparam value="#arguments.offset#" cfsqltype="INTEGER">
            <cfelseif  structKeyExists(arguments, "limit") AND  len(trim(arguments.limit)) GT 0 AND arguments.limit NEQ 0>
                LIMIT  #arguments.limit#
            </cfif>

        </cfquery> 
        <cfreturn local.queryGetProducts>
    </cffunction>

    <cffunction  name="fetchProductImages" access = "remote" returnFormat = "JSON" returnType="query" >
        <cfargument  name="productId" type="integer" required="true">

        <cfquery name="local.queryGetProductImages">
            SELECT 
                fldProductImage_Id,
                fldProductId,
                fldImageFilename,
                fldDefaultImage
            FROM 
                tblproductimages      
            WHERE 
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer"> 
                AND fldActive = 1
        </cfquery> 
        <cfreturn local.queryGetProductImages>
    </cffunction>

    <cffunction  name="categoryUniqueCheck" access = "public" returnType="numeric">
        <cfargument name="categoryName" type="string" required="true">    
        <cfargument name="categoryId" type="integer" required="true">

        <cfif arguments.categoryId GT 0>
            <cfquery name ="local.queryCategoryUniqueCheck">
                SELECT 
                    fldCategoryName
                FROM 
                    tblCategory 
                WHERE
                    fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype="VARCHAR"> 
                    AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER"> 
                    AND fldCategory_Id != <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "VARCHAR">      
            </cfquery>
        <cfelse>
            <cfquery name ="local.queryCategoryUniqueCheck">
                SELECT 
                    fldCategoryName
                FROM 
                    tblCategory 
                WHERE
                    fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype="VARCHAR"> 
                    AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">       
            </cfquery>
        </cfif>
        <cfreturn local.queryCategoryUniqueCheck.recordcount >
    </cffunction>

    <cffunction  name="subCategoryUniqueCheck" access = "public" returnType="numeric">
        <cfargument name="subCategoryName" type="string" required="true">    
        <cfargument name="subCategoryId" type="integer" required="true">    
        <cfargument name="selectedCategoryId" type="integer" required="true">       

        <cfif arguments.subCategoryId GT 0>
            <!--- EDIT existing subcategory--->
            <cfquery name ="local.querySubCategoryUniqueCheck">
                SELECT 
                    fldSubCategoryName
                FROM 
                    tblSubCategory 
                WHERE
                    fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype="VARCHAR"> 
                    AND fldCategoryId =  <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype="INTEGER"> 
                    AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER"> 
                    AND fldSubCategory_Id != <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "INTEGER">      
            </cfquery>
        <cfelse>
            <!--- ADD new subcategory--->
            <cfquery name ="local.querySubCategoryUniqueCheck">
                SELECT 
                    fldSubCategoryName
                FROM 
                    tblSubCategory 
                WHERE
                    fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype="VARCHAR"> 
                    AND fldCategoryId =  <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype="INTEGER"> 
                    AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">   
            </cfquery>
        </cfif>
        <cfreturn local.querySubCategoryUniqueCheck.recordcount >
    </cffunction>

    <cffunction  name="productUniqueCheck" access = "public" returnType="numeric">
        <cfargument name="productName" type="string" required="true">    
        <cfargument name="productId" type="string" required="true">    
        <cfargument name="selectedSubCategoryId" type="string" required="true">       

        <cfif arguments.productId GT 0>
            <!--- EDIT existing product--->
            <cfquery name ="local.queryProductUniqueCheck">
                SELECT 
                    fldProductName
                FROM 
                    tblproduct 
                WHERE
                    fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype="VARCHAR"> 
                    AND fldSubCategoryId =  <cfqueryparam value = "#arguments.selectedSubCategoryId#" cfsqltype="INTEGER"> 
                    AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER"> 
                    AND fldProduct_Id != <cfqueryparam value = "#arguments.productId#" cfsqltype = "INTEGER">      
            </cfquery>
        <cfelse>
            <!--- ADD new product--->
            <cfquery name ="local.queryProductUniqueCheck">
                SELECT 
                    fldProductName
                FROM 
                    tblproduct 
                WHERE
                    fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype="VARCHAR"> 
                    AND fldSubCategoryId =  <cfqueryparam value = "#arguments.selectedSubCategoryId#" cfsqltype="INTEGER"> 
                    AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">   
            </cfquery>
        </cfif>
        <cfreturn local.queryProductUniqueCheck.recordcount >
    </cffunction>

    <cffunction  name="addCategory" access = "remote" returnFormat = "JSON" returnType = "struct">
        <cfargument name="categoryName" type="string" required="true">   

        <cfset local.categoryId = 0>
        <cfset local.addCategoryResult = { "resultMsg" = "", "categoryId" = "" }>
        <cfif Len(Trim(arguments.categoryName)) EQ 0>
            <cfset local.addCategoryResult["resultMsg"] = "Enter Category Name ">
        <cfelseif categoryUniqueCheck(categoryName = arguments.categoryName,
                                      categoryId = local.categoryId) GT 0>
            <cfset local.addCategoryResult["resultMsg"] = "Category Name already exists">
        <cfelse>
            <cfquery name="local.queryAddCategory" result = "local.resultQueryAddCategory">
                INSERT INTO 
                    tblCategory(fldCategoryName,fldCreatedBy)
                VALUES (
                    <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                )
            </cfquery> 
            <cfset local.addCategoryResult["categoryId"] = local.resultQueryAddCategory.generated_Key> 
            <cfset local.addCategoryResult["resultMsg"]  = "Category Added">
        </cfif>
        <cfreturn local.addCategoryResult>
    </cffunction>

    <cffunction  name="addSubCategory" access = "remote" returnFormat = "JSON" returnType = "struct" >
        <cfargument name="subCategoryName" type="string" required="true" >       
        <cfargument name="selectedCategoryId" type="string" required="true" > 

        <cfset local.subCategoryId = 0>   
        <cfset local.addSubCategoryResult = { "resultMsg" = "", "subCategoryid" = "" }>
        <cfif Len(Trim(arguments.subCategoryName)) EQ 0 OR Len(Trim(arguments.selectedCategoryId)) EQ 0>
            <cfset local.addSubCategoryResult["resultMsg"] = "Please enter a Subcategory Name and select a valid Category">
        <cfelseif subCategoryUniqueCheck(subCategoryName = arguments.subCategoryName,
                                         selectedCategoryId = arguments.selectedCategoryId,
                                         subCategoryId = local.subCategoryId) GT 0>
            <cfset local.addSubCategoryResult["resultMsg"] = "SubCategory Name already exists">
        <cfelse>
            <cfquery name="local.queryAddSubCategory" result = "local.resultQueryAddSubCategory">
                INSERT INTO 
                    tblsubcategory(
                        fldSubCategoryName,
                        fldCategoryId,
                        fldCreatedBy)
                VALUES (
                    <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype = "INTEGER">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                )
            </cfquery> 
            
            <cfset local.addSubCategoryResult["resultMsg"] = "SubCategory Added">
            <cfset local.addSubCategoryResult["subCategoryid"] = local.resultQueryAddSubCategory.generated_key>
        </cfif>
        <cfreturn local.addSubCategoryResult>
    </cffunction>

    <cffunction  name="addProduct" access = "remote" returnFormat = "JSON" returnType = "struct">
        <cfargument name="productName" type="string" required="true">
        <cfargument name="selectedSubCategoryId" type="integer" required="true">
        <cfargument name="selectedCategoryId" type="integer" required="true">
        <cfargument name="selectedBrandId" type="integer" required="true">
        <cfargument name="productDescription" type="string" required="true">
        <cfargument name="productPrice" type="integer" required="true">
        <cfargument name="productTax" type="integer" required="true">
        <cfargument name="productImages" type="string" required="true">

        <cfset local.productId = 0>   
        <cfset local.addProductResult = { "resultMsg" = "", "productId" = "" }>
        <cfif Len(Trim(arguments.productName)) EQ 0 OR 
            Len(Trim(arguments.selectedSubCategoryId)) EQ 0 OR 
            Len(Trim(arguments.selectedCategoryId)) EQ 0 OR 
            Len(Trim(arguments.selectedBrandId)) EQ 0 OR 
            Len(Trim(arguments.productDescription)) EQ 0 OR 
            Len(Trim(arguments.productPrice)) EQ 0 OR 
            Len(Trim(arguments.productTax)) EQ 0 OR 
            Len(Trim(arguments.productImages)) EQ 0>
            <cfset local.addProductResult["resultMsg"] = "Please fill in all the required fields for adding a product.">
        <cfelseif productUniqueCheck(productName = arguments.productName,
                                     productId = local.productId,
                                     selectedSubCategoryId = arguments.selectedSubCategoryId) GT 0>
            <cfset local.addProductResult["resultMsg"] = "Product Name already exists">
        <cfelse>
            <cffile
                action="uploadall"
                destination="#expandpath("../assets/images/productImages")#"
                nameconflict="MakeUnique"
                accept="image/png,image/jpeg,.png,.jpg,.jpeg,.avif"
                strict="true"
                result="local.productUploadedImages"
                allowedextensions=".png,.jpg,.jpeg,.avif">
            
            <cfquery name="local.queryAddProduct" result = "local.resultQueryAddProduct">
                INSERT INTO 
                    tblproduct(
                        fldProductName,
                        fldSubCategoryId,
                        fldBrandId, 
                        fldDescription, 
                        fldPrice, 
                        fldTax, 
                        fldCreatedBy)
                VALUES (
                    <cfqueryparam value="#arguments.productName#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#arguments.selectedSubCategoryId#" cfsqltype="INTEGER">,
                    <cfqueryparam value="#arguments.selectedBrandId#" cfsqltype="INTEGER">,
                    <cfqueryparam value="#arguments.productDescription#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#arguments.productPrice#" cfsqltype="FLOAT">,
                    <cfqueryparam value="#arguments.productTax#" cfsqltype="FLOAT">,
                    <cfqueryparam value="#session.userId#" cfsqltype="INTEGER">
                )
            </cfquery> 
            
            <cfloop array="#local.productUploadedImages#" item="item" index = "index">
                <cfquery name="local.queryAddProductImages">
                    INSERT INTO 
                        tblproductimages(
                            fldProductId, 
                            fldImageFilename, 
                            fldDefaultImage, 
                            fldCreatedBy)
                    VALUES (
                        <cfqueryparam value="#local.resultQueryAddProduct.generated_Key#" cfsqltype="INTEGER">,
                        <cfqueryparam value="#item.serverfile#" cfsqltype="VARCHAR">,
                        <cfif index EQ 1>
                             <cfqueryparam value="1" cfsqltype="INTEGER">,
                        <cfelse>
                             <cfqueryparam value="0" cfsqltype="INTEGER">,
                        </cfif>
                        <cfqueryparam value="#session.userId#" cfsqltype="INTEGER">
                    )
                </cfquery>
            </cfloop>
            <cfset local.addProductResult["productId"] = local.resultQueryAddProduct.generated_key> 
            <cfset local.addProductResult["resultMsg"] = "Product added">
        </cfif>
        <cfreturn local.addProductResult>
    </cffunction>

    <cffunction  name="editCategory" access = "remote" returnFormat = "JSON" returnType = "string">
        <cfargument type="string" required="true" name="categoryName">
        <cfargument required="true" name="categoryId">
        <cfset local.editCategoryResult = "">
        <cfif Len(Trim(arguments.categoryName)) EQ 0>
            <cfset local.editCategoryResult = "Enter Category Name ">
        <cfelseif categoryUniqueCheck(categoryName = arguments.categoryName,
                                      categoryId = arguments.categoryId) GT 0>
            <cfset local.editCategoryResult = "Category Name already exists">
        <cfelse>
            <cfquery name="local.queryEditCategory">
            UPDATE 
                tblCategory
            SET 
                fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "VARCHAR">,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
            WHERE 
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "VARCHAR">
            </cfquery> 
            <cfset local.editCategoryResult = "Category Edited">
        </cfif>
        <cfreturn local.editCategoryResult>
    </cffunction>

    <cffunction  name="editSubCategory" access = "remote" returnFormat = "JSON" returnType = "struct">
        <cfargument name="subCategoryName" type="string" required="true">
        <cfargument name="selectedCategoryId" required="true">
        <cfargument name="subCategoryId" required="true">

        <cfset local.editSubCategoryResult = {  "resultMsg" = "", 
                                                "productId" = "", 
                                                "subCategoryName" = "",
                                                "subCategoryId" = "",
                                                "selectedCategoryId" = ""}>

        <cfif Len(Trim(arguments.subCategoryName)) EQ 0 OR Len(Trim(arguments.selectedCategoryId)) EQ 0>
            <cfset local.editSubCategoryResult["resultMsg"] = "Please enter a Subcategory Name and select a valid Category">
        <cfelseif subCategoryUniqueCheck(subCategoryName = arguments.subCategoryName,
                                         selectedCategoryId = arguments.selectedCategoryId,
                                         subCategoryId = arguments.subCategoryId) GT 0>
            <cfset local.editSubCategoryResult["resultMsg"] = "Sub Category Name already exists">
        <cfelse>
            <cfquery name="local.queryEditSubCategory">
                UPDATE 
                    tblsubcategory
                SET 
                    fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "VARCHAR">,
                    fldCategoryId = <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype = "VARCHAR">,
                    fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                WHERE 
                    fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer"> 
            </cfquery> 
            <cfset local.editSubCategoryResult["resultMsg"] = "Sub Category Edited">
            <cfset local.editSubCategoryResult["subCategoryName"] = arguments.subCategoryName>
            <cfset local.editSubCategoryResult["subCategoryId"] = arguments.subCategoryId>
            <cfset local.editSubCategoryResult["selectedCategoryId"] = arguments.selectedCategoryId>
        </cfif>
        <cfreturn local.editSubCategoryResult>
    </cffunction>

    <cffunction  name="editProduct" access = "remote" returnFormat = "JSON" returnType = "string" >
        <cfargument name="productName" type="string" required="true">
        <cfargument name="selectedSubCategoryId" type="integer" required="true">
        <cfargument name="selectedCategoryId" type="integer" required="true">
        <cfargument name="selectedBrandId" type="integer" required="true">
        <cfargument name="productDescription" type="string" required="true">
        <cfargument name="productPrice" type="integer" required="true">
        <cfargument name="productTax" type="integer" required="true">
        <cfargument name="productImages" type="string" required="true">
        <cfargument name="productId" type="integer" required="true">
        <!---  <cfdump  var="#arguments#"> --->

        <cfset local.editProductResult = "">
        <!---         <cfset local.validExtensions = "png,jpg,jpeg">
        <cfset local.imageList = listToArray(arguments.productImages, ",")>
        <cfset local.invalidImages = []> 

        <cfloop array="#local.imageList#" index="local.image">
            <cfset local.extension = listLast(local.image, ".")>
            <cfif NOT listFindNoCase(local.validExtensions, local.extension)>
                <cfset arrayAppend(local.invalidImages, local.image)> 
            </cfif>
        </cfloop>--->
        <cfif Len(Trim(arguments.productName)) EQ 0 OR 
            Len(Trim(arguments.selectedSubCategoryId)) EQ 0 OR 
            Len(Trim(arguments.selectedCategoryId)) EQ 0 OR 
            Len(Trim(arguments.selectedBrandId)) EQ 0 OR 
            Len(Trim(arguments.productDescription)) EQ 0 OR 
            Len(Trim(arguments.productPrice)) EQ 0 OR 
            Len(Trim(arguments.productTax)) EQ 0>
            <cfset local.editProductResult= "Please fill in all the required fields for adding a product.">
        <cfelseif productUniqueCheck(productName = arguments.productName,
                                     productId = arguments.productId,
                                     selectedSubCategoryId = arguments.selectedSubCategoryId) GT 0>
            <cfset local.editProductResult = "Product Name already exists">
            <!---         <cfelseif arrayLen(local.invalidImages) GT 0>
            <cfset local.editProductResult = "some images have unsupported formats. Please upload in .png, .jpg or .jpeg"> --->
        <cfelse>
            <cffile
                action="uploadall"
                destination="#expandpath("../assets/images/productImages")#"
                nameconflict="MakeUnique"
                accept="image/png,image/jpeg,.jpeg,"
                strict="true"
                result="local.productUploadedImages"
                allowedextensions=".png,.jpg,.jpeg,">
            <!---             <cfdump  var="#local.productUploadedImages#"> --->
            <cfquery name="local.queryEditProduct">
                UPDATE 
                    tblproduct
                SET 
                    fldSubCategoryId = <cfqueryparam value = "#arguments.selectedSubCategoryId#" cfsqltype = "VARCHAR">,
                    fldBrandId = <cfqueryparam value = "#arguments.selectedBrandId#" cfsqltype = "VARCHAR">,
                    fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "VARCHAR">,
                    fldDescription = <cfqueryparam value = "#arguments.productDescription#" cfsqltype = "VARCHAR">,
                    fldPrice = <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "VARCHAR">,
                    fldTax = <cfqueryparam value = "#arguments.productTax#" cfsqltype = "VARCHAR">,
                    fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                WHERE 
                    fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer"> 
            </cfquery> 

            <cfloop array="#local.productUploadedImages#" item="item">
                <cfquery name="local.queryAddProductImages" >
                    INSERT INTO 
                        tblproductimages(fldProductId, fldImageFilename, fldDefaultImage, fldCreatedBy)
                    VALUES (
                        <cfqueryparam value="#arguments.productId#" cfsqltype="INTEGER">,
                        <cfqueryparam value="#item.serverfile#" cfsqltype="VARCHAR">,
                        <cfqueryparam value="0" cfsqltype="INTEGER">,
                        <cfqueryparam value="#session.userId#" cfsqltype="INTEGER">
                    )
                </cfquery>
            </cfloop>
            <cfset local.editProductResult = "Sub Category Edited">
        </cfif>
        <cfreturn local.editProductResult>
    </cffunction>

    <cffunction  name="editDefaultImg" access = "remote" returnType = "void">
        <cfargument name="productId" type="integer" required="true">
        <cfargument name="productImageId" type="integer" required="true">

        <cfquery name="local.queryDeleteDefaultImg" >
            UPDATE 
                tblproductimages
            SET 
                fldDefaultImage = 0
            WHERE 
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer"> 
        </cfquery>

        <cfquery name="local.querySetDefaultImg" >
            UPDATE 
                tblproductimages
            SET 
                fldDefaultImage = 1
            WHERE 
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer"> 
                AND fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="deleteImg" access = "remote" returnType = "void">
        <cfargument name="productImageId" type="integer" required="true">

        <cfquery name="local.queryDeleteDefaultImg" >
            UPDATE 
                tblproductimages
            SET 
                fldActive = 0,
                fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
            WHERE 
                fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer"> 
        </cfquery>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote" returnType = "boolean">
        <cfargument  name="categoryId" type="integer" required ="true">

        <cfquery name = "local.querySoftDeleteCategory" >
            UPDATE 
                tblcategory
            SET 
                fldActive = 0 , 
                fldUpdatedBy =<cfqueryparam value = "#session.userId#" cfsqltype="integer">
            WHERE 
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="deleteProduct" access="remote" returnType = "boolean" >
        <cfargument  name="productId" type="integer"  required ="true">

        <cfquery name = "local.querySoftDeleteproduct" >
            UPDATE 
                tblproduct
            SET 
                fldActive = 0 , 
                fldUpdatedBy =<cfqueryparam value = "#session.userId#" cfsqltype="integer">
            WHERE 
                fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="deleteSubCategory" access="remote" returnType = "boolean" >
        <cfargument  name="subCategoryId" type="integer" required ="true">

        <cfquery name = "local.querySoftDeleteSubCategory" >
            UPDATE 
                tblsubcategory
            SET 
                fldActive = 0 , 
                fldUpdatedBy =<cfqueryparam value = "#session.userId#" cfsqltype="integer">
            WHERE 
                fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="logOut" access="remote" returnType = "void" >
       <cfset structClear(session)>
    </cffunction>

    <!--- USER     --->
    <cffunction  name="signUp" access = "public" returnType="string" >
        <cfargument name="firstName" type="string" required="yes">
        <cfargument name="lastName" type="string" required="yes">
        <cfargument name="emailId" type="string" required="yes">
        <cfargument name="pwd1" type="string" required="yes">
        <cfargument name="pwd2" type="string" required="yes">
        <cfargument name="phone" type="string" required="yes">

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
            <cfset local.signUpResult = "User Login Successful">
        </cfif>
        
        <cfreturn local.signUpResult>
    </cffunction>

    <cffunction  name="addToCart" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name="productId" type="integer" required="false">
        
        <cfset local.addToCartResult = { "resultMsg" = "","cartId" = "", "quantity" = ""}>
        <cfif structKeyExists(arguments, "productId") AND Len(trim(arguments.productId)) GT 0 AND arguments.productId NEQ 0>
            <!---  EXISTING PRODUCT CHECK  --->
            <cfquery name ="local.queryAddToCartNewProductCheck">
                SELECT 
                    fldQuantity,fldCart_Id
                FROM 
                    tblcart 
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">     
            </cfquery>

            <cfif local.queryAddToCartNewProductCheck.recordcount GT 0>

                <cfset local.updatedQuantity = local.queryAddToCartNewProductCheck.fldQuantity + 1>
                <cfset local.addToCartResult["cartId"] = local.queryAddToCartNewProductCheck.fldCart_Id>
                <!--- PRODUCT UPDATE    --->
                <cfquery name ="local.queryUpdateCart">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = <cfqueryparam value = "#local.updatedQuantity#"  cfsqltype = "integer">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype="integer"> 
                </cfquery>
                <cfset local.addToCartResult["resultMsg"] = "Cart Updated">
                <cfset local.addToCartResult["quantity"] = local.updatedQuantity>

            <cfelse>
                <!--- NEW PRODUCT ADD    --->
                <cfquery name ="local.queryAddToCart" result = "local.resultqueryAddToCart">
                    INSERT INTO 
                        tblcart(fldUserId,
                                fldProductId,
                                fldQuantity
                            )
                    VALUES(
                        <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                        <cfqueryparam value = "1" cfsqltype = "integer">
                    )
                </cfquery>
                <cfset local.addToCartResult["resultMsg"] = "Product added to the Cart">
                <cfset local.addToCartResult["cartId"] = local.resultqueryAddToCart.generated_Key>
                <cfset local.addToCartResult["quantity"] = 1>
            </cfif>
        </cfif>
        <cfset session.cartCount = getUserCartCount() >
        <cfreturn local.addToCartResult>
    </cffunction> 

    <cffunction  name="getUserCartCount" access = "public" returnType = "numeric"> 
        <cfquery name ="local.querygetCartCount">
            SELECT 
                fldProductId
            FROM 
                tblcart 
            WHERE
                fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">     
        </cfquery>
        <cfreturn local.querygetCartCount.recordCount>
    </cffunction>

    <cffunction  name="fetchCart" access = "public" returnType = "array">
        <cfargument  name="cartId" type="integer" required ="false">

        <cfset local.fetchCartResultMsg = "">

        <cfquery name ="local.queryFetchCartDetails">
            SELECT 
                c.fldCart_Id,
                c.fldProductId,
                c.fldQuantity,
                p.fldProductName,
                p.fldBrandId,
                p.fldPrice,
                p.fldTax,
                b.fldBrandName,
                pi.fldImageFilename
            FROM 
                tblcart c
                INNER JOIN tblproduct p ON c.fldProductId = p.fldProduct_Id
                INNER JOIN tblproductimages pi ON c.fldProductId = pi.fldProductId 
                INNER JOIN tblbrands b ON p.fldBrandId = b.fldBrand_Id
            WHERE
                c.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">     
                AND pi.fldDefaultImage = 1
            <cfif structKeyExists(arguments, "cartId")>
                AND c.fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype="integer">
            </cfif>
        </cfquery>
        <cfset local.fetchCartResultMsg = "cart Details fetched successfully">
        <cfset local.cartDetailsArray = []>

        <cfloop query="local.queryFetchCartDetails">
            <cfset local.cart = {
                "cartId" = local.queryFetchCartDetails.fldCart_Id,
                "productId" = local.queryFetchCartDetails.fldProductId,
                "quantity" = local.queryFetchCartDetails.fldQuantity,
                "productName" = local.queryFetchCartDetails.fldProductName,
                "price" = local.queryFetchCartDetails.fldPrice,
                "tax" = local.queryFetchCartDetails.fldTax,
                "brandName" = local.queryFetchCartDetails.fldBrandName,
                "defaultImg" = local.queryFetchCartDetails.fldImageFilename
            }>
            <cfset arrayAppend(local.cartDetailsArray, local.cart)>
        </cfloop>
        <!---         <cfset arrayAppend(local.cartDetailsArray, local.fetchCartResultMsg)> --->

        <cfreturn local.cartDetailsArray>
    </cffunction>

    <cffunction  name="deleteCartItem" access="remote" returnType = "boolean" >
        <cfargument  name="cartId" type="integer" required ="false">
        <cfargument  name="productId" type="integer" required ="false">

        <cfquery name = "local.queryDeleteCartItem" >
            DELETE FROM 
                tblCart
            WHERE 
            <cfif structKeyExists(arguments, "cartId")>
                fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype="integer">
            <cfelseif structKeyExists(arguments, "productId")>
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype="integer">
            </cfif>
        </cfquery>
        <cfset session.cartCount = getUserCartCount()>
        <cfreturn true>
    </cffunction>

    <cffunction  name="editCart" access = "remote" returnType ="struct" returnFormat = "JSON">
        <cfargument  name="cartId" type="integer" required ="true">
        <cfargument  name="quantity" type="integer" required ="true">

        <cfset local.editCartResult = {"resultMsg" = ""}>
        <cfif structKeyExists(arguments, "quantity") AND arguments.quantity GT 0>
            <cfquery name = "local.queryEditCartItem">
                UPDATE 
                    tblCart
                SET 
                    fldQuantity = <cfqueryparam value = "#arguments.quantity#" cfsqltype="integer">
                WHERE
                    fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype="integer">
            </cfquery>
            <cfset local.editCartResult["resultMsg"] = "Cart Updated">
        </cfif>
        <cfreturn local.editCartResult>
    </cffunction>

    <cffunction  name="updateUserInfo" access = "public" returnType = "struct">
        <cfargument name="firstName" type="string" required="yes">
        <cfargument name="lastName" type="string" required="yes">
        <cfargument name="emailId" type="string" required="yes">
        <cfargument name="phone" type="string" required="yes">

        <cfset local.updateUserInfoResult = {"resultMsg" = ""}>

        <cfif len(trim(arguments.firstName)) EQ 0>
            <cfset local.updateUserInfoResult["resultMsg"] = "First Name is required.">
        </cfif>

        <cfif len(trim(arguments.lastName)) EQ 0>
            <cfset local.updateUserInfoResult["resultMsg"] = "Last Name is required.">
        </cfif>

        <cfif isValid("email", arguments.emailId) EQ  0>
            <cfset local.updateUserInfoResult["resultMsg"] = "Enter a valid Email ID.">
        </cfif> 

        <cfif NOT isNumeric(arguments.phone) OR len(trim(arguments.phone)) NEQ 10 >
            <cfset local.updateUserInfoResult["resultMsg"] = "Enter a valid 10-digit phone number.">
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
                AND fldEmail !=<cfqueryparam value = "#session.email#" cfsqltype="VARCHAR">
                AND fldPhone != <cfqueryparam value = "#session.phone#" cfsqltype="VARCHAR">
                AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">       
        </cfquery>

        <cfif local.queryUserUniqueCheck.recordcount GT 0>
            <cfset local.updateUserInfoResult["resultMsg"] = "User mail or phone already exists">
        </cfif>

        <cfif len(trim(local.updateUserInfoResult["resultMsg"])) GT 0>
            <cfreturn local.updateUserInfoResult>
        <cfelse>
            <cfquery name = "local.queryUpdateUserInfo">
                UPDATE 
                    tbluser
                SET
                    fldFirstName = <cfqueryparam value = "#arguments.firstName#" cfsqltype = "VARCHAR">,
                    fldLastName = <cfqueryparam value = "#arguments.lastName#" cfsqltype = "VARCHAR">,
                    fldEmail = <cfqueryparam value = "#arguments.emailId#" cfsqltype = "VARCHAR">,
                    fldPhone = <cfqueryparam value = "#arguments.phone#" cfsqltype = "VARCHAR">
                WHERE
                    fldUser_Id = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
            </cfquery>
            <cfset session.firstName = arguments.firstName>
            <cfset session.lastName = arguments.lastName>
            <cfset session.email = arguments.emailId>
            <cfset session.phone = arguments.phone>
            <cfset local.updateUserInfoResult["resultMsg"] = "User details Updated">
            <!---<cflocation  url="profile.cfm"> --->
        </cfif>
        <cfreturn local.updateUserInfoResult>
    </cffunction>

    <cffunction  name="fetchAddresses" access = "public" returnType = "array">
        <cfquery name="local.queryGetAddresses">
            SELECT 
                fldAddress_Id,
                fldFirstName,
                fldLastName,
                fldAddressLine1,
                fldAddressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhone
            FROM 
                tbladdress
            WHERE 
                fldActive = 1
                AND fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="integer">
        </cfquery>

        <cfset local.addressesArray = []>

        <cfloop query="local.queryGetAddresses">
            <cfset local.address = {
                "addressId" = local.queryGetAddresses.fldAddress_Id,
                "firstName" = local.queryGetAddresses.fldFirstName,
                "lastName" = local.queryGetAddresses.fldLastName,
                "addLine1" = local.queryGetAddresses.fldAddressLine1,
                "addLine2" = local.queryGetAddresses.fldAddressLine2,
                "city" = local.queryGetAddresses.fldCity,
                "state" = local.queryGetAddresses.fldState,
                "pincode" = local.queryGetAddresses.fldPincode,
                "phone" = local.queryGetAddresses.fldPhone
            }>
            <cfset arrayAppend(local.addressesArray, local.address)>
        </cfloop>

        <cfreturn local.addressesArray>
    </cffunction>

    <cffunction  name="addNewAddress" access = "remote" returnType = "struct" returnFormat ="JSON">
        <cfargument name="firstName" type="string" required="yes">
        <cfargument name="lastName" type="string" required="yes">
        <cfargument name="phone" type="string" required="yes">
        <cfargument name="addLine1" type="string" required="yes">
        <cfargument name="addLine2" type="string" required="yes">
        <cfargument name="city" type="string" required="yes">
        <cfargument name="state" type="string" required="yes">
        <cfargument name="pincode" type="string" required="yes">

        <cfset local.addNewAddressResult = { "resultMsg" = ""}>

        <cfquery name ="local.queryAddNewAddress">
            INSERT INTO 
                tbladdress(
                        fldUserId,
                        fldFirstName,
                        fldLastName,
                        fldPhone,
                        fldAddressLine1,
                        fldAddressLine2,
                        fldCity,
                        fldState,
                        fldPincode,
                        fldActive)
            VALUES(
                <cfqueryparam value = "#session.userId#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "#arguments.firstName#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "#arguments.lastName#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "#arguments.phone#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "#arguments.addLine1#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "#arguments.addLine2#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "#arguments.city#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "#arguments.state#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "#arguments.pincode#" cfsqltype = "VARCHAR">,
                <cfqueryparam value = "1" cfsqltype = "INTEGER">

            )
        </cfquery>
        <cfset local.addNewAddressResult["resultMsg"] = "New Address added">
        <cfreturn local.addNewAddressResult>
    </cffunction>

    <cffunction  name="deleteAddress" access="remote" returnType = "boolean" >
        <cfargument  name="addressId" type="integer" required ="true">

        <cfquery name = "local.querySoftDeleteAddress" >
            UPDATE 
                tbladdress
            SET 
                fldActive = 0 , 
                fldDeactivatedDate = now()
            WHERE 
                fldAddress_Id = <cfqueryparam value = "#arguments.addressId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="placeOrder" access="remote" returnType = "struct" returnFormat ="JSON">
        <cfargument  name="cardNumber" type="string" required ="true">
        <cfargument  name="cvv" type="string" required ="true">
        <cfargument  name="selectedAddress" type="string" required ="true">
        <cfargument  name="totalPrice" type="string" required ="true">
        <cfargument  name="totalTax" type="string" required ="true">
        <cfargument  name="productId" type="string" required ="true">
        <cfargument  name="productQuantity" type="string" required ="true">

        <cfset local.cardNumber = "1111111111111111">
        <cfset local.cvv = "111">
        
        <cfset local.placeOrderResult = { "resultMsg" = ""}>

        <cfif arguments.cardNumber EQ local.cardNumber AND arguments.cvv EQ local.cvv>
            <cfset local.orderId = createUUID()>
            <cfquery name = "local.queryPlaceOrder" >
                INSERT INTO 
                    tblOrder(
                        fldOrder_Id,
                        fldUserId,
                        fldAddressId,
                        fldTotalPrice,
                        fldTotalTax,
                        fldOrderDate)
                VALUES(
                    <cfqueryparam value = "#local.orderId#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.selectedAddress#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.totalPrice#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.totalTax#" cfsqltype = "VARCHAR">,
                    now())
            </cfquery>
            <cfset local.placeOrderResult["resultMsg"] = "Order placed SuccessFully">

            <cfif arguments.productId NEQ 0 AND arguments.productQuantity NEQ 0>
                <!---  Buy Now  --->
                <cfset local.getProductDetails = application.shoppingCart.fetchProducts(productId = arguments.productId)>
                <!---      Add orderitems to order tbl 1 --->
                <cfquery name = "local.queryAddOrderItemsDetails" >
                    INSERT INTO 
                        tblorderitems(
                            fldOrderId,
                            fldProductId,
                            fldQuantity,
                            fldUnitPrice,
                            fldUnitTax)
                    VALUES(
                        <cfqueryparam value = "#local.orderId#" cfsqltype = "VARCHAR">,
                        <cfqueryparam value = "#arguments.productId#" cfsqltype = "VARCHAR">,
                        <cfqueryparam value = "#arguments.productQuantity#" cfsqltype = "VARCHAR">,
                        <cfqueryparam value = "#local.getProductDetails.fldPrice#" cfsqltype = "VARCHAR">,
                        <cfqueryparam value = "#local.getProductDetails.fldTax#" cfsqltype = "VARCHAR">
                    )
                </cfquery>
                <!--- remove items from cart tbl  2 --->
                <cfquery name = "local.queryRemoveCartItems">
                    DELETE FROM  
                        tblCart
                    WHERE
                        fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "INTEGER">
                        AND fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "VARCHAR">
                </cfquery>
                <cfset session.cartCount = getUserCartCount()>
                <cfset local.placeOrderResult["resultMsg"]&= "and cart updated succesfully">
            <cfelse>
                <!--- Cart Checkout --->
                <!--- order items tbl populate via cart --->
                <cfset local.getCartItems = fetchCart()>
                <cfloop array="#local.getCartItems#" index="local.item">
                    <cfquery name = "local.queryAddOrderItemsDetails" >
                        INSERT INTO 
                            tblorderitems(
                                fldOrderId,
                                fldProductId,
                                fldQuantity,
                                fldUnitPrice,
                                fldUnitTax)
                        VALUES(
                            <cfqueryparam value = "#local.orderId#" cfsqltype = "VARCHAR">,
                            <cfqueryparam value = "#local.item.productId#" cfsqltype = "VARCHAR">,
                            <cfqueryparam value = "#local.item.quantity#" cfsqltype = "VARCHAR">,
                            <cfqueryparam value = "#local.item.price#" cfsqltype = "VARCHAR">,
                            <cfqueryparam value = "#local.item.tax#" cfsqltype = "VARCHAR">
                        )
                    </cfquery>
                </cfloop>
                <!--- remove items from cart tbl  --->
                <cfquery name = "local.queryRemoveCartItems">
                    DELETE FROM  
                        tblCart
                    WHERE
                        fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "INTEGER">
                </cfquery>
                <cfset session.cartCount = getUserCartCount()>
                <cfset local.placeOrderResult["resultMsg"]&= "and cart updated succesfully">
            </cfif>
            <cfmail to ="#session.email#" from="gosalram554@gmail.com" subject="Your Order Confirmation - #local.orderId#">
                Dear Customer,

                Your order #local.orderId# has been successfully placed.  
                Here are the details:

                - **Delivery Address:** #arguments.selectedAddress#  
                - **Total Price:** Rs #arguments.totalPrice# 
                - **Items Ordered:** #arguments.productQuantity#  

                Best regards,  
                ShoppingCart
            </cfmail>

        <cfelse>
            <cfset local.placeOrderResult["resultMsg"] = "Invalid Card">
        </cfif>
        
                    
        <cfreturn local.placeOrderResult>
    </cffunction>
</cfcomponent>