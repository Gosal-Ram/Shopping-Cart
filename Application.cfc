<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.sessionManagement = "true">
    <cfset this.dataSource = "ShoppingCart">
    <cffunction  name="onApplicationStart" returnType = "boolean">
        <cfset application.shoppingCart = createObject("component","component.shoppingcart")>
        <cfreturn true>
    </cffunction>

    <cffunction  name="onRequestStart" returnType="boolean"> 
        <cfargument name="requestPage" type="String" required=true> 

        <cfset local.userAllowedPages = ["/login.cfm", 
                                        "/signup.cfm", 
                                        "/home.cfm",
                                        "/userCategory.cfm", 
                                        "/userSubCategory.cfm", 
                                        "/searchResults.cfm",
                                        "/userProduct.cfm"]>
        <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>  
            <cfreturn true> 
        </cfif>  

        <cfif structKeyExists(session, "userId") OR arrayContains(userAllowedPages, requestPage) >
            <cfreturn true> 
        <cfelse>
            <cflocation  url = "/login.cfm">
            <cfreturn true> 
        </cfif>
    </cffunction>

    <cffunction name="onMissingTemplate" returnType="boolean">
        <cfargument name="targetPage" type="string" required=true/>
        <cflog type="error" text="Missing template: #Arguments.targetPage#">

        <cfoutput>
            <h3>#Arguments.targetPage# could not be found.</h3>
            <p>You requested a non-existent ColdFusion page.<br />
            Please check the URL.</p>
        </cfoutput>
        <cfreturn true  >
    </cffunction>


    <cffunction name="onError">
        <cfargument name="Exception" required=true>
        <cfargument type="String" name="EventName" required=true>

        <cflog file="#This.Name#" type="error"
        text="Event Name: #Arguments.Eventname#" >
        <cflog file="#This.Name#" type="error"
        text="Message: #Arguments.Exception.message#">
        <cfif NOT (Arguments.EventName IS "onSessionEnd") OR
        (Arguments.EventName IS "onApplicationEnd")>
            <cfoutput>
                <h2>An unexpected error occurred.</h2>
                <p>Please provide the following information to technical support:</p>
                <p>Error Event: #Arguments.EventName#</p>
                <p>Error details:<br>
                <cfdump var=#Arguments.Exception#></p>
            </cfoutput>
        </cfif>
    </cffunction>

<!--- 
    <cffunction name="onRequest" returnType="void">
    <cfargument name="targetPage" type="String" required=true/>
    ...
    <cfinclude template="#Arguments.targetPage#">
    ...
    </cffunction>

    <cffunction name="onRequestEnd" returnType="void">
    <cfargument type="String" name="targetPage" required=true/>
    ...
    </cffunction>  --->




</cfcomponent>
