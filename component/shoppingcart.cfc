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
        <cfif local.queryUserLogin.recordcount GT 0>
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
                fldCategoryName,fldCategory_Id
            FROM 
                tblcategory
            WHERE 
                fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> AND
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">
        </cfquery> 
        <cfreturn local.queryGetCategories>
    </cffunction>

    <cffunction  name="fetchSubCategories">
        <cfargument  name="categoryId">
        <cfquery name="local.queryGetSubCategories">
            SELECT 
                fldSubCategoryName,fldSubCategory_Id
            FROM 
                tblSubCategory
            WHERE 
                fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> AND
                fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "CF_SQL_VARCHAR">AND
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">
        </cfquery> 
        <cfreturn local.queryGetSubCategories>
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

    <cffunction  name="addCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="categoryName">       
        <cfset local.categoryId = 0>
        <cfif categoryUniqueCheck(arguments.categoryName,local.categoryId) GT 0>
            <cfset local.addCategoryResult = "Category Name already exists">
        <cfelse>
            <cfquery name="local.queryAddCategory" result = "local.resultQueryAddCategory">
                INSERT INTO 
                    tblCategory(fldCategoryName,fldCreatedBy)
                VALUES (
                    <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "CF_SQL_VARCHAR">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                )
            </cfquery> 
<!---             <cfset local.addCategoryResult = local.resultQueryAddCategory> --->
            <cfset local.addCategoryResult = "Category Added">
        </cfif>
        <cfreturn local.addCategoryResult>
    </cffunction>

    <cffunction  name="addSubCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="subCategoryName">       
        <cfargument type="string" required="true" name="selectedCategoryId">    
        <cfset local.subCategoryId = 0>   
        <cfif subCategoryUniqueCheck(arguments.subCategoryName,arguments.selectedCategoryId,local.subCategoryId) GT 0>
            <cfset local.addSubCategoryResult = "SubCategory Name already exists">
        <cfelse>
            <cfquery name="local.queryAddSubCategory" result = "local.resultQueryAddSubCategory">
                INSERT INTO 
                    tblsubcategory(fldSubCategoryName,fldCategoryId,fldCreatedBy)
                VALUES (
                    <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "CF_SQL_VARCHAR">,
                    <cfqueryparam value = "#arguments.selectedCategoryId#" cfsqltype = "CF_SQL_INTEGER">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                )
            </cfquery> 
            <cfset local.addSubCategoryResult = local.resultQueryAddSubCategory.generated_key>
        </cfif>
        <cfreturn local.addSubCategoryResult>
    </cffunction>

    <cffunction  name="editCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="categoryName">
        <cfargument required="true" name="categoryId">
        <cfset local.editCategoryResult = "">

        <cfif categoryUniqueCheck(arguments.categoryName,arguments.categoryId) GT 0>
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
        <cfset local.editSubCategoryResult = "">

        <cfif subCategoryUniqueCheck(arguments.subCategoryName,arguments..selectedCategoryId,arguments.subCategoryId) GT 0>
            <cfset local.editSubCategoryResult = "Sub Category Name already exists">
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
            <cfset local.editSubCategoryResult = "Sub Category Edited">
        </cfif>
        <cfreturn local.editSubCategoryResult>
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