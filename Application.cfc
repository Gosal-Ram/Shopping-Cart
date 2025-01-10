<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.sessionManagement = "true">
    <cfset this.dataSource = "dsShoppingCart">
    <cfset application.obj = createObject("component","component.shoppingcart")>
    <cfset allowedPages = ["/login.cfm"]>
    <cffunction  name="onRequest"> 
        <cfargument  name="requestPage">
        <cfif structKeyExists(session, "userInput") OR ArrayContains(allowedPages, requestPage)>
            <cfinclude template = "#arguments.requestPage#">
        <cfelse>
            <cfinclude template = "/login.cfm">
        </cfif>
    </cffunction>
</cfcomponent>
