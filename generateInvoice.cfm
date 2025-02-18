<cfoutput>

<cfset variables.queryGetAllOrders = application.shoppingCart.fetchOrderHistory(orderId = url.orderId)>
<cfset variables.order = variables.queryGetAllOrders[1]>
<cfset variables.pdfFileName = "Invoice_#variables.order.orderId#_#dateTimeFormat(Now(), 'mm-dd-yyyy_HH-nn-ss')#.pdf">
<cfheader name="Content-Disposition" value="inline;filename= #variables.pdfFileName#">

<cfif structKeyExists(url, "orderId") AND len(trim(url.orderId))>
    <cfdocument format="PDF" pagetype="letter" orientation="portrait">
            <h2>Order Invoice</h2>
            <table width="100%" border="0" cellpadding="5" cellspacing="0">
                <tr>
                    <td width="50%" style="vertical-align: top;">
                        <p style="font-weight: bold;">Sold By</p>
                        <p>Shopping Cart<br>
                           ABC Internet Private Limited,<br>   
                           Bengaluru, 560103,<br>
                           Karnataka, India</p>
                    </td>
                    <td width="50%" style="vertical-align: top;">
                        <p style="font-weight: bold; text-align: right;">Billing Address</p>
                        <p style="text-align: right;">
                            #variables.order.firstName# #variables.order.lastName#<br>
                            #variables.order.addressLine1#,<br>
                            #variables.order.city#, #variables.order.state#<br> 
                            #variables.order.pincode#<br>
                            Phone: #variables.order.phone#
                        </p>
                    </td>
                </tr>
            </table>
            
            <p><span style="font-weight: bold;">Order ID: </span> #variables.order.orderId#</p>
            <p><span style="font-weight: bold;">Order Date: </span>#dateFormat(variables.order.orderDate, 'dd/mm/yyyy')#</p>
            <table border="1" cellpadding="5" cellspacing="0" width = "100%">
                <thead>
                    <tr>
                        <th></th>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Unit Tax</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop from="1" to="#arrayLen(variables.order.productNames)#" index="i">
                        <tr>
                            <td>#i#</td>
                            <td>#variables.order.productNames[i]#</td>
                            <td>#variables.order.quantities[i]#</td>
                            <td>Rs.#variables.order.unitPrices[i]#</td>
                            <td>Rs.#variables.order.unitTaxes[i]#</td>
                            <td>Rs.#variables.order.totalPrice#</td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
            <p><span style="font-weight: bold;">Grand Total</span>
                Rs.#variables.order.totalPrice#
            </p>
        </cfdocument>
<cfelse>
    <cflocation  url="orderDetails.cfm" addToken="no">
</cfif>

</cfoutput>
