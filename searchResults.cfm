<cfset variables.search = url.s>
<cfoutput>
<cfif Len(Trim(variables.search)) GT 0>
    <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(searchInput = variables.search)>
<cfelse>
    <cflocation  url="home.cfm" addToken="no"> 
</cfif>
<main>
    <div class="container-fluid my-3">
        <cfif arrayLen(variables.getAllProducts) GT 0>
            <div class = "d-flex justify-content-between align-items-center">
                <div class ="h3 ms-3">
                    Showing results for "#variables.search#"
                </div>
            </div>
            <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
                <cfloop array="#variables.getAllProducts#" item = "local.product">
                    <cfset variables.encryptedProductId = local.product.productId>
                    <cfset variables.encodedProductId = encodeForURL(variables.encryptedProductId)>
                    <a class = "card m-2 p-2 productCard text-decoration-none" 
                        href = "userProduct.cfm?productId=#variables.encodedProductId#">
                        <div>
                            <img src="./assets/images/productImages/#local.product.imageFilename#" 
                                class="w-100 productImg"  
                                alt="" 
                                height ="150">
                            <div class="card-body">
                                <h6 class="card-title" id ="#local.product.productId#">
                                    #local.product.productName#
                                </h6>
                                <p class="card-text text-muted mb-0">
                                    #local.product.brandName#
                                </p>
                                <p class="card-text text-dark fw-semibold mb-0">
                                    <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                    #local.product.price#
                                </p>
                                <p class="card-text productDescription mb-0">
                                    #local.product.description#
                                </p>
                            </div>
                        </div>
                    </a>
                </cfloop> 
            </div>
        <cfelse>
            <div class= "productListingContainer ms-5 mb-3 ">
                <h5>No results for "#variables.search#"</h5>
                <p>Try checking your spelling or use more general terms</p>
            </div>
        </cfif>
    </div>
</main>
</cfoutput>