<cfinclude  template="header.cfm">
<cfset variables.queryGetAllOrders = application.shoppingCart.fetchOrderHistory()>
<!--- <cfdump  var="#variables.queryGetAllOrders#"> --->

<cfoutput>
<main>
    <div class="container my-3">
        <h2 class="mb-4">My Orders</h2>
        <div class="">
            <input type="search" id="orderItemsSearch" class="form-control w-100" placeholder="Search OrderID"> 
        </div>
    </div>
</main>
</cfoutput>
<cfinclude  template="footer.cfm">