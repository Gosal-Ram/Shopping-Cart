<cfinclude template="header.cfm">
<cfif NOT structKeyExists(session, "cartCount") OR session.cartCount EQ 0>
    <div class="container text-center my-5">
        <img src="assets/images/empty-cart.svg" alt="Empty Cart" class="img-fluid" style="max-width: 300px;">
        <h3 class="mt-4 text-muted">Your cart is empty!</h3>
        <p class="text-muted">Looks like you haven't added anything to your cart yet.</p>
        <a href="home.cfm" class="btn btn-primary mt-3">
            <i class="fa-solid fa-shopping-cart me-2"></i> Continue Shopping
        </a>
    </div>
<cfelse>

    <cfset variables.getCartDetails = application.shoppingCart.fetchCart()>
    <!---  <cfdump  var="#variables.getCartDetails#">  --->

    <cfoutput>
    <main>
        <div class="container my-3">
            <h2 class="mb-4">Cart</h2>
            <div class="row">
                <div class="col-md-8">
                    <cfloop array="#variables.getCartDetails#" index="item">
                    <div class="card mb-3 p-3 d-flex flex-row align-items-center" id = "#item.cartId#"  >
                        <img src="assets/images/productImages/#item.defaultImg#" alt="#item.productName#"
                            class="img-fluid me-3" 
                            style="width: 100px; height: 100px; object-fit: contain;">
                        <div class="flex-grow-1">
                            <h5 class="mb-1">#item.productName#</h5>
                            <p class="text-muted">Brand: #item.brandName#</p>
                            <div class="d-flex align-items-center">
                                <button type = "button" onClick = "decreaseCount(#item.cartId# , #item.quantity#)" class="btn btn-outline-primary btn-sm me-2 btn-quantity">-</button>
                                <span class="mx-2" id= "quantityCount">#item.quantity#</span>
                                <button type = "button" onClick = "increaseCount(#item.cartId# , #item.quantity#)" class="btn btn-outline-primary btn-sm btn-remove">+</button>
                            </div>
                        </div>
                        <div class="text-end">
                            <h4 class="text-darkproduct-price" 
                                data-base-price="#item.price#" 
                                data-tax="#item.tax#">
                                <i class="fa-solid fa-indian-rupee-sign me-1"></i>#numberFormat(item.price + item.tax, ".00")#
                            </h4>
                            <p class="mb-0">Tax: <i class="fa-solid fa-indian-rupee-sign me-1"></i>#numberFormat(item.tax, ".00")#</p>
                            <p class="text-muted">Price: <i class="fa-solid fa-indian-rupee-sign me-1"></i>#numberFormat(item.price, ".00")#</p>
                            <button type = "button" class="btn btn-primary btn-sm mt-2" onClick = "removeProduct(#item.cartId#)">Remove</button>
                        </div>
                    </div>
                    </cfloop>
                </div> 
                <div class="col-md-4">
                    <div class="card p-3">
                        <h4 class="mb-3">Summary</h4>
                        <cfset totalTax = 0>
                        <cfset totalPrice = 0>
                        <cfset actualPrice = 0>
                        <cfloop array="#variables.getCartDetails#" index="item">
                            <cfset totalTax = totalTax + item.tax>
                            <cfset actualPrice = actualPrice + item.price>
                            <cfset totalPrice = totalPrice + item.price + item.tax>
                        </cfloop>
                        <p class="d-flex justify-content-between"><span>Subtotal:</span> <strong id="actualPrice"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#numberFormat(actualPrice, ".00")#</strong></p>
                        <p class="d-flex justify-content-between"><span>Tax:</span> <strong id="totalTax"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#numberFormat(totalTax, ".00")#</strong></p>
                        <hr>
                        <h4 class="d-flex justify-content-between text-dark"><span>Total:</span> <strong id="totalPrice"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#numberFormat(totalPrice, ".00")#</strong></h4>
                        <button class="btn btn-success w-100 mt-3 proceedBtn text-dark fw-semibold rounded-pill">Proceed to Checkout</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
    </cfoutput>
</cfif>
<cfinclude template="footer.cfm">
