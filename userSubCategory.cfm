<cfinclude  template="header.cfm">
<cfset variables.subCategoryId = decrypt(url.subCategoryId,application.key,"AES","Base64")>
<cfset variables.getCategoryId = application.shoppingCart.fetchSubCategories(subCategoryId = variables.subCategoryId)>
<cfset variables.categoryId = #variables.getCategoryId[1].categoryId#>
<cfset variables.subCategoryName = #variables.getCategoryId[1].subCategoryName#>
<cfset variables.getAllProducts = application.shoppingCart.fetchProducts(subCategoryId = variables.subCategoryId)>

<cfif structKeyExists(form, "sortASC")>
    <cfset variables.sortFlag = 1>
    <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(subCategoryId = variables.subCategoryId,
                                                                            sortFlag = variables.sortFlag)>
<cfelseif structKeyExists(form, "sortDESC")>
    <cfset variables.sortFlag = 2>
    <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(subCategoryId = variables.subCategoryId,
                                                                            sortFlag = variables.sortFlag)>
</cfif>

<cfif structKeyExists(form, "filterBtn")>
    <cfset variables.filterMin = form.filterMin>
    <cfset variables.filterMax = form.filterMax>
    <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(subCategoryId = variables.subCategoryId,
                                                                            filterMin = variables.filterMin,
                                                                            filterMax = variables.filterMax)>
</cfif>
<cfoutput>
    <main>
        <form method ="post"> 
        <div class="container-fluid my-3">
            <div class = "d-flex justify-content-between align-items-center">
                <div>
                    <h3 class="ms-3">#variables.subCategoryName#</h3>
                    <button class = "btn" name ="sortASC"  type = "submit"><span class = "min ASC">Price low to High</span></button>
                    <button class = "btn" name ="sortDESC" type = "submit"><span class = "max DESC ms-4">Price High to low</span></button>
                </div>
                <div class="dropdown">
                <button class="btn btn-secondary dropdown-toggle me-3" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    Filter
                </button>
                <div class="dropdown-menu">
                    <div class="d-flex filterInputContainer justify-content-between w-100">
                        <input class="w-75" type="number" name="filterMin" placeholder="MIN" value="">
                        <input class="w-75 ms-2" type="number" name="filterMax" placeholder="MAX" value=""> 
                    </div>
                    <button class = "ms-5 mt-2 btn btn-success" name ="filterBtn"  type = "submit">Filter</button>
                </div>
                </div>
            </div>
            <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3" id ="productListingContainer">
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
            <div class = "viewEditBtnDiv d-flex justify-content-end me-3">
                <button class = "btn btn-secondary" value = "4" id= "viewEditBtn" type = "button" name = "viewEditBtn" onclick = "toggleView(#variables.subCategoryId#)">
                    View More
                </button>
            </div>
        </div>
        <form>
    </main>
</cfoutput>
<cfinclude  template="footer.cfm">
