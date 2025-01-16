<cfcomponent>
    <cffunction  name="logIn" returnType="string">
        <cfargument name ="userInput" type="string" required ="true">
        <cfargument name ="password" type="string" required = "true">
        <cfquery name ="local.queryUserLogin">
            SELECT 
                fldUser_Id,
                fldEmail,
                fldPhone,
                fldRoleId,
                fldHashedPassword,
                fldUserSaltString
            FROM 
                tblUser 
            WHERE(
                fldEmail = <cfqueryparam value = "#arguments.userInput#" cfsqltype="CF_SQL_VARCHAR"> OR
                fldPhone = <cfqueryparam value = "#arguments.userInput#" cfsqltype="CF_SQL_VARCHAR">)AND  
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">       
        </cfquery>

        <cfif arguments.userInput EQ "" OR arguments.password EQ "">
            <cfset local.loginResult = "Please provide both username/email and password.">
        <cfelseif local.queryUserLogin.recordcount GT 0>
            <cfif local.queryUserLogin.fldHashedPassword EQ hash(arguments.password & local.queryUserLogin.fldUserSaltString, "SHA-512")>
                <cfset local.loginResult = "User Login Successful">
                <cfset session.isLoggedIn = true>
                <cfset session.userId = local.queryUserLogin.fldUser_Id>
                <cfset session.userName = arguments.userInput>
                <cfset session.roleId = local.queryUserLogin.fldRoleId>
                <cflocation  url = "category.cfm" addToken="no">   
            <cfelse>
                <cfset local.loginResult = "Invalid password">
            </cfif>
        <cfelse>
            <cfset local.loginResult = "User name doesn't exist">
        </cfif>
        <cfreturn local.loginResult>
    </cffunction>

    <cffunction  name="fetchCategories">
        <cfquery name="local.queryGetCategories">
            SELECT 
                fldCategoryName,
                fldCategory_Id
            FROM 
                tblcategory
            WHERE 
                fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> AND
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">
        </cfquery> 
        <cfreturn local.queryGetCategories>
    </cffunction>

    <cffunction  name="fetchBrands">
        <cfquery name="local.queryGetBrands">
            SELECT 
                fldBrand_Id,
                fldBrandName
            FROM 
                tblbrands
            WHERE 
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">
        </cfquery> 
        <cfreturn local.queryGetBrands>
    </cffunction>

    <cffunction  name="fetchSubCategories" access = "remote"  returnFormat = "JSON">
        <cfargument  name="categoryId">
        <cfquery name="local.queryGetSubCategories">
            SELECT 
                fldSubCategoryName,
                fldSubCategory_Id
            FROM 
                tblSubCategory
            WHERE 
                fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> AND
                fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "CF_SQL_VARCHAR">AND
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">
        </cfquery> 
        <cfreturn local.queryGetSubCategories>
    </cffunction>

    <cffunction  name="fetchProducts">
        <cfargument  name="subCategoryId">
        <cfquery name="local.queryGetProducts">
            SELECT 
                p.fldProductName,
                p.fldProduct_Id,
                p.fldBrandId,
                p.fldDescription,
                p.fldPrice,
                p.fldTax,
                b.fldBrandName,
                pi.fldImageFileName
            FROM 
                tblproduct p      
            LEFT JOIN
                tblbrands b ON p.fldBrandId = b.fldBrand_Id
            LEFT JOIN
                tblproductimages pi ON p.fldProduct_Id = pi.fldProductId 
            WHERE 
                p.fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> AND
                p.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "CF_SQL_VARCHAR">AND
                p.fldActive = 1 AND
                pi.fldDefaultImage = 1
        </cfquery> 
        <cfreturn local.queryGetProducts>
    </cffunction>

    <cffunction  name="fetchProductImages" access = "remote" returnFormat = "JSON">
        <cfargument  name="productId">
        <cfquery name="local.queryGetProductImages">
            SELECT 
                fldProductImage_Id,
                fldProductId,
                fldImageFileName,
                fldDefaultImage
            FROM 
                tblproductimages      
            WHERE 
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer"> AND
                fldActive = 1
        </cfquery> 
        <cfreturn local.queryGetProductImages>
    </cffunction>

    <cffunction  name="fetchProductInfo" access = "remote" returnFormat = "JSON">
        <cfargument  name="productId">
        <cfquery name="local.queryGetProductIndo">
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
                fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> AND
                fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "CF_SQL_VARCHAR">AND
                fldActive = 1 
        </cfquery> 
        <cfreturn local.queryGetProductIndo>

    </cffunction>

    <cffunction  name="categoryUniqueCheck" returnType = "numeric">
        <cfargument type="string" required="true" name="categoryName">    
        <cfargument  name="categoryId">
        <cfif arguments.categoryId GT 0>
            <cfquery name ="local.queryCategoryUniqueCheck">
                SELECT 
                    fldCategoryName
                FROM 
                    tblCategory 
                WHERE
                    fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype="CF_SQL_VARCHAR"> AND  
                    fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER"> AND 
                    fldCategory_Id != <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "CF_SQL_VARCHAR">      
            </cfquery>
        <cfelse>
            <cfquery name ="local.queryCategoryUniqueCheck">
                SELECT 
                    fldCategoryName
                FROM 
                    tblCategory 
                WHERE
                    fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype="CF_SQL_VARCHAR"> AND  
                    fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">       
            </cfquery>
        </cfif>
        <cfreturn local.queryCategoryUniqueCheck.recordcount >
    </cffunction>

    <cffunction  name="subCategoryUniqueCheck" returnType = "numeric">
        <cfargument type="string" required="true" name="subCategoryName">    
        <cfargument type="string" required="true" name="subCategoryId">    
        <cfargument type="string" required="true" name="selectedCategoryId">       

        <cfif arguments.subCategoryId GT 0>
            <!--- EDIT existing subcategory--->
            <cfquery name ="local.querySubCategoryUniqueCheck">
                SELECT 
                    fldSubCategoryName
                FROM 
                    tblSubCategory 
                WHERE
                    fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype="CF_SQL_VARCHAR"> AND 
                    fldCategoryId =  <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype="CF_SQL_INTEGER"> AND 
                    fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER"> AND 
                    fldSubCategory_Id != <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "CF_SQL_INTEGER">      
            </cfquery>
        <cfelse>
            <!--- ADD new subcategory--->
            <cfquery name ="local.querySubCategoryUniqueCheck">
                SELECT 
                    fldSubCategoryName
                FROM 
                    tblSubCategory 
                WHERE
                    fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype="CF_SQL_VARCHAR"> AND 
                    fldCategoryId =  <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype="CF_SQL_INTEGER"> AND 
                    fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">   
            </cfquery>
        </cfif>
        <cfreturn local.querySubCategoryUniqueCheck.recordcount >
    </cffunction>

    <cffunction  name="productUniqueCheck" returnType = "numeric">
        <cfargument type="string" required="true" name="productName">    
        <cfargument type="string" required="true" name="productId">    
        <cfargument type="string" required="true" name="selectedSubCategoryId">       

        <cfif arguments.productId GT 0>
            <!--- EDIT existing product--->
            <cfquery name ="local.queryProductUniqueCheck">
                SELECT 
                    fldProductName
                FROM 
                    tblproduct 
                WHERE
                    fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype="CF_SQL_VARCHAR"> AND 
                    fldSubCategoryId =  <cfqueryparam value = "#arguments.selectedSubCategoryId#" cfsqltype="CF_SQL_INTEGER"> AND 
                    fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER"> AND 
                    fldProduct_Id != <cfqueryparam value = "#arguments.productId#" cfsqltype = "CF_SQL_INTEGER">      
            </cfquery>
        <cfelse>
            <!--- ADD new product--->
            <cfquery name ="local.queryProductUniqueCheck">
                SELECT 
                    fldProductName
                FROM 
                    tblproduct 
                WHERE
                    fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype="CF_SQL_VARCHAR"> AND 
                    fldSubCategoryId =  <cfqueryparam value = "#arguments.selectedSubCategoryId#" cfsqltype="CF_SQL_INTEGER"> AND 
                    fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">   
            </cfquery>
        </cfif>
        <cfreturn local.queryProductUniqueCheck.recordcount >
    </cffunction>

    <cffunction  name="addCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="categoryName">       
        <cfset local.categoryId = 0>
        <cfset local.addCategoryResult = {} >
        <cfif arguments.categoryName EQ "">
            <cfset local.addCategoryResult["resultMsg"] = "Enter Category Name ">
        <cfelseif categoryUniqueCheck(arguments.categoryName,local.categoryId) GT 0>
            <cfset local.addCategoryResult["resultMsg"] = "Category Name already exists">
        <cfelse>
            <cfquery name="local.queryAddCategory" result = "local.resultQueryAddCategory">
                INSERT INTO 
                    tblCategory(fldCategoryName,fldCreatedBy)
                VALUES (
                    <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "CF_SQL_VARCHAR">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                )
            </cfquery> 
            <cfset local.addCategoryResult["categoryId"] = local.resultQueryAddCategory.generated_Key> 
            <cfset local.addCategoryResult["resultMsg"]  = "Category Added">
        </cfif>
        <cfreturn local.addCategoryResult>
    </cffunction>

    <cffunction  name="addSubCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="subCategoryName">       
        <cfargument type="string" required="true" name="selectedCategoryId">    
        <cfset local.subCategoryId = 0>   
        <cfset local.addSubCategoryResult = {} >

        <cfif arguments.subCategoryName EQ "" OR arguments.selectedCategoryId EQ "">
            <cfset local.addSubCategoryResult["resultMsg"] = "Please enter a Subcategory Name and select a valid Category">
        <cfelseif subCategoryUniqueCheck(arguments.subCategoryName,arguments.selectedCategoryId,local.subCategoryId) GT 0>
            <cfset local.addSubCategoryResult["resultMsg"] = "SubCategory Name already exists">
        <cfelse>
            <cfquery name="local.queryAddSubCategory" result = "local.resultQueryAddSubCategory">
                INSERT INTO 
                    tblsubcategory(
                        fldSubCategoryName,
                        fldCategoryId,
                        fldCreatedBy)
                VALUES (
                    <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "CF_SQL_VARCHAR">,
                    <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype = "CF_SQL_INTEGER">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                )
            </cfquery> 
            
            <cfset local.addSubCategoryResult["resultMsg"] = "SubCategory Added">
            <cfset local.addSubCategoryResult["subCategoryid"] = local.resultQueryAddSubCategory.generated_key>
        </cfif>
        <cfreturn local.addSubCategoryResult>
    </cffunction>

    <cffunction  name="addProduct" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="productName">
        <cfargument type="string" required="true" name="selectedSubCategoryId">
        <cfargument type="string" required="true" name="selectedCategoryId">
        <cfargument type="string" required="true" name="selectedBrandId">
        <cfargument type="string" required="true" name="productDescription">
        <cfargument type="string" required="true" name="productPrice">
        <cfargument type="string" required="true" name="productTax">
        <cfargument type="string" required="true" name="productImages">

        <cfset local.productId = 0>   
        <cfset local.addProductResult = {}>
        <cfif arguments.productName EQ "" OR 
           arguments.selectedSubCategoryId EQ "" OR 
           arguments.selectedCategoryId EQ "" OR 
           arguments.selectedBrandId EQ "" OR 
           arguments.productDescription EQ "" OR 
           arguments.productPrice EQ "" OR 
           arguments.productTax EQ "" OR 
           arguments.productImages EQ "">
            <cfset local.addProductResult["resultMsg"] = "Please fill in all the required fields for adding a product.">
        <cfelseif productUniqueCheck(arguments.productName,local.productId,arguments.selectedSubCategoryId) GT 0>
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
                    <cfqueryparam value="#arguments.productName#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.selectedSubCategoryId#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#arguments.selectedBrandId#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#arguments.productDescription#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.productPrice#" cfsqltype="CF_SQL_FLOAT">,
                    <cfqueryparam value="#arguments.productTax#" cfsqltype="CF_SQL_FLOAT">,
                    <cfqueryparam value="#session.userId#" cfsqltype="CF_SQL_INTEGER">
                )
            </cfquery> 

            <cfloop array="#local.productUploadedImages#" item="item" index = "index">
                <cfquery name="local.queryAddProductImages">
                    INSERT INTO 
                        tblproductimages(
                            fldProductId, 
                            fldImageFileName, 
                            fldDefaultImage, 
                            fldCreatedBy)
                    VALUES (
                        <cfqueryparam value="#local.resultQueryAddProduct.generated_Key#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#item.serverfile#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfif index EQ 1>
                             <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">,
                        <cfelse>
                             <cfqueryparam value="0" cfsqltype="CF_SQL_INTEGER">,
                        </cfif>
                        <cfqueryparam value="#session.userId#" cfsqltype="CF_SQL_INTEGER">
                    )
                </cfquery>
            </cfloop>
            <cfset local.addProductResult["productId"] = local.resultQueryAddProduct.generated_key> 
            <cfset local.addProductResult["resultMsg"] = "Product added">
        </cfif>
        <cfreturn local.addProductResult>
    </cffunction>

    <cffunction  name="editCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="categoryName">
        <cfargument required="true" name="categoryId">
        <cfset local.editCategoryResult = "">
        <cfif arguments.categoryName EQ "">
            <cfset local.editCategoryResult = "Enter Category Name ">
        <cfelseif categoryUniqueCheck(arguments.categoryName,arguments.categoryId) GT 0>
            <cfset local.editCategoryResult = "Category Name already exists">
        <cfelse>
            <cfquery name="local.queryEditCategory">
            UPDATE 
                tblCategory
            SET 
                fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "CF_SQL_VARCHAR">,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            WHERE 
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "CF_SQL_VARCHAR">
            </cfquery> 
            <cfset local.editCategoryResult = "Category Edited">
        </cfif>
        <cfreturn local.editCategoryResult>
    </cffunction>

    <cffunction  name="editSubCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="subCategoryName">
        <cfargument required="true" name="selectedCategoryId">
        <cfargument required="true" name="subCategoryId">
        <cfset local.editSubCategoryResult = {}>

        <cfif arguments.subCategoryName EQ "" OR arguments.selectedCategoryId EQ "">
            <cfset local.editSubCategoryResult["resultMsg"] = "Please enter a Subcategory Name and select a valid Category">
        <cfelseif subCategoryUniqueCheck(arguments.subCategoryName,arguments.selectedCategoryId,arguments.subCategoryId) GT 0>
            <cfset local.editSubCategoryResult["resultMsg"] = "Sub Category Name already exists">
        <cfelse>
            <cfquery name="local.queryEditSubCategory">
            UPDATE 
                tblsubcategory
            SET 
                fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "CF_SQL_VARCHAR">,
                fldCategoryId = <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype = "CF_SQL_VARCHAR">,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            WHERE 
                fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer"> 
            </cfquery> 
            <cfset local.editSubCategoryResult["resultMsg"] = "Sub Category Edited">
            <cfset local.editSubCategoryResult["subCategoryName"] = arguments.subCategoryName>
            <cfset local.editSubCategoryResult["subCategoryId"] = arguments.subCategoryId>
            <cfset local.editSubCategoryResult["selectedCategoryId"] = arguments.selectedCategoryId>
        </cfif>
        <cfreturn local.editSubCategoryResult>
    </cffunction>

    <cffunction  name="editProduct" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="productName">
        <cfargument type="string" required="true" name="selectedSubCategoryId">
        <cfargument type="string" required="true" name="selectedCategoryId">
        <cfargument type="string" required="true" name="selectedBrandId">
        <cfargument type="string" required="true" name="productDescription">
        <cfargument type="string" required="true" name="productPrice">
        <cfargument type="string" required="true" name="productTax">
        <cfargument type="string" required="true" name="productImages">
        <cfargument type="string" required="true" name="productId">
        <cfset local.editProductResult = "">

        <cfif arguments.productName EQ "" OR 
           arguments.selectedSubCategoryId EQ "" OR 
           arguments.selectedCategoryId EQ "" OR 
           arguments.selectedBrandId EQ "" OR 
           arguments.productDescription EQ "" OR 
           arguments.productPrice EQ "" OR 
           arguments.productTax EQ "" OR 
           arguments.productImages EQ "">
            <cfset local.editProductResult= "Please fill in all the required fields for adding a product.">
        <cfelseif productUniqueCheck(arguments.productName,arguments.productId,arguments.selectedSubCategoryId) GT 0>
            <cfset local.editProductResult = "Product Name already exists">
        <cfelse>
            <cffile
                action="uploadall"
                destination="#expandpath("../assets/images/productImages")#"
                nameconflict="MakeUnique"
                accept="image/png,image/jpeg,.png,.jpg,.jpeg"
                strict="true"
                result="local.productUploadedImages"
                allowedextensions=".png,.jpg,.jpeg">

            <cfquery name="local.queryEditProduct">
            UPDATE 
                tblproduct
            SET 
                fldSubCategoryId = <cfqueryparam value = "#arguments.selectedSubCategoryId#" cfsqltype = "CF_SQL_VARCHAR">,
                fldBrandId = <cfqueryparam value = "#arguments.selectedBrandId#" cfsqltype = "CF_SQL_VARCHAR">,
                fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "CF_SQL_VARCHAR">,
                fldDescription = <cfqueryparam value = "#arguments.productDescription#" cfsqltype = "CF_SQL_VARCHAR">,
                fldPrice = <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "CF_SQL_VARCHAR">,
                fldTax = <cfqueryparam value = "#arguments.productTax#" cfsqltype = "CF_SQL_VARCHAR">,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            WHERE 
                fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer"> 
            </cfquery> 

            <cfloop array="#local.productUploadedImages#" item="item">
                <cfquery name="local.queryAddProductImages">
                    INSERT INTO 
                        tblproductimages(fldProductId, fldImageFileName, fldDefaultImage, fldCreatedBy)
                    VALUES (
                        <cfqueryparam value="#arguments.productId#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#item.serverfile#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="0" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#session.userId#" cfsqltype="CF_SQL_INTEGER">
                    )
                </cfquery>
            </cfloop>
            <cfset local.editProductResult = "Sub Category Edited">
        </cfif>
        <cfreturn local.editProductResult>
    </cffunction>

    <cffunction  name="editDefaultImg" access = "remote">
        <cfargument name="productId">
        <cfargument name="productImageId">
        <cfquery name="local.queryDeleteDefaultImg">
            UPDATE 
                tblproductimages
            SET 
                fldDefaultImage = 0
            WHERE 
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer"> 
        </cfquery>

        <cfquery name="local.querySetDefaultImg">
            UPDATE 
                tblproductimages
            SET 
                fldDefaultImage = 1
            WHERE 
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer"> AND
                fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "cf_sql_integer">
        </cfquery>
    </cffunction>

    <cffunction  name="deleteImg" access = "remote">
        <cfargument name="productImageId">
        <cfquery name="local.queryDeleteDefaultImg">
            UPDATE 
                tblproductimages
            SET 
                fldActive = 0,
                fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            WHERE 
                fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "cf_sql_integer"> 
        </cfquery>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote">
        <cfargument  name="categoryId" required ="true">
        <cfquery name = "local.querySoftDeleteCategory">
            UPDATE 
                tblcategory
            SET 
                fldActive = 0 , 
                fldUpdatedBy =<cfqueryparam value = "#session.userId#" cfsqltype="cf_sql_integer">
            WHERE 
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype="CF_SQL_integer">
        </cfquery>
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="deleteProduct" access="remote">
        <cfargument  name="productId" required ="true">
        <cfquery name = "local.querySoftDeleteproduct">
            UPDATE 
                tblproduct
            SET 
                fldActive = 0 , 
                fldUpdatedBy =<cfqueryparam value = "#session.userId#" cfsqltype="cf_sql_integer">
            WHERE 
                fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype="CF_SQL_integer">
        </cfquery>
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="deleteSubCategory" access="remote">
        <cfargument  name="subCategoryId" required ="true">
        <cfquery name = "local.querySoftDeleteSubCategory">
            UPDATE 
                tblsubcategory
            SET 
                fldActive = 0 , 
                fldUpdatedBy =<cfqueryparam value = "#session.userId#" cfsqltype="cf_sql_integer">
            WHERE 
                fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype="CF_SQL_integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="logOut" access="remote">
       <cfset structClear(session)>
    </cffunction>

</cfcomponent>