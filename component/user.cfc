<cfcomponent>
    <!---User--->
    <cffunction  name="addToCart" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name="productId" type="integer" required="false">
        
        <cfset local.addToCartResult = { "resultMsg" = "","cartId" = "", "quantity" = ""}>
        <cfif structKeyExists(arguments, "productId")>
            <!---  EXISTING PRODUCT IN CART CHECK  --->
            <cfquery name ="local.queryAddToCartNewProductCheck">
                SELECT 
                    fldQuantity,fldCart_Id
                FROM 
                    tblcart 
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">     
            </cfquery>
            <cfif local.queryAddToCartNewProductCheck.recordcount GT 0>
                <cfset local.updatedQuantity = local.queryAddToCartNewProductCheck.fldQuantity + 1>
                <cfset variables.encryptedCartId = encrypt("#local.queryAddToCartNewProductCheck.fldCart_Id#",application.key,"AES","Base64")>
                <cfset variables.encodedCartId = encodeForURL(variables.encryptedCartId)>
                <cfset local.addToCartResult["cartId"] = variables.encodedCartId>
                <!--- PRODUCT UPDATE--->
                <cfquery name ="local.queryUpdateCart">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = <cfqueryparam value = "#local.updatedQuantity#"  cfsqltype = "integer">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype="integer"> 
                </cfquery>
                <cfset local.addToCartResult["resultMsg"] = "Cart Updated">
                <cfset local.addToCartResult["quantity"] = local.updatedQuantity>

            <cfelse>
                <!--- NEW PRODUCT ADD TO CART     --->
                <cfquery name ="local.queryAddToCart" result = "local.resultqueryAddToCart">
                    INSERT INTO 
                        tblcart(fldUserId,
                                fldProductId,
                                fldQuantity
                            )
                    VALUES(
                        <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                        <cfqueryparam value = "1" cfsqltype = "integer">
                    )
                </cfquery>
                <cfset local.addToCartResult["resultMsg"] = "Product added to the Cart">
                <cfset variables.encryptedCartId = encrypt("#local.resultqueryAddToCart.generated_Key#",application.key,"AES","Base64")>
                <cfset variables.encodedCartId = encodeForURL(variables.encryptedCartId)>
                <cfset local.addToCartResult["cartId"] = variables.encodedCartId>
                <cfset local.addToCartResult["quantity"] = 1>
            </cfif>
        </cfif>
        <!--- updating cart count for header display purpose--->
        <cfset session.cartCount = getUserCartCount() >
        <cfreturn local.addToCartResult>
    </cffunction> 

    <cffunction  name="fetchCart" access = "public" returnType = "array">
        <cfargument  name="cartId" type="integer" required ="false">

        <cfset local.fetchCartResultMsg = "">
        <cfquery name ="local.queryFetchCartDetails">
            SELECT 
                C.fldCart_Id,
                C.fldProductId,
                C.fldQuantity,
                P.fldProductName,
                P.fldBrandId,
                P.fldPrice,
                P.fldTax,
                B.fldBrandName,
                PI.fldImageFilename
            FROM 
                tblcart C
                INNER JOIN tblproduct P ON C.fldProductId = P.fldProduct_Id
                INNER JOIN tblproductimages PI ON C.fldProductId = PI.fldProductId 
                INNER JOIN tblbrands B ON P.fldBrandId = B.fldBrand_Id
            WHERE
                C.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">     
                AND PI.fldDefaultImage = 1
            <cfif structKeyExists(arguments, "cartId")>
                AND C.fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype="integer">
            </cfif>
        </cfquery>
        <cfset local.fetchCartResultMsg = "cart Details fetched successfully">
        <cfset local.cartDetailsArray = []>
        <cfloop query="local.queryFetchCartDetails">
            <cfset local.cart = {
                "cartId" = local.queryFetchCartDetails.fldCart_Id,
                "productId" = local.queryFetchCartDetails.fldProductId,
                "quantity" = local.queryFetchCartDetails.fldQuantity,
                "productName" = local.queryFetchCartDetails.fldProductName,
                "price" = local.queryFetchCartDetails.fldPrice,
                "tax" = local.queryFetchCartDetails.fldTax,
                "brandName" = local.queryFetchCartDetails.fldBrandName,
                "defaultImg" = local.queryFetchCartDetails.fldImageFilename
            }>
            <cfset arrayAppend(local.cartDetailsArray, local.cart)>
        </cfloop>
        <!---         <cfset arrayAppend(local.cartDetailsArray, local.fetchCartResultMsg)> --->
        <cfreturn local.cartDetailsArray>
    </cffunction>

    <cffunction  name="deleteCartItem" access="remote" returnType = "boolean" >
        <cfargument  name="cartId" type="integer" required ="false">
        <cfargument  name="productId" type="integer" required ="false">

        <cfquery name = "local.queryDeleteCartItem" >
            DELETE FROM 
                tblCart
            WHERE 
                <cfif structKeyExists(arguments, "cartId")>
                    fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype="integer">
                <cfelseif structKeyExists(arguments, "productId")>
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype="integer">
                </cfif>
        </cfquery>
        <cfset session.cartCount = getUserCartCount()>
        <cfreturn true>
    </cffunction>

    <cffunction  name="editCart" access = "remote" returnType ="struct" returnFormat = "JSON">
        <cfargument  name="cartId" type="integer" required ="true">
        <cfargument  name="quantity" type="integer" required ="true">

        <cfset local.editCartResult = {"resultMsg" = ""}>
        <cfif structKeyExists(arguments, "quantity") AND arguments.quantity GT 0>
            <cfquery name = "local.queryEditCartItem">
                UPDATE 
                    tblCart
                SET 
                    fldQuantity = <cfqueryparam value = "#arguments.quantity#" cfsqltype="integer">
                WHERE
                    fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype="integer">
            </cfquery>
            <cfset local.editCartResult["resultMsg"] = "Cart Updated">
            <cfset local.editCartResult["updatedQuantity"] = arguments.quantity>
        </cfif>
        <cfreturn local.editCartResult>
    </cffunction>

    <cffunction  name="getUserCartCount" access = "public" returnType = "numeric"> 
        <cfquery name ="local.querygetCartCount">
            SELECT 
                fldProductId
            FROM 
                tblcart 
            WHERE
                fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">     
        </cfquery>
        <cfreturn local.querygetCartCount.recordCount>
    </cffunction>

    <cffunction  name="updateUserInfo" access = "public" returnType = "struct">
        <cfargument name="firstName" type="string" required="yes">
        <cfargument name="lastName" type="string" required="yes">
        <cfargument name="emailId" type="string" required="yes">
        <cfargument name="phone" type="string" required="yes">

        <!---Validation--->
        <cfset local.updateUserInfoResult = {"resultMsg" = ""}>
        <cfif len(trim(arguments.firstName)) EQ 0>
            <cfset local.updateUserInfoResult["resultMsg"] = "First Name is required.">
        </cfif>
        <cfif len(trim(arguments.lastName)) EQ 0>
            <cfset local.updateUserInfoResult["resultMsg"] = "Last Name is required.">
        </cfif>
        <cfif isValid("email", arguments.emailId) EQ  0>
            <cfset local.updateUserInfoResult["resultMsg"] = "Enter a valid Email ID.">
        </cfif> 
        <cfif NOT isNumeric(arguments.phone) OR len(trim(arguments.phone)) NEQ 10 >
            <cfset local.updateUserInfoResult["resultMsg"] = "Enter a valid 10-digit phone number.">
        </cfif>

        <cfquery name ="local.queryUserUniqueCheck">
            SELECT 
                fldEmail,
                fldPhone
            FROM 
                tblUser 
            WHERE(
                fldEmail = <cfqueryparam value = "#arguments.emailId#" cfsqltype="VARCHAR"> 
                OR fldPhone = <cfqueryparam value = "#arguments.phone#" cfsqltype="VARCHAR">)
                AND fldEmail !=<cfqueryparam value = "#session.email#" cfsqltype="VARCHAR">
                AND fldPhone != <cfqueryparam value = "#session.phone#" cfsqltype="VARCHAR">
                AND fldActive = <cfqueryparam value="1" cfsqltype="INTEGER">       
        </cfquery>
        <cfif local.queryUserUniqueCheck.recordcount GT 0>
            <cfset local.updateUserInfoResult["resultMsg"] = "User mail or phone already exists">
        </cfif>
        <cfif len(trim(local.updateUserInfoResult["resultMsg"])) GT 0>
            <cfreturn local.updateUserInfoResult>
        <cfelse>
            <cfquery name = "local.queryUpdateUserInfo">
                UPDATE 
                    tbluser
                SET
                    fldFirstName = <cfqueryparam value = "#arguments.firstName#" cfsqltype = "VARCHAR">,
                    fldLastName = <cfqueryparam value = "#arguments.lastName#" cfsqltype = "VARCHAR">,
                    fldEmail = <cfqueryparam value = "#arguments.emailId#" cfsqltype = "VARCHAR">,
                    fldPhone = <cfqueryparam value = "#arguments.phone#" cfsqltype = "VARCHAR">
                WHERE
                    fldUser_Id = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
            </cfquery>
            <cfset session.firstName = arguments.firstName>
            <cfset session.lastName = arguments.lastName>
            <cfset session.email = arguments.emailId>
            <cfset session.phone = arguments.phone>
            <cfset local.updateUserInfoResult["resultMsg"] = "User details Updated">
        </cfif>
        <cfreturn local.updateUserInfoResult>
    </cffunction>

    <cffunction  name="fetchAddresses" access = "public" returnType = "array">
        <cfargument name="addressId" type="integer" required="no">
        <cfquery name="local.queryGetAddresses">
            SELECT 
                fldAddress_Id,
                fldFirstName,
                fldLastName,
                fldAddressLine1,
                fldAddressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhone
            FROM 
                tbladdress
            WHERE 
                fldActive = 1
                AND fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                <cfif structKeyExists(arguments, "addressId")>
                    AND fldAddress_Id = <cfqueryparam value="#arguments.addressId#" cfsqltype="integer">
                </cfif>
        </cfquery>

        <cfset local.addressesArray = []>

        <cfloop query="local.queryGetAddresses">
            <cfset local.address = {
                "addressId" = local.queryGetAddresses.fldAddress_Id,
                "firstName" = local.queryGetAddresses.fldFirstName,
                "lastName" = local.queryGetAddresses.fldLastName,
                "addLine1" = local.queryGetAddresses.fldAddressLine1,
                "addLine2" = local.queryGetAddresses.fldAddressLine2,
                "city" = local.queryGetAddresses.fldCity,
                "state" = local.queryGetAddresses.fldState,
                "pincode" = local.queryGetAddresses.fldPincode,
                "phone" = local.queryGetAddresses.fldPhone
            }>
            <cfset arrayAppend(local.addressesArray, local.address)>
        </cfloop>

        <cfreturn local.addressesArray>
    </cffunction>

    <cffunction  name="addNewAddress" access = "remote" returnType = "struct" returnFormat ="JSON">
        <cfargument name="firstName" type="string" required="yes">
        <cfargument name="lastName" type="string" required="yes">
        <cfargument name="phone" type="string" required="yes">
        <cfargument name="addLine1" type="string" required="yes">
        <cfargument name="addLine2" type="string" required="yes">
        <cfargument name="city" type="string" required="yes">
        <cfargument name="state" type="string" required="yes">
        <cfargument name="pincode" type="string" required="yes">
        <!---Validation--->
        <cfset local.addNewAddressResult = { "resultMsg" = ""}>
        <cfif len(trim(arguments.firstName)) EQ 0>
            <cfset local.addNewAddressResult["resultMsg"] = "First Name is required.">
        </cfif>
        <cfif len(trim(arguments.lastName)) EQ 0>
            <cfset local.addNewAddressResult["resultMsg"] = "Last Name is required.">
        </cfif>
        <cfif NOT isNumeric(arguments.phone) OR len(trim(arguments.phone)) NEQ 10>
            <cfset local.addNewAddressResult["resultMsg"] = "Enter a valid 10-digit phone number.">
        </cfif>
        <cfif len(trim(arguments.addLine1)) EQ 0>
            <cfset local.addNewAddressResult["resultMsg"] = "Address Line 1 is required.">
        </cfif>
        <cfif len(trim(arguments.addLine2)) EQ 0>
            <cfset local.addNewAddressResult["resultMsg"] = "Address Line 2 is required.">
        </cfif>
        <cfif len(trim(arguments.city)) EQ 0>
            <cfset local.addNewAddressResult["resultMsg"] = "City is required.">
        </cfif>
        <cfif len(trim(arguments.state)) EQ 0>
            <cfset local.addNewAddressResult["resultMsg"] = "State is required.">
        </cfif>
        <cfif NOT isNumeric(arguments.pincode) OR len(trim(arguments.pincode)) NEQ 6>
            <cfset local.addNewAddressResult["resultMsg"] = "Enter a valid 6-digit pincode.">
        </cfif>
        <cfif len(trim(local.addNewAddressResult["resultMsg"])) GT 0>
            <cfreturn local.addNewAddressResult>
        <cfelse>
            <cfquery name ="local.queryAddNewAddress">
                INSERT INTO 
                    tbladdress(
                            fldUserId,
                            fldFirstName,
                            fldLastName,
                            fldPhone,
                            fldAddressLine1,
                            fldAddressLine2,
                            fldCity,
                            fldState,
                            fldPincode,
                            fldActive)
                VALUES(
                    <cfqueryparam value = "#session.userId#" cfsqltype = "INTEGER">,
                    <cfqueryparam value = "#arguments.firstName#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.lastName#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.phone#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.addLine1#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.addLine2#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.city#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.state#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "#arguments.pincode#" cfsqltype = "VARCHAR">,
                    <cfqueryparam value = "1" cfsqltype = "INTEGER">
                )
            </cfquery>
            <cfset local.addNewAddressResult["resultMsg"] = "New Address added">
        </cfif>
        <cfreturn local.addNewAddressResult>
    </cffunction>

    <cffunction  name="deleteAddress" access="remote" returnType = "boolean" >
        <cfargument  name="addressId" type="integer" required ="true">

        <cfquery name = "local.querySoftDeleteAddress" >
            UPDATE 
                tbladdress
            SET 
                fldActive = 0 , 
                fldDeactivatedDate = now()
            WHERE 
                fldAddress_Id = <cfqueryparam value = "#arguments.addressId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="placeOrder" access="remote" returnType = "struct" returnFormat ="JSON">
        <cfargument  name="cardNumber" type="string" required ="true">
        <cfargument  name="cvv" type="string" required ="true">
        <cfargument  name="selectedAddress" type="string" required ="true">
        <cfargument  name="totalPrice" type="string" required ="true">
        <cfargument  name="totalTax" type="string" required ="true">
        <cfargument  name="productId" type="string" required ="true">

        <cfset local.cardNumber = "1111111111111111">
        <cfset local.cvv = "111">
        <cfset local.placeOrderResult = { "resultMsg" = "","cartCount" = ""}>
        <cfif NOT isNumeric(arguments.cardNumber) OR len(trim(arguments.cardNumber)) NEQ 16>
            <cfset local.placeOrderResult["resultMsg"] = "Enter a valid card number (16 digits).">
        </cfif>
        <cfif NOT isNumeric(arguments.cvv) OR len(trim(arguments.cvv)) NEQ 3 >
            <cfset local.placeOrderResult["resultMsg"] = "Enter a valid CVV (3 or 4 digits).">
        </cfif>
        <cfif len(trim(local.placeOrderResult["resultMsg"])) GT 0>
            <cfreturn local.placeOrderResult>
        <cfelse>

            <cfif (arguments.cardNumber EQ local.cardNumber) AND (arguments.cvv EQ local.cvv)>
                <cfset local.orderId = createUUID()>
                <cfif arguments.productId NEQ 0>
                    <!---Product ordering using  Buy Now  --->
                    <cfstoredproc procedure="spOrderBuyNow">
                        <cfprocparam cfsqltype="VARCHAR" variable="orderId" value="#local.orderId#">
                        <cfprocparam cfsqltype="integer" variable="userId" value="#session.userId#">
                        <cfprocparam cfsqltype="integer" variable="addressId" value="#arguments.selectedAddress#">
                        <cfprocparam cfsqltype="decimal" variable="totalPrice" value="#arguments.totalPrice#">
                        <cfprocparam cfsqltype="decimal" variable="totalTax" value="#arguments.totalTax#">
                        <cfprocparam cfsqltype="integer" variable="productId" value="#arguments.productId#">
                    </cfstoredproc>
                <cfelse>
                    <!---Product ordering using Cart Checkout --->
                    <cfstoredproc procedure="spOrderCartCheckout">
                        <cfprocparam cfsqltype="VARCHAR" variable="orderId" value="#local.orderId#">
                        <cfprocparam cfsqltype="integer" variable="userId" value="#session.userId#">
                        <cfprocparam cfsqltype="integer" variable="addressId" value="#arguments.selectedAddress#">
                        <cfprocparam cfsqltype="decimal" variable="totalPrice" value="#arguments.totalPrice#">
                        <cfprocparam cfsqltype="decimal" variable="totalTax" value="#arguments.totalTax#">
                    </cfstoredproc>
                </cfif>
                <!--- updating cart count for header display purpose--->
                <cfset session.cartCount = getUserCartCount()>
                <cfset local.placeOrderResult["resultMsg"] = "Order placed SuccessFully and cart updated">
                <cfset local.placeOrderResult["cartCount"] = session.cartCount>
                <cfset local.orderDetails = fetchOrderHistory(orderId = local.orderId)>
                <cfset local.order = local.orderDetails[1]>
                <cfmail to ="#session.email#" from="gosalram554@gmail.com" subject="Your Order Confirmation - #local.orderId#">
                Dear #local.order.firstName# #local.order.lastName#,
                
                Your order has been successfully placed.  
                Order Details: 
                Order ID: #local.order.orderId#  
                Order Date: #dateFormat(local.order.orderDate, 'dd/mm/yyyy')#  
                
                Billing Address:
                #local.order.firstName# #local.order.lastName#  
                #local.order.addressLine1#  
                #local.order.city#, #local.order.state#  
                #local.order.pincode#  
                Phone: #local.order.phone#  
                
                Items Ordered: 
                <cfloop from="1" to="#arrayLen(local.order.productNames)#" index="i">
                - #local.order.productNames[i]#  
                  Quantity: #local.order.quantities[i]#  
                  Price per Unit : Rs. #local.order.unitPrices[i]#  
                  Tax per Unit: Rs. #local.order.unitTaxes[i]#  
                  Total: Rs. #local.order.totalPrice#
                </cfloop>
                Grand Total: Rs. #local.order.totalPrice#  
                
                Best regards,  
                ShoppingCart  
                </cfmail>
                
            <cfelse>
                <cfset local.placeOrderResult["resultMsg"] = "Invalid Card">
            </cfif>
        </cfif>               
        <cfreturn local.placeOrderResult>
    </cffunction>

    <cffunction  name="fetchOrderHistory" access= "remote" returnType = "array" returnFormat ="JSON" >        
        <cfargument  name="orderId" type="string" required ="false">
        <cfargument  name="searchTerm" type="string" required ="false">
        <cfargument  name="page" type="integer" required ="false">
        <cfargument  name="limit" type="integer" required ="false" default = "10">

        <cfquery name="local.queryGetOrders">
            SELECT 
                O.fldOrder_Id,
                O.fldTotalPrice,
                O.fldTotalTax,
                O.fldOrderDate,
                GROUP_CONCAT(OI.fldQuantity) AS fldQuantity,
                GROUP_CONCAT(OI.fldUnitPrice) AS fldUnitPrice,
                GROUP_CONCAT(OI.fldUnitTax) AS fldUnitTax ,
                A.fldFirstName,
                A.fldLastName,
                A.fldAddressLine1,
                A.fldAddressLine2,
                A.fldCity,
                A.fldState,
                A.fldPincode,
                A.fldPhone,
                GROUP_CONCAT(P.fldProductName) AS fldProductName,
                GROUP_CONCAT(PI.fldImageFileName) AS fldImageFileName
            FROM 
                tblorder O
                INNER JOIN tblorderitems OI ON O.fldOrder_Id = OI.fldOrderId
                INNER JOIN tbladdress A ON A.fldAddress_Id = O.fldAddressId 
                INNER JOIN tblproduct P ON OI.fldProductId = P.fldProduct_Id
                INNER JOIN tblbrands B ON B.fldBrand_Id  = P.fldBrandId 
                INNER JOIN tblproductimages PI ON PI.fldProductId  = P.fldProduct_Id 
                    AND PI.fldDefaultImage = 1 AND PI.fldActive = 1
            WHERE 
                O.fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                <cfif structKeyExists(arguments, "orderId")>
                    AND O.fldOrder_Id = <cfqueryparam value="#arguments.orderId#" cfsqltype="VARCHAR">
                </cfif>

                <cfif structKeyExists(arguments, "searchTerm")>
                    AND (O.fldOrder_Id LIKE <cfqueryparam value="%#trim(arguments.searchTerm)#%" cfsqltype="VARCHAR">
                    OR P.fldProductName LIKE <cfqueryparam value="%#trim(arguments.searchTerm)#%" cfsqltype="VARCHAR">
                    OR O.fldOrderDate LIKE <cfqueryparam value="%#trim(arguments.searchTerm)#%" cfsqltype="VARCHAR">)
                </cfif>
			GROUP BY
				O.fldOrder_Id
            ORDER BY
                O.fldOrderDate DESC
            <cfif structKeyExists(arguments, "page") AND val(arguments.page) GT 0>
                <cfset local.offset = (arguments.page - 1) * arguments.limit>
            <cfelse>
                <cfset local.offset = 0>
            </cfif>
            LIMIT #arguments.limit# OFFSET #local.offset#
        </cfquery>

        <cfset local.ordersArray = []>

        <cfloop query="local.queryGetOrders">
            <cfset local.order = {
                "orderId" = local.queryGetOrders.fldOrder_Id,
                "totalPrice" = local.queryGetOrders.fldTotalPrice,
                "totalTax" = local.queryGetOrders.fldTotalTax,
                "orderDate" = local.queryGetOrders.fldOrderDate.toString(),
                "quantities" = ListToArray(local.queryGetOrders.fldQuantity),
                "unitPrices" = ListToArray(local.queryGetOrders.fldUnitPrice),
                "unitTaxes" = ListToArray(local.queryGetOrders.fldUnitTax),
                "firstName" = local.queryGetOrders.fldFirstName,
                "lastName" = local.queryGetOrders.fldLastName,
                "addressLine1" = local.queryGetOrders.fldAddressLine1,
                "addressLine2" = local.queryGetOrders.fldAddressLine2,
                "city" = local.queryGetOrders.fldCity,
                "state" = local.queryGetOrders.fldState,
                "pincode" = local.queryGetOrders.fldPincode,
                "phone" = local.queryGetOrders.fldPhone,
                "productNames" = ListToArray(local.queryGetOrders.fldProductName),
                "productImages" = ListToArray(local.queryGetOrders.fldImageFileName)
            }>

            <cfset arrayAppend(local.ordersArray, local.order)>
        </cfloop>
         <cfreturn local.ordersArray> 
    </cffunction>

</cfcomponent>
