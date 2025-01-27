<cfinclude template="header.cfm">
<cfset variables.search = url.s>
<!--- <cfdump  var="#variables.search#">  --->
<cfoutput>
    <cfif Len(Trim(variables.search)) GT 0>
        <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(searchInput = variables.search)>
    <cfelse>
        <cflocation  url="home.cfm">
    </cfif>
<main>
    <div class="container-fluid my-3">
        <div class = "d-flex justify-content-between align-items-center">
            <div>
                <h3 class="ms-3"> Showing results for "#variables.search#"</h3>
            </div>
        </div>
            <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
                <cfloop query="variables.getAllProducts">
                    <cfset variables.encryptedProductId = encrypt("#variables.getAllProducts.fldProduct_Id#",application.key,"AES","Base64")>
                    <cfset variables.encodedProductId = encodeForURL(variables.encryptedProductId)>
                    <a class = "card m-2 p-2 productCard text-decoration-none" href = "userProduct.cfm?productId=#variables.encodedProductId#">
                    <div>
                        <img src="./assets/images/productImages/#variables.getAllProducts.fldImageFilename#" 
                            class="w-100"  
                            alt="" 
                            class=""
                            style="height: 150px; object-fit: contain;">
                        <div class="card-body">
                            <h6 class="card-title" id = "#variables.getAllProducts.fldProduct_Id#">#variables.getAllProducts.fldProductName#</h6>
                            <div class="card-text text-muted">  #variables.getAllProducts.fldBrandName#</div>
                            <div class="card-text text-dark fw-semibold"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#variables.getAllProducts.fldPrice#</div>
                            <div class="card-text productDescription">#variables.getAllProducts.fldDescription#</div>
                        </div>
                    </div>
                    </a>
                </cfloop> 
            </div>
    </div>
</main>

</cfoutput>

<cfinclude  template="footer.cfm">