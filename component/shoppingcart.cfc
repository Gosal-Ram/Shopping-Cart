<cfcomponent>
    <!--- ADMIN DASHBOARD --->
    <cffunction  name="logIn" access = "public" returnType="string" >
        <cfargument name ="userInput" type="string" required ="true">
        <cfargument name ="password" type="string" required = "true">

        <cfset local.loginResult = "">
        <cfquery name ="local.queryUserLogin" datasource="ShoppingCart">
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
                AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">       
        </cfquery>

        <cfif Len(Trim(arguments.userInput)) EQ 0 OR Len(Trim(arguments.password)) EQ 0>
            <cfset local.loginResult = "Please provide both username/email and password.">
        <cfelseif local.queryUserLogin.recordcount GT 0>
            <cfif local.queryUserLogin.fldHashedPassword EQ hash(arguments.password & local.queryUserLogin.fldUserSaltString, "SHA-512")>
                <cfset local.loginResult = "User Login Successful">
                <cfset session.isLoggedIn = true>
                <cfset session.firstName = local.queryUserLogin.fldFirstName>
                <cfset session.lastName = local.queryUserLogin.fldLastName>
                <cfset session.userId = local.queryUserLogin.fldUser_Id>
                <cfset session.roleId = local.queryUserLogin.fldRoleId>
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

    <cffunction  name="fetchCategories" access = "public" returnType="query">
        <cfquery name="local.queryGetCategories" datasource="ShoppingCart">
            SELECT 
                fldCategoryName,
                fldCategory_Id
            FROM 
                tblcategory
            WHERE 
                <!---  fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer"> 
                AND --->
                fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">
        </cfquery> 
        <cfreturn local.queryGetCategories>
    </cffunction>

    <cffunction  name="fetchBrands" access = "public" returnType="query">
        <cfquery name="local.queryGetBrands" datasource="ShoppingCart">
            SELECT 
                fldBrand_Id,
                fldBrandName
            FROM 
                tblbrands
            WHERE 
                fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">
        </cfquery> 
        <cfreturn local.queryGetBrands>
    </cffunction>

    <cffunction  name="fetchSubCategories" access = "remote" returnFormat = "JSON" returnType="query">
        <cfargument name = "categoryId" type="integer" required="true">
        <cfquery name="local.queryGetSubCategories" datasource="ShoppingCart">
            SELECT 
                fldSubCategoryName,
                fldSubCategory_Id
            FROM 
                tblSubCategory
            WHERE 
            
                <!--- fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer"> 
                AND --->
                 fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "VARCHAR">
                AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">
        </cfquery> 
        <cfreturn local.queryGetSubCategories>
    </cffunction>

    <cffunction  name="fetchProducts" access = "public" returnType="query">
        <cfargument name="subCategoryId" type="integer" required="true">

        <cfquery name="local.queryGetProducts" datasource="ShoppingCart">
            SELECT 
                p.fldProductName,
                p.fldProduct_Id,
                p.fldBrandId,
                p.fldDescription,
                p.fldPrice,
                p.fldTax,
                b.fldBrandName,
                pi.fldImageFilename
            FROM 
                tblproduct p      
            INNER JOIN
                tblbrands b 
                ON p.fldBrandId = b.fldBrand_Id
            INNER JOIN
                tblproductimages pi 
                ON p.fldProduct_Id = pi.fldProductId 
            WHERE 
                p.fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer"> 
                AND p.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "VARCHAR">
                AND p.fldActive = 1 
                AND pi.fldDefaultImage = 1
        </cfquery> 
        <cfreturn local.queryGetProducts>
    </cffunction>

    <cffunction  name="fetchProductsRandom" access = "public" returnType="array">
        <cfquery name="local.queryGetProductsRandom" datasource="ShoppingCart">
            SELECT 
                p.fldProductName,
                p.fldProduct_Id,
                p.fldBrandId,
                p.fldDescription,
                p.fldPrice,
                p.fldTax,
                b.fldBrandName,
                pi.fldImageFilename
            FROM 
                tblproduct p      
            INNER JOIN
                tblbrands b 
                ON p.fldBrandId = b.fldBrand_Id
            INNER JOIN
                tblproductimages pi 
                ON p.fldProduct_Id = pi.fldProductId 
            WHERE 
                p.fldActive = 1 
                AND pi.fldDefaultImage = 1
            ORDER BY RAND()
        </cfquery>
        <cfset local.randomProductsArray = []>
        <cfloop query="local.queryGetProductsRandom">
            <cfset local.randomProducts = { "productName" = "", 
                                            "productId" = "", 
                                            "brandId" = "",
                                            "description" = "", 
                                            "price" = "", 
                                            "tax" = "", 
                                            "brandName" = "", 
                                            "imgName" = "" }>

            <cfset local.randomProducts ["productName"] = local.queryGetProductsRandom.fldProductName>
            <cfset local.randomProducts ["productId"] = local.queryGetProductsRandom.fldProduct_Id>
            <cfset local.randomProducts ["brandId"] = local.queryGetProductsRandom.fldBrandId>
            <cfset local.randomProducts ["description"] = local.queryGetProductsRandom.fldDescription>
            <cfset local.randomProducts ["price"] = local.queryGetProductsRandom.fldPrice>
            <cfset local.randomProducts ["tax"] = local.queryGetProductsRandom.fldTax>
            <cfset local.randomProducts ["brandName"] = local.queryGetProductsRandom.fldBrandName>
            <cfset local.randomProducts ["imgName"] = local.queryGetProductsRandom.fldImageFilename>
            <cfset arrayAppend(local.randomProductsArray, local.randomProducts)>
        </cfloop>
        <cfreturn local.randomProductsArray>
    </cffunction>

    <cffunction  name="fetchProductImages" access = "remote" returnFormat = "JSON" returnType="query" >
        <cfargument  name="productId" type="integer" required="true">

        <cfquery name="local.queryGetProductImages" datasource="ShoppingCart">
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

    <cffunction  name="fetchProductInfo" access = "remote" returnFormat = "JSON" returnType="query">
        <cfargument name="productId" type="integer" required="true">
        <cfquery name="local.queryGetProductInfo" datasource="ShoppingCart">
            SELECT 
                fldProductName,
                fldProduct_Id,
                fldBrandId,
                fldDescription,
                fldPrice,
                fldTax
            FROM 
                tblproduct       
            WHERE 
                fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer"> 
                AND fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "VARCHAR">
                AND fldActive = 1 
        </cfquery> 
        <cfreturn local.queryGetProductInfo>

    </cffunction>

    <cffunction  name="categoryUniqueCheck" access = "public" returnType="numeric">
        <cfargument name="categoryName" type="string" required="true">    
        <cfargument name="categoryId" type="integer" required="true">

        <cfif arguments.categoryId GT 0>
            <cfquery name ="local.queryCategoryUniqueCheck" datasource="ShoppingCart">
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
            <cfquery name ="local.queryCategoryUniqueCheck" datasource="ShoppingCart">
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
            <cfquery name ="local.querySubCategoryUniqueCheck" datasource="ShoppingCart">
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
            <cfquery name ="local.querySubCategoryUniqueCheck" datasource="ShoppingCart">
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
            <cfquery name ="local.queryProductUniqueCheck" datasource="ShoppingCart">
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
            <cfquery name ="local.queryProductUniqueCheck" datasource="ShoppingCart">
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
            <cfquery name="local.queryAddCategory" datasource="ShoppingCart" result = "local.resultQueryAddCategory">
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
            <cfquery name="local.queryAddSubCategory" datasource="ShoppingCart" result = "local.resultQueryAddSubCategory">
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
                accept="image/png,image/jpeg,.png,.jpg,.jpeg"
                strict="true"
                result="local.productUploadedImages"
                allowedextensions=".png,.jpg,.jpeg">
            
            <cfquery name="local.queryAddProduct" datasource="ShoppingCart" result = "local.resultQueryAddProduct">
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
                <cfquery name="local.queryAddProductImages" datasource="ShoppingCart">
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
            <cfquery name="local.queryEditSubCategory" datasource="ShoppingCart">
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

        <cfset local.editProductResult = "">
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
        <cfelse>
            <cffile
                action="uploadall"
                destination="#expandpath("../assets/images/productImages")#"
                nameconflict="MakeUnique"
                accept="image/png,image/jpeg,.jpeg"
                strict="true"
                result="local.productUploadedImages"
                allowedextensions=".png,.jpg,.jpeg">

            <cfquery name="local.queryEditProduct" datasource="ShoppingCart">
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
                <cfquery name="local.queryAddProductImages" datasource="ShoppingCart" >
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

        <cfquery name="local.queryDeleteDefaultImg" datasource="ShoppingCart" >
            UPDATE 
                tblproductimages
            SET 
                fldDefaultImage = 0
            WHERE 
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer"> 
        </cfquery>

        <cfquery name="local.querySetDefaultImg" datasource="ShoppingCart" >
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

        <cfquery name="local.queryDeleteDefaultImg" datasource="ShoppingCart" >
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

        <cfquery name = "local.querySoftDeleteCategory" datasource="ShoppingCart" >
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

        <cfquery name = "local.querySoftDeleteproduct" datasource="ShoppingCart" >
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

        <cfquery name = "local.querySoftDeleteSubCategory" datasource="ShoppingCart" >
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

        <!--- <cfif isValid("email", arguments.emailId) NEQ 1>
            <cfset local.signUpResult = "Enter a valid Email ID.">
        </cfif> --->

        <cfif arguments.pwd1 NEQ arguments.pwd2>
            <cfset local.signUpResult = "Passwords do not match.">
        </cfif>

        <!--- <cfif isValid("telephone", arguments.phone, 10, 10)>
            <cfset local.signUpResult = "Enter a valid 10-digit phone number.">
        </cfif> --->

        <cfquery name ="local.queryUserUniqueCheck" datasource="ShoppingCart">
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

</cfcomponent>