<cfinclude template="header.cfm">
<cfset variables.search = url.s>
<cfoutput>
<cfif Len(Trim(variables.search)) GT 0>
    <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(searchInput = variables.search)>
<cfelse>
    <cflocation  url="home.cfm" addToken="no"> 
</cfif>
<main>
    <div class="container-fluid my-3">
        <div class = "d-flex justify-content-between align-items-center">
            <div class ="h3 ms-3">
                Showing results for "#variables.search#"
            </div>
        </div>
        <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
            <cfloop query="variables.getAllProducts">
                <cfset variables.encryptedProductId = encrypt("#variables.getAllProducts.fldProduct_Id#",application.key,"AES","Base64")>
                <cfset variables.encodedProductId = encodeForURL(variables.encryptedProductId)>
                <a class = "card m-2 p-2 productCard text-decoration-none" 
                    href = "userProduct.cfm?productId=#variables.encodedProductId#">
                    <div>
                        <img src="./assets/images/productImages/#variables.getAllProducts.fldImageFilename#" 
                            class="w-100 productImg"  
                            alt="" 
                            height ="150">
                        <div class="card-body">
                            <h6 class="card-title" id ="#variables.getAllProducts.fldProduct_Id#">
                                #variables.getAllProducts.fldProductName#
                            </h6>
                            <p class="card-text text-muted mb-0">
                                #variables.getAllProducts.fldBrandName#
                            </p>
                            <p class="card-text text-dark fw-semibold mb-0">
                                <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                #variables.getAllProducts.fldPrice#
                            </p>
                            <p class="card-text productDescription mb-0">
                                #variables.getAllProducts.fldDescription#
                            </p>
                        </div>
                    </div>
                </a>
            </cfloop> 
        </div>
    </div>
</main>
</cfoutput>
<cfinclude  template="footer.cfm">