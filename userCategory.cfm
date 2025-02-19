<cfset variables.categoryId = decrypt(url.categoryId, application.key,"AES","Base64")>
<cfset variables.getCategoryNames = application.shoppingCart.fetchCategories(variables.categoryId)>

<cfset variables.getAllSubCategories = application.shoppingCart.fetchSubCategories(variables.categoryId)>
<cfset variables.getAllProducts = application.shoppingCart.fetchProducts()>

<cfset variables.productStruct = structNew()>
<!---storing all products in a struct to skip database call inside loop --->
<cfloop array="#variables.getAllProducts#" item= "local.product">
    <cfset variables.subCategoryId = local.product.subCategoryId>
    <cfif NOT structKeyExists(variables.productStruct, variables.subCategoryId)>
        <cfset variables.productStruct[variables.subCategoryId] = []>
    </cfif>
    <cfset arrayAppend(variables.productStruct[variables.subCategoryId], {
        productId = local.product.productId,
        productName = local.product.productName,
        brandName = local.product.brandName,
        price = local.product.price,
        description = local.product.description,
        imageFilename = local.product.imageFilename
    })>
</cfloop>
<cfoutput>
<main>
    <div class="container-fluid my-3 ms-3">
        <h2>#variables.getCategoryNames[1].categoryName#</h2> 

        <cfloop array="#variables.getAllSubCategories#" item="local.subItem">
            <cfset variables.encryptedSubCategoryId = encrypt("#local.subItem.subCategoryId#",application.key,"AES","Base64")>
            <cfset variables.encodedSubCategoryId = encodeForURL(variables.encryptedSubCategoryId)>
            <a class="h4 text-decoration-none" href = "userSubCategory.cfm?subCategoryId=#variables.encodedSubCategoryId#" >
                <h4> #local.subItem.subCategoryName#</h4>
            </a>
            <div class="productListingContainer d-flex flex-sm-wrap ms-5 mb-3">
                <cfif structKeyExists(variables.productStruct, local.subItem.subCategoryId)>
                    <cfloop array="#variables.productStruct[local.subItem.subCategoryId]#" item="local.productItem">
                        <cfset variables.encryptedProductId = local.productItem.productId>
                        <cfset variables.encodedProductId = encodeForURL(variables.encryptedProductId)>
                        <a class="card m-2 p-2 productCard text-decoration-none" href="userProduct.cfm?productId=#variables.encodedProductId#">
                            <div>
                                <img src="./assets/images/productImages/#local.productItem.imageFilename#"
                                    class="w-100 productImg"
                                    alt=""
                                    height="150">
                                <div class="card-body">
                                    <h6 class="card-title" id="#local.productItem.productId#">#local.productItem.productName#</h6>
                                    <div class="card-text text-muted">#local.productItem.brandName#</div>
                                    <div class="card-text text-dark fw-semibold">
                                        <i class="fa-solid fa-indian-rupee-sign me-1"></i> #local.productItem.price#
                                    </div>
                                    <div class="card-text productDescription">#local.productItem.description#</div>
                                </div>
                            </div>
                        </a>
                    </cfloop>
                </cfif>
            </div>
        </cfloop>  
    </div>
</main>
</cfoutput>


