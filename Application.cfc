<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.sessionManagement = "true">
    <cfset this.dataSource = "ShoppingCart">
        <cfset application.shoppingCart = createObject("component","component.shoppingcart")>

<!---<cffunction  name="onApplicationStart" returnType = "boolean">
        <cfset application.shoppingCart = createObject("component","component.shoppingcart")>
        <cfreturn true>
    </cffunction> --->

    <cffunction  name="onRequestStart" returnType="boolean"> 
        <cfargument name="targetPage" type="String" required=true> 
        <cfif structKeyExists(session, "userId") OR targetPage EQ "/login.cfm">
            <cfreturn true>
        <cfelse>
            <cflocation  url = "/login.cfm">
        </cfif>


        <!---         <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif> --->
    </cffunction>

    <cffunction name="onMissingTemplate" returnType="boolean">
        <cfargument type="string" name="targetPage" required=true/>
        <cfreturn BooleanValue />
    </cffunction>

    <cffunction name="onError" returnType="void">
        <cfargument name="Exception" required=true/>
        <cfargument name="EventName" type="String" required=true/>
    ...
    </cffunction>
</cfcomponent>
