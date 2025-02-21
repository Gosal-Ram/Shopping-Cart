<cfset variables.categoryId = decrypt(url.categoryId, application.key,"AES","Base64")>
<cfset variables.getAllProducts = application.shoppingCart.fetchProducts(categoryId = variables.categoryId)>

<!--- <cfdump  var="#variables.getAllProducts#"> --->
<cfset variables.productStruct = structNew()>
<cfloop array="#variables.getAllProducts#" item="local.product">
    <cfset variables.subCategoryId = local.product.subCategoryId>

    <cfif NOT structKeyExists(variables.productStruct, variables.subCategoryId)>
        <cfset variables.productStruct[variables.subCategoryId] = {
            subCategoryName = local.product.subCategoryName,
            encryptedSubCategoryId = encodeForURL(encrypt(local.product.subCategoryId, application.key, "AES", "Base64")),
            products = []
        }>
    </cfif>

    <cfset arrayAppend(variables.productStruct[variables.subCategoryId].products, {
        productId = local.product.productId,
        productName = local.product.productName,
        brandName = local.product.brandName,
        price = local.product.price,
        description = local.product.description,
        imageFilename = local.product.imageFilenames[1]
    })>
</cfloop>

<cfoutput>
<main>
    <div class="container-fluid my-3 ms-3">
        <h2>#variables.getAllProducts[1].categoryName#</h2> 
        <cfloop collection="#variables.productStruct#" item="subCategoryId">
            <cfset local.subCategory = variables.productStruct[subCategoryId]>

            <a class="h4 text-decoration-none" href="/userSubCategory.cfm?subCategoryId=#local.subCategory.encryptedSubCategoryId#">
                <h4> #local.subCategory.subCategoryName#</h4>
            </a>

            <div class="productListingContainer d-flex flex-sm-wrap ms-5 mb-3">
                <cfloop array="#local.subCategory.products#" item="local.productItem">
                    <!--- Looping the struct's products Array under each subcategory --->
                    <cfset variables.encryptedProductId = encodeForURL(local.productItem.productId)>

                    <a class="card m-2 p-2 productCard text-decoration-none" href="/userProduct.cfm?productId=#variables.encryptedProductId#">
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
            </div>
        </cfloop> 
    </div>
</main>
</cfoutput>
