<cfinclude template="header.cfm">
<cfif NOT structKeyExists(session, "cartCount") OR session.cartCount EQ 0>
    <div class="container text-center my-5">
        <img src="assets/images/empty-cart.svg" alt="" class="img-fluid emptyCartImg">
        <h3 class="mt-4 text-muted">Your cart is empty!</h3>
        <p class="text-muted">Looks like you haven't added anything to your cart yet.</p>
        <a href="home.cfm" class="btn btn-primary mt-3">
            <i class="fa-solid fa-shopping-cart me-2"></i> Continue Shopping
        </a>
    </div>
<cfelse>
    <cfset variables.getCartDetails = application.shoppingCart.fetchCart()>
    <cfoutput>
    <main>
        <div class="container my-3">
            <h2 class="mb-4">Cart</h2>
            <div class="row">
                <div class="col-md-8">
                    <cfloop array="#variables.getCartDetails#" index="local.item">
                        <div class="card mb-3 p-3 d-flex flex-row align-items-center" id = "#local.item.cartId#">
                            <img src="assets/images/productImages/#local.item.defaultImg#" alt="#local.item.productName#"
                                class="img-fluid me-3 cartProductImg" 
                                width = "100"
                                height = "100">
                            <div class="flex-grow-1">
                                <h5 class="mb-1">#local.item.productName#</h5>
                                <p class="text-muted">Brand: #local.item.brandName#</p>
                                <div class="d-flex align-items-center">
                                    <button type = "button"
                                        id = "btnDecrease"
                                        onClick = "decreaseCount(#local.item.cartId#)"
                                        class="btn btn-outline-primary btn-sm me-2 btn-quantity"
                                        <cfif local.item.quantity EQ 1>
                                            disabled
                                        </cfif>>-
                                    </button>

                                    <span class="mx-2" id="quantityCount_#local.item.cartId#">
                                        #local.item.quantity#
                                    </span>

                                    <button type = "button" 
                                        onClick = "increaseCount(#local.item.cartId#)" 
                                        class="btn btn-outline-primary btn-sm btn-remove">+
                                    </button>
                                </div>
                            </div>
                            <div class="text-end">
                                <h4>
                                    <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                    <cfset variables.productPrice = (local.item.quantity*local.item.price) + 
                                                                    (local.item.quantity*local.item.tax)>
                                    <span name ="productPrice">#variables.productPrice#</span>
                                </h4>
                                <p class="mb-0">
                                    Tax: 
                                    <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                    <cfset variables.productTax = local.item.quantity*local.item.tax>
                                    <span name="productTax">#variables.productTax#</span>
                                </p>
                                <p class="text-muted mb-0">
                                    Price: 
                                    <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                    <cfset variables.productActualPrice = local.item.quantity*local.item.price>
                                    <span name ="productActualPrice">#variables.productActualPrice#</span>
                                </p>
                                <button type = "button" 
                                    class="btn btn-secondary btn-sm mt-2" 
                                    onClick = "removeProduct(#local.item.cartId#)">
                                    Remove
                                </button>
                            </div>
                        </div>
                    </cfloop>
                </div> 
                <div class="col-md-4">
                    <div class="card p-3">
                        <h4 class="mb-3">Summary</h4>
                        <cfset variables.totalTax = 0>
                        <cfset variables.totalPrice = 0>
                        <cfset variables.actualPrice = 0>
                        
                        <cfloop array="#variables.getCartDetails#" index="local.item">
                            <cfset variables.totalTax = variables.totalTax + (local.item.quantity*local.item.tax)>
                            <cfset variables.actualPrice = variables.actualPrice + (local.item.quantity*local.item.price)>
                            <cfset variables.totalPrice = variables.totalPrice + 
                                (local.item.quantity*local.item.price) + 
                                (local.item.quantity*local.item.tax)>
                        </cfloop>

                        <p class="d-flex justify-content-between">
                            <span>Subtotal:</span> 
                            <strong>
                                <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                <span name="totalActualPrice">#variables.actualPrice#</span> 
                            </strong>
                        </p>
                        <p class="d-flex justify-content-between">
                            <span>Tax:</span>
                            <strong>
                                <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                <span name="totalTax"> #variables.totalTax#</span>
                            </strong>
                            </p>
                        <hr>
                        <h4 class="d-flex justify-content-between text-dark">
                            <span>Total:</span> 
                            <strong>
                                <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                <span name="totalPrice">#variables.totalPrice#</span> 
                            </strong>
                        </h4>
                        <a class="btn btn-success w-100 mt-3 proceedBtn text-dark fw-semibold rounded-pill"
                            href = "order.cfm">
                            Proceed to Checkout
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
    </cfoutput>
</cfif>
<cfinclude template="footer.cfm">
