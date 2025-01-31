<cfinclude template="header.cfm">
<cfset variables.categoryId = decrypt(url.categoryId,application.key,"AES","Base64")>
<cfoutput>
<main>
    <div class="container-fluid my-3 ms-3">
        <cfset variables.getCategoryNames = application.shoppingCart.fetchCategories(variables.categoryId)>
        <h2>#variables.getCategoryNames[1].categoryName#</h2> 
        <cfset variables.getAllSubCategories = application.shoppingCart.fetchSubCategories(variables.categoryId)>
        <cfloop array="#variables.getAllSubCategories#" item="local.item">
            <cfset variables.encryptedSubCategoryId = encrypt("#local.item.subCategoryId#",application.key,"AES","Base64")>
            <cfset variables.encodedSubCategoryId = encodeForURL(variables.encryptedSubCategoryId)>
            <a class="h4 text-decoration-none" href = "userSubCategory.cfm?subCategoryId=#variables.encodedSubCategoryId#" >
                <h4> #local.item.subCategoryName#</h4>
            </a>
            <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(subCategoryId = #local.item.subCategoryId#)>
            <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
                <cfloop query="variables.getAllProducts">
                    <cfset variables.encryptedProductId = encrypt("#getAllProducts.fldProduct_Id#",application.key,"AES","Base64")>
                    <cfset variables.encodedProductId = encodeForURL(variables.encryptedProductId)>
                    <a class ="card m-2 p-2 productCard text-decoration-none" 
                        href = "userProduct.cfm?productId=#variables.encodedProductId#">
                        <div>
                            <img src="./assets/images/productImages/#variables.getAllProducts.fldImageFilename#" 
                                class="w-100 productImg"
                                alt="" 
                                height ="150">
                            <div class="card-body">
                                <h6 class="card-title" id = "#variables.getAllProducts.fldProduct_Id#">
                                    #variables.getAllProducts.fldProductName#
                                </h6>
                                <div class="card-text text-muted">  
                                    #variables.getAllProducts.fldBrandName#
                                </div>
                                <div class="card-text text-dark fw-semibold">
                                    <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                    #variables.getAllProducts.fldPrice#
                                </div>
                                <div class="card-text productDescription">
                                    #variables.getAllProducts.fldDescription#
                                </div>
                            </div>
                        </div>
                    </a>
                </cfloop> 
            </div>
        </cfloop>  
    </div>
</main>

</cfoutput>

<cfinclude  template="footer.cfm">

