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

    <cffunction  name="addCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="categoryName">

        <cfset local.addCategoryResult = "">
        <cfquery name="local.queryAddCategory">
            INSERT INTO 
                tblCategory(fldCategoryName,fldCreatedBy)
            VALUES (
                <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "CF_SQL_VARCHAR">,
                <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            )
        </cfquery> 
        <cfset local.addCategoryResult = "Category Added">
        <cfreturn local.addCategoryResult>
    </cffunction>

    <cffunction  name="editCategory" access = "remote" returnFormat = "JSON">
        <cfargument type="string" required="true" name="categoryName">
        <cfargument required="true" name="categoryId">

        <cfset local.editCategoryResult = "">
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
        <cfreturn local.editCategoryResult>
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
    
</cfcomponent>