<cfinclude  template="header.cfm">
<cfset variables.queryGetAllOrders = application.shoppingCart.fetchOrderHistory()>

<cfif structKeyExists(form, "submitBtn")>
    <cfset variables.queryGetAllOrders = application.shoppingCart.fetchOrderHistory(searchTerm = form.searchInput)>
</cfif>

<cfoutput>
<main>
    <div class="container my-3">
        <h2 class="mb-4">Your Orders</h2>
        <form method="POST" class="searchInputDiv"> 
            <div class="input-group my-2">  
                <input class="form-control border-end-0 border rounded-pill" placeholder="Search OrderID" type="search" id="searchInput" name="searchInput">
                <span class="ms-2">
                <button  name = "submitBtn" class="btn btn-outline-secondary bg-white border-start-0 border rounded-pill" type="submit">
                    <i class="fa fa-search"></i>
                </button>
                </span>
            </div>
        </form>  
        <cfif arrayLen(variables.queryGetAllOrders) EQ 0>
            <p>No orders found.</p>
        <cfelse>
            <cfloop array="#variables.queryGetAllOrders#" item="local.order">
                <div class="card mb-4 orderContainer">
                    <div class="card-header orderCardHeader text-dark d-flex justify-content-between align-items-center">
                        <div class = "d-flex">
                            <div class = "d-flex flex-column mb-0">
                                <span class="orderTitle">ORDER PLACED</span>
                                <span>#dateTimeFormat(local.order.orderDate, "medium")#</span>
                            </div>

                            <div class = "d-flex flex-column mb-0 ms-5  ">
                                <span class="orderTitle">TOTAL</span>
                                <span>
                                    Rs.
                                    #local.order.totalPrice#
                                    <small class="text-muted">(Includes Tax: Rs. #local.order.totalTax#)</small>
                                </span>
                            </div>
                        </div>
                        <div class = "d-flex flex-column mb-0">
                            <span class="orderTitle">Order ID: #local.order.orderId#</span>
                            <a href="generateInvoice.cfm?orderId=#local.order.orderId#" target="_blank" class="">
                                Invoice
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <table class="table table-bordered table-hover align-middle">
                            <thead>
                                <tr class="text-center">
                                    <th>Image</th>
                                    <th>Product Name</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                </tr>
                            </thead>
                            <tbody class="">
                                <cfloop from="1" to="#arrayLen(local.order.productNames)#" index="i">
                                    <tr class="text-center">
                                        <td>
                                            <img src="./assets/images/productImages/#local.order.productImages[i]#" 
                                                alt="#local.order.productNames[i]#" 
                                                width="50" height="50">
                                        </td>
                                        <td>#local.order.productNames[i]#</td>
                                        <td class="text-center">#local.order.quantities[i]#</td>
                                        <td class="text-center">Rs. #local.order.unitPrices[i]#</td>
                                    </tr>
                                </cfloop>
                            </tbody>
                        </table>
                    </div>
                    <div class= "card-footer d-flex justify-content-between orderCardFooter">
                        <p class = "mb-0"><span class="orderTitle">Shipped to: </span>#local.order.addressLine1#, #local.order.city#, #local.order.state# - #local.order.pincode#</p>
                        <p class="mb-0"><span class="orderTitle">Contact: </span>#local.order.firstName# #local.order.lastName#
                            <span><span class="orderTitle">Phone: </span>#local.order.phone#</span>
                        </p>
                    </div>
                </div>
            </cfloop>
        </cfif>
    </div>
</main>
</cfoutput>
<cfinclude  template="footer.cfm">