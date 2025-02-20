<cfif NOT structKeyExists(session, "cartCount") OR session.cartCount EQ 0>
    <cflocation  url="cart.cfm" addToken="no">
<cfelse>
    <!--- declaring 0 for not to interfere with ordering a product via buyNow and cart checkout--->
    <cfset variables.productId = 0> 
    <cfif structKeyExists(url, "productId")>
        <!--- Product Ordering via Buy Now --->
        <cfset variables.productId = decrypt(url.productId, application.key, "AES", "Base64")>
        <cfset variables.cartId = decrypt(url.cartId, application.key, "AES", "Base64")>
        <cfset variables.getCartDetails = application.shoppingCart.fetchCart(cartId = variables.cartId)>
    <cfelse>
        <!---Product Ordering via Cart Checkout--->
        <cfset variables.getCartDetails = application.shoppingCart.fetchCart()>
    </cfif>
    <cfset variables.queryGetAddresses = application.shoppingCart.fetchAddresses()>
    <cfoutput>
    <main>
        <div class="container orderContainer my-3">
            <h2 class="mb-4">Checkout</h2>
            <div class="row">
                <div class="col-md-8">
                    <div class="accordion accordion-flush" id="accordionFlushExample">
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-semibold" 
                                type="button" 
                                data-bs-toggle="collapse" 
                                data-bs-target="##flush-collapseOne" 
                                aria-expanded="false" 
                                aria-controls="flush-collapseOne">
                                DELIVERY ADDRESS
                            </button>
                            </h2>
                            <div id="flush-collapseOne" class="accordion-collapse collapse show" data-bs-parent="##accordionFlushExample">
                                <cfif structKeyExists(variables, "queryGetAddresses") AND arrayLen(variables.queryGetAddresses) EQ 0>
                                    <div class="alert text-center p-3">
                                        <span class="fw-semibold text-danger">Please add at least one delivery address.</span>
                                        <br>
                                    </div>
                                </cfif>
                                <div class="accordion-body">
                                    <cfloop array="#variables.queryGetAddresses#" item="local.item">
                                        <div class="d-flex justify-content-between align-items-center" id="#local.item.addressId#">
                                            <input type="radio" name="selectedAddress" id="" value="#local.item.addressId#" class="me-2" checked>
                                            <label class="w-100">
                                                <div id="address-#local.item.addressId#" class="">
                                                    <p class="mb-1 fw-6">Name: 
                                                        <span class="fw-semibold text-dark">#local.item.firstName# #local.item.lastName#</span>
                                                    </p>
                                                    <p class="mb-0">Phone: 
                                                        <span class="fw-semibold text-dark">#local.item.phone#</span>
                                                    </p>
                                                    <p class="mb-1 fw-6">Address: 
                                                        <span class="fw-semibold text-dark">
                                                            #local.item.addLine1#  ,
                                                            #local.item.addLine2# ,
                                                            #local.item.city# ,
                                                            #local.item.state# 
                                                        </span>
                                                    </p>
                                                    <p class="mb-0">Pin: 
                                                        <span class="fw-semibold text-dark">#local.item.pincode#</span>
                                                    </p>
                                                </div>
                                            </label>
                                        </div>
                                        <hr>
                                    </cfloop>
                                    <button type="button" onClick = "openAddAddressModal()" class="btn btn-sm btn-success mt-1" data-bs-toggle="modal" data-bs-target="##addAddressModal">
                                        <i class="fa-solid fa-plus me-1"></i> Add New Address
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="##flush-collapseTwo" aria-expanded="false" aria-controls="flush-collapseTwo">
                                ORDER SUMMARY
                            </button>
                            </h2>
                            <div id="flush-collapseTwo" class="accordion-collapse collapse" data-bs-parent="##accordionFlushExample">
                                <cfif structKeyExists(variables, "getCartDetails") AND arrayLen(variables.getCartDetails) EQ 0>
                                    <div class="alert text-center p-3">
                                        <span class="fw-semibold text-danger">Your order is empty! Please add at least 1 item.</span>
                                        <br>
                                        <a href="home.cfm" class="btn btn-primary mt-2">Shop Products</a>
                                    </div>
                                </cfif>                            
                                <div class="accordion-body">      
                                    <cfloop array="#variables.getCartDetails#" index="local.item">
                                        <div class="card mb-3 p-3 d-flex flex-row align-items-center" id = "cartId_#local.item.cartId#">
                                            <img src="assets/images/productImages/#local.item.defaultImg#" alt="#local.item.productName#"
                                                class="img-fluid me-3 cartProductImg" 
                                                width = "100"
                                                height = "100">
                                            <div class="flex-grow-1">
                                                <h5 class="mb-1">#local.item.productName#</h5>
                                                <p class="text-muted">Brand: #local.item.brandName#</p>
                                                <cfif structKeyExists(url, "productId")>
                                                    <div class="d-flex align-items-center">
                                                        <button type = "button"
                                                            id="btnDecrease_#local.item.cartId#"
                                                            onClick = "decreaseCount(#local.item.cartId#)"
                                                            class="btn btn-outline-primary btn-sm me-2 btn-quantity"
                                                            >-
                                                        </button>
                                                        <span class="mx-2" id="quantityCount_#local.item.cartId#">#local.item.quantity#</span>
                                                        <button type = "button" 
                                                            id="btnIncrease_#local.item.cartId#"
                                                            onClick = "increaseCount(#local.item.cartId#,document)" 
                                                            class="btn btn-outline-primary btn-sm btn-remove">+
                                                        </button>
                                                    </div> 
                                                <cfelse>
                                                    <div class="d-flex align-items-center">
                                                        Quantity : #local.item.quantity#
                                                    </div> 
                                                </cfif>
                                            </div>
                                            <div class="text-end">
                                                <h4>
                                                    <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                                    <!---#lsCurrencyFormat((local.item.quantity*local.item.price + local.item.quantity*local.item.tax), "none", "en_IN")# --->
                                                    <span name ="productPrice">
                                                        #(local.item.quantity * local.item.price) + ((local.item.quantity * local.item.price * local.item.tax) / 100)#
                                                    </span>
                                                </h4>
                                                <p class="mb-0">
                                                    Tax: 
                                                    <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                                    <span name="productTax">#(local.item.quantity * local.item.price * local.item.tax) / 100#</span>
                                                </p>
                                                <p class="text-muted mb-0">
                                                    Price: 
                                                    <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                                    <span name ="productActualPrice">#(local.item.quantity*local.item.price)#</span>
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
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="##flush-collapseThree" aria-expanded="false" aria-controls="flush-collapseThree">
                                PAYMENT OPTIONS
                            </button>
                            </h2>
                            <div id="flush-collapseThree" class="accordion-collapse collapse" data-bs-parent="##accordionFlushExample">
                                <div class="accordion-body">
                                    <div class = "d-flex">
                                        <div>
                                            <label class="form-label">Enter Card Number</label>
                                            <input type="text" name="cardNumber" id="cardNumber" class="form-control" maxlength = "16" placeholder="XXXX XXXX XXXX XXXX">
                                            <span class="text-danger " id="cardNumberError"></span>
                                        </div>
                                        <div class = "ms-3">
                                            <label class="form-label">Enter CVV</label>
                                            <input type="text" name="cvv" id="cvv" class="form-control" maxlength = "3"  placeholder="XXX">
                                            <span class="text-danger " id="cvvError"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div> 
                <div class="col-md-4">
                    <div class="card p-3">
                        <h4 class="mb-3">Order Summary</h4>
                        <cfset variables.totalTax = 0>
                        <cfset variables.totalPrice = 0>
                        <cfset variables.actualPrice = 0>
                        <cfloop array="#variables.getCartDetails#" index="local.item">
                            <cfset local.itemTax = (local.item.quantity * local.item.price * local.item.tax) / 100>
                            <cfset variables.totalTax = variables.totalTax + local.itemTax>
                            <cfset variables.actualPrice = variables.actualPrice + (local.item.quantity*local.item.price)>
                            <cfset variables.totalPrice = variables.actualPrice + variables.totalTax>
                        </cfloop>
                        <p class="d-flex justify-content-between">
                            <span>Subtotal:</span> 
                            <strong id="actualPrice">
                                <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                <span id="totalActualPrice" name="totalActualPrice">#variables.actualPrice#</span>
                            </strong>
                        </p>
                        <p class="d-flex justify-content-between">
                            <span>Tax:</span>
                            <strong id="">
                                <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                <span id = "totalTax" name ="totalTax"> #variables.totalTax#</span> 
                            </strong>
                            </p>
                        <hr>
                        <h4 class="d-flex justify-content-between text-dark">
                            <span>Total:</span> 
                            <strong id="">
                                <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                <span id ="totalPrice" name="totalPrice">#variables.totalPrice#</span>
                            </strong>
                        </h4>
                        <button class="btn btn-success w-100 mt-3 proceedBtn text-dark fw-semibold rounded-pill"
                            onClick= "placeOrder(#variables.productId#)"
                            <!---button being hidden for if no address (or) removal of orders using buyNow--->
                            <cfif structKeyExists(variables, "queryGetAddresses") 
                                AND structKeyExists(variables, "getCartDetails") 
                                AND arrayLen(variables.queryGetAddresses) GT 0 
                                AND arrayLen(variables.getCartDetails) GT 0>
                            <cfelse>
                                hidden
                            </cfif>
                            >
                            PLACE YOUR ORDER
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div id = "resultContainer"></div>

        <!--- Add Address Modal --->
        <div class="modal fade" id="addAddressModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add New Address</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id ="userAddressAddForm" method="POST">
                            <div class="mb-3">
                                <label class="form-label">First Name</label>
                                <input type="text" class="form-control" id="receiverFirstName" name="receiverFirstName">
                                <span id="receiverFirstNameError" class="text-danger"></span>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="receiverLastName" name="receiverLastName">
                                <span id="receiverLastNameError" class="text-danger"></span>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Phone</label>
                                <input type="text" class="form-control" id="receiverPhone" maxlength="10" name="receiverPhone">
                                <span id="receiverPhoneError" class="text-danger"></span>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Address Line 1</label>
                                <textarea class="form-control" id="newAddressLine1" rows="3"></textarea>
                                <span id="addressLine1Error" class="text-danger"></span>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Address Line 2</label>
                                <textarea class="form-control" id="newAddressLine2" rows="3"></textarea>
                                <span id="addressLine2Error" class="text-danger"></span>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">City</label>
                                <input type="text" class="form-control" id="receiverCity" name="receiverCity">
                                <span id="cityError" class="text-danger"></span>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">State</label>
                                <input type="text" class="form-control" id="receiverState" name="receiverState">
                                <span id="stateError" class="text-danger"></span>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Pincode</label>
                                <input type="text" maxlength="6" class="form-control" id="receiverPin" name="receiverPin">
                                <span id="pincodeError" class="text-danger"></span>
                            </div>
                            <button type="button"
                                name = "userAddressSubmitBtn" 
                                onClick = "saveNewAddress()" 
                                class="btn btn-primary w-100">
                                Save Changes
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
    </cfoutput>
</cfif>
