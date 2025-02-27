<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.sessionManagement = "true">
    <cfset this.sessiontimeout =createTimespan(0, 0, 45, 0)>
    <cfset this.dataSource = "ShoppingCart">

    <cffunction  name="onApplicationStart" returnType = "boolean">
        <cfset application.shoppingCart = createObject("component","component.shoppingcart")>  
        <cfset application.user = createObject("component","component.user")>  
        <cfset application.admin = createObject("component","component.admin")>  
        <cfquery name="local.queryGetAppConfig">
            SELECT 
                fldValue
            FROM 
                tblappconfiguration
            WHERE 
                fldKey = "secretKey"
        </cfquery>
        <cfset application.key = local.queryGetAppConfig.fldValue>
        <cfreturn true>
    </cffunction>

    <cffunction  name="onRequestStart" returnType="boolean"> 
        <cfargument name="requestPage" type="String" required=true>

        <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>  
            <cfreturn true> 
        </cfif>

        <cfset local.adminPages = ["/admin/category.cfm", 
                                    "/admin/subCategory.cfm", 
                                    "/admin/product.cfm"]>
        <cfset local.loggedInUserAllowedPages = ["/order.cfm",
                                    "/orderDetails.cfm", 
                                    "/generateInvoice.cfm"]>
        <cfif arrayContains(local.adminPages, arguments.requestPage)>
            <cfif structKeyExists(session, "userId") AND session.roleId EQ 1>
                <cfreturn true>
            <cfelse>
                <cflocation  url = "/home.cfm" addtoken = "no">  
            </cfif>
        <cfelseif arrayContains(local.loggedInUserAllowedPages, arguments.requestPage)>
            <cfif structKeyExists(session, "userId") AND (session.roleId EQ 2 OR session.roleId EQ 1)>
                <cfreturn true>
            <cfelse>
                <cflocation  url = "/home.cfm" addtoken = "no">  
            </cfif>
        </cfif>

        <cfreturn true>
    </cffunction>

    <cffunction name="onRequest" returnType="void">
        <cfargument name="targetPage" type="String" required=true>
                
        <cfinclude  template="header.cfm">
        <cfinclude  template="#arguments.targetPage#">
        <cfinclude  template="footer.cfm">
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

<!---     <cffunction name="onError">
        <cfargument name="Exception" required=true>
        <cfargument type="String" name="EventName" required=true>

        <cflog file="#This.Name#" type="error"
        text="Event Name: #Arguments.Eventname#" >
        <cflog file="#This.Name#" type="error"
        text="Message: #Arguments.Exception.message#">
        <cfif NOT (Arguments.EventName IS "onSessionEnd") OR
        (Arguments.EventName IS "onApplicationEnd")>
            <cfoutput>
                <div class="text-center mt-4">
                    <h4>An unexpected error occurred.</h4>
                    <a href="/home.cfm" class="btn btn-primary mt-3">
                        <i class="fa-solid fa-shopping-cart me-2"></i> Continue Shopping
                    </a>
                </div>
            </cfoutput>

            <cfmail to ="gosalram554@gmail.com" from = "gosalram554@gmail.com" subject="An error occured in shoppingcart.com">
                Error Event: #Arguments.EventName#
                Error message: #Arguments.Exception.message#
                Line: #arguments.exception.tagContext[1].Line#
                Template: #arguments.exception.tagContext[1].template#
                #arguments.exception.tagContext[1].raw_trace#
            </cfmail>
        </cfif>
    </cffunction> --->

</cfcomponent>
