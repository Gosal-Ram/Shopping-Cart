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
            <cfreturn true>
        </cfif>


        <!---         <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif> --->
    </cffunction>

    <cffunction name="onMissingTemplate" returnType="boolean">
        <cfargument name="targetPage" type="string" required=true/>
        <cflog type="error" text="Missing template: #Arguments.targetPage#">
        <cfoutput>
            <h3>#Arguments.targetPage# could not be found.</h3>
            <p>You requested a non-existent ColdFusion page.<br />
            Please check the URL.</p>
        </cfoutput>
        <!--- If an error occurs, return false and the default error
        handler will run. --->
        <cfreturn true />
    </cffunction>
<!---     <cffunction name="onError" returnType="void">
        <cfargument type="String" name="EventName" required=true/>
        <!--- Log all errors. --->
        <cflog file="#This.Name#" type="error"
        text="Event Name: #Arguments.Eventname#" >
        <cflog file="#This.Name#" type="error">
        <cflog file="#This.Name#" type="error">
        <!--- Display an error message if there is a page context. --->
        <cfif NOT (Arguments.EventName IS "onSessionEnd") OR
        (Arguments.EventName IS "onApplicationEnd")>
        <cfoutput>
        <h2>An unexpected error occurred.</h2>
        <p>Please provide the following information to technical support:</p>
        <p>Error Event: #Arguments.EventName#</p>
        <p>Error details:<br>
        </cfoutput>
        </cfif>
    </cffunction> --->
</cfcomponent>
