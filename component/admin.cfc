<cfcomponent>
    <!---Admin  --->
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
        <cfargument name="categoryId" type="integer" required="false">

        <cfif structKeyExists(arguments, "categoryId")>
            <cfquery name ="local.queryCategoryUniqueCheck">
                SELECT 
                    fldCategoryName
                FROM 
                    tblCategory 
                WHERE
                    fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype="VARCHAR"> 
                    AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER"> 
                    AND fldCategory_Id != <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "INTEGER">      
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
        <cfargument name="subCategoryId" type="integer" required="false">    
        <cfargument name="selectedCategoryId" type="integer" required="true">       

        <cfif structKeyExists(arguments, "subCategoryId")>
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
        <cfargument name="productId" type="string" required="false">    
        <cfargument name="selectedSubCategoryId" type="string" required="true">       

        <cfif structKeyExists(arguments, "productId")>
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

        <cfset local.addCategoryResult = { "resultMsg" = "", "categoryId" = "" }>
        <!---Validation--->
        <cfif len(trim(arguments.categoryName)) EQ 0>
            <cfset local.addCategoryResult["resultMsg"] = "Enter Category Name ">
        <cfelseif reFind("[^a-zA-Z0-9\s]", arguments.categoryName)>
            <cfset local.addCategoryResult["resultMsg"] = "Category Name contains invalid symbols. Only letters and numbers are allowed.">
        <cfelseif categoryUniqueCheck(categoryName = arguments.categoryName) GT 0>
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
            <!--- <cfset structDelete(application, "cachedCategories")> --->
        </cfif>
        <cfreturn local.addCategoryResult>
    </cffunction>

    <cffunction  name="addSubCategory" access = "remote" returnFormat = "JSON" returnType = "struct" >
        <cfargument name="subCategoryName" type="string" required="true" >       
        <cfargument name="selectedCategoryId" type="string" required="true" > 

        <cfset local.addSubCategoryResult = { "resultMsg" = "", "subCategoryid" = "" }>
        <!---Validation--->
        <cfif len(trim(arguments.subCategoryName)) EQ 0 OR val(arguments.selectedCategoryId) EQ 0>
            <cfset local.addSubCategoryResult["resultMsg"] = "Please enter a Subcategory Name and select a valid Category">
        <cfelseif reFind("[^a-zA-Z0-9\s]", arguments.subCategoryName)>
            <cfset local.addSubCategoryResult["resultMsg"] = "Subcategory Name contains invalid symbols. Only letters and numbers are allowed.">
        <cfelseif subCategoryUniqueCheck(subCategoryName = arguments.subCategoryName,
                                         selectedCategoryId = arguments.selectedCategoryId) GT 0>
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
            <!--- <cfset structDelete(application, "cachedSubCategories")> --->
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
 
        <cfset local.addProductResult = { "resultMsg" = "", "productId" = "" }>
        <!---Validation--->
        <cfif len(trim(arguments.productName)) EQ 0 OR 
            val(arguments.selectedSubCategoryId) EQ 0 OR 
            val(arguments.selectedCategoryId) EQ 0 OR 
            val(arguments.selectedBrandId) EQ 0 OR 
            len(trim(arguments.productDescription)) EQ 0 OR 
            val(arguments.productPrice) EQ 0 OR 
            val(arguments.productTax) EQ 0 OR 
            len(trim(arguments.productImages)) EQ 0>
            <cfset local.addProductResult["resultMsg"] = "Please fill in all the required fields for adding a product.">
        <cfelseif reFind("[^a-zA-Z0-9\s]", arguments.productName) OR reFind("[^a-zA-Z0-9\s]", arguments.productDescription)>
            <cfset local.addProductResult["resultMsg"] = "Enter a valid product Name and product description">
        <cfelseif productUniqueCheck(productName = arguments.productName,
                                     selectedSubCategoryId = arguments.selectedSubCategoryId) GT 0>
            <cfset local.addProductResult["resultMsg"] = "Product Name already exists">
        <cfelse>
            <cffile
                action="uploadall"
                destination="#expandpath("../productImages")#"
                nameconflict="MakeUnique"
                accept="image/*"
                strict="true"
                result="local.productUploadedImages">
            
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
                    <cfqueryparam value="#abs(arguments.productPrice)#" cfsqltype="DECIMAL">,
                    <cfqueryparam value="#abs(arguments.productTax)#" cfsqltype="DECIMAL">,
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
        <!---Validation--->
        <cfif len(trim(arguments.categoryName)) EQ 0>
            <cfset local.editCategoryResult = "Enter Category Name "> 
        <cfelseif reFind("[^a-zA-Z0-9\s]", arguments.categoryName)>
            <cfset local.editCategoryResult = "Category Name contains invalid symbols. Only letters and numbers are allowed.">
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
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "INTEGER">
            </cfquery> 
            <cfset local.editCategoryResult = "Category Edited">
            <!--- <cfset structDelete(application, "cachedSubCategories")> --->
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
        <!---Validation--->
        <cfif len(trim(arguments.subCategoryName)) EQ 0 OR val(arguments.selectedCategoryId) EQ 0>
            <cfset local.editSubCategoryResult["resultMsg"] = "Please enter a Subcategory Name and select a valid Category">
        <cfelseif reFind("[^a-zA-Z0-9\s]", arguments.subCategoryName)>
            <cfset local.editSubCategoryResult["resultMsg"] = "Please enter a valid Subcategory Name">
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
                    fldCategoryId = <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype = "INTEGER">,
                    fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "INTEGER">
                WHERE 
                    fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "INTEGER"> 
            </cfquery> 
            <cfset local.editSubCategoryResult["resultMsg"] = "Sub Category Edited">
            <cfset local.editSubCategoryResult["subCategoryName"] = arguments.subCategoryName>
            <cfset local.editSubCategoryResult["subCategoryId"] = arguments.subCategoryId>
            <cfset local.editSubCategoryResult["selectedCategoryId"] = arguments.selectedCategoryId>
            <!--- <cfset structDelete(application, "cachedSubCategories")> --->
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
        <!---Validation--->
        <cfif len(trim(arguments.productName)) EQ 0 OR 
            val(arguments.selectedSubCategoryId) EQ 0 OR 
            val(arguments.selectedCategoryId) EQ 0 OR 
            val(arguments.selectedBrandId) EQ 0 OR 
            len(trim(arguments.productDescription)) EQ 0 OR 
            val(arguments.productPrice) EQ 0 OR 
            val(arguments.productTax) EQ 0>
            <cfset local.editProductResult= "Please fill in all the required fields for adding a product.">
        <cfelseif reFind("[^a-zA-Z0-9\s]", arguments.productName) OR reFind("[^a-zA-Z0-9\s]", arguments.productDescription)>
            <cfset local.editProductResult = "Enter a valid product Name and product description">
        <cfelseif productUniqueCheck(productName = arguments.productName,
                                     productId = arguments.productId,
                                     selectedSubCategoryId = arguments.selectedSubCategoryId) GT 0>
            <cfset local.editProductResult = "Product Name already exists">
        <cfelse>
            <cffile
                action="uploadall"
                destination="#expandpath("../assets/productImages")#"
                nameconflict="MakeUnique"
                accept="image/*"
                strict="true"
                result="local.productUploadedImages">
            <cfquery name="local.queryEditProduct">
                UPDATE 
                    tblproduct
                SET 
                    fldSubCategoryId = <cfqueryparam value = "#arguments.selectedSubCategoryId#" cfsqltype = "INTEGER">,
                    fldBrandId = <cfqueryparam value = "#arguments.selectedBrandId#" cfsqltype = "INTEGER">,
                    fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "VARCHAR">,
                    fldDescription = <cfqueryparam value = "#arguments.productDescription#" cfsqltype = "VARCHAR">,
                    fldPrice = <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "DECIMAL">,
                    fldTax = <cfqueryparam value = "#arguments.productTax#" cfsqltype = "DECIMAL">,
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
            <cfset local.editProductResult = "product Edited">
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
                fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                fldDeactivatedDate = now()
            WHERE 
                fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer"> 
        </cfquery>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote" returnType = "boolean">
        <cfargument  name="categoryId" type="integer" required ="true">
        <cfquery name = "locA.querySoftDeleteCategory">
            UPDATE 
                tblcategory C
                LEFT JOIN 
                    tblsubCategory SC ON C.fldCategory_Id = SC.fldCategoryId
                LEFT JOIN 
                    tblProduct P ON SC.fldSubCategory_Id = P.fldSubCategoryId
                LEFT JOIN 
                    tblProductImages PI ON P.fldProduct_Id = PI.fldProductId
            SET 
                C.fldActive = 0, 
                C.fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype="integer">,
                SC.fldActive = 0,
                SC.fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype="integer">,
                P.fldActive = 0,
                P.fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype="integer">,
                PI.fldActive = 0,
                PI.fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                PI.fldDeactivatedDate = now()

            WHERE 
                C.fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype="integer">
        </cfquery>
        <!--- <cfset structDelete(application, "cachedCategories")> --->
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="deleteProduct" access="remote" returnType = "boolean" >
        <cfargument  name="productId" type="integer"  required ="true">
        <cfquery name = "local.querySoftDeleteproduct">
            UPDATE 
                tblproduct P
                LEFT JOIN 
                    tblProductImages PI ON P.fldProduct_Id = PI.fldProductId
            SET 
                P.fldActive = 0,
                P.fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype="integer">,
                PI.fldActive = 0,
                PI.fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                PI.fldDeactivatedDate = now()
            WHERE 
                P.fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="deleteSubCategory" access="remote" returnType = "boolean" >
        <cfargument  name="subCategoryId" type="integer" required ="true">
        <cfquery name = "local.querySoftDeleteSubCategory">
            UPDATE 
                tblsubCategory SC
                LEFT JOIN 
                    tblProduct P ON SC.fldSubCategory_Id = P.fldSubCategoryId
                LEFT JOIN 
                    tblProductImages PI ON P.fldProduct_Id = PI.fldProductId
            SET 
                SC.fldActive = 0,
                SC.fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype="integer">,
                P.fldActive = 0,
                P.fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype="integer">,
                PI.fldActive = 0,
                PI.fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                PI.fldDeactivatedDate = now()

            WHERE 
                SC.fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype="integer">
        </cfquery>
        <!--- <cfset structDelete(application, "cachedSubCategories")> --->
        <cfreturn true>
    </cffunction>

</cfcomponent>
