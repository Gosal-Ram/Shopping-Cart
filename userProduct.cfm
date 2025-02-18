<cfset variables.productId = decrypt(url.productId,application.key,"AES","Base64")>

<cfset variables.getAllProducts = application.shoppingCart.fetchProducts(productId = variables.productId)>
<cfset variables.subCategoryId = variables.getAllProducts[1].subCategoryId>
<cfset variables.getAllProductImages = application.shoppingCart.fetchProductImages(productId = variables.productId)>
<!--- getting products's category, subcategory information for PRODUCT PATH UI and NAVIGATION --->
<cfset variables.getCategoryId = application.shoppingCart.fetchSubCategories(subCategoryId = variables.subCategoryId)>
<cfset variables.categoryId = #variables.getCategoryId[1].categoryId#>
<cfset variables.subCategoryName = #variables.getCategoryId[1].subCategoryName#>
<cfset variables.getCategoryName = application.shoppingCart.fetchCategories(variables.categoryId)>
<cfset variables.categoryName = #variables.getCategoryName[1].categoryName#>

<cfset variables.encryptedCategoryId = encrypt("#variables.categoryId#",application.key,"AES","Base64")>
<cfset variables.encodedCategoryId = encodeForURL(variables.encryptedCategoryId)>

<cfset variables.encryptedSubCategoryId = encrypt("#variables.subCategoryId#",application.key,"AES","Base64")>
<cfset variables.encodedSubCategoryId = encodeForURL(variables.encryptedSubCategoryId)>

<cfset variables.encryptedProductId = url.productId >
<cfset variables.encodedProductId = encodeForURL(variables.encryptedProductId)>

<cfset variables.logInFlag = 0>

<cfoutput>
<main>
    <cfloop array="#variables.getAllProducts#" item = "local.product">
        <div class="container my-5">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="home.cfm">Home</a></li>
                    <li class="breadcrumb-item">
                        <a href="userCategory.cfm?categoryId=#variables.encodedCategoryId#"> #variables.categoryName#</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="userSubCategory.cfm?subCategoryId=#variables.encodedSubCategoryId#">#variables.subCategoryName#</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page"> 
                        #local.product.productName# 
                    </li>
                </ol>
            </nav>
            <div class="row">
                <div class="col-md-6">
                    <div class="d-flex">
                        <div class="me-3">
                            <div class="d-flex flex-column">
                                <cfloop query="variables.getAllProductImages">
                                    <img src="assets/images/productImages/#variables.getAllProductImages.fldImageFilename#" 
                                    class="img-thumbnail mb-2" 
                                    alt = "" 
                                    height ="65"
                                    width = "90"
                                    id = "productThumbnailImg"
                                    onmouseover="changeMainImage(this.src)">
                                </cfloop>
                            </div>
                        </div>
                        <div id="productCarousel" class="carousel slide w-100" data-bs-ride="carousel">
                            <div class="carousel-inner">
                                <div class="carousel-item active">
                                    <img src="assets/images/productImages/#local.product.imageFilename#" 
                                    id = "mainProductImage"
                                    class="d-block w-100 productImg" 
                                    alt="" 
                                    height="350">
                                </div>
                                <cfloop query="variables.getAllProductImages">
                                    <div class="carousel-item">
                                        <img src="assets/images/productImages/#variables.getAllProductImages.fldImageFilename#" 
                                        class="d-block w-100 productImg" 
                                        alt="Product Image"
                                        height="350">
                                    </div>
                                </cfloop>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="##productCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="##productCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <h2 class="product-title">#local.product.productName#</h2>
                    <p class="text-muted">Brand: #local.product.brandName#</p>
                    <h3 class="text-dark">
                        <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                        #local.product.price#
                    </h3>
                    <p class="text-success">
                        Tax : 
                        <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                        #local.product.tax#
                    </p>
                    <p class="product-description mt-4">
                        #local.product.description#   
                    </p>

                    <div class="mt-4">
                    <cfif structKeyExists(session,"isLoggedIn") AND session.isloggedIn EQ true>
                        <cfset variables.logInFlag = 1>
                    </cfif>
                    <form method = "POST">
                        <button type = "button" 
                        onclick ="addToCartAndBuy(#variables.logInFlag#,#variables.productId#,0,'#variables.encodedProductId#')" 
                        name = "addToCartBtn" 
                        class="btn addToCartBtn me-2">
                            Add to Cart
                        </button>
                        <button class="btn buyNowtBtn"
                                type = "button" 
                                onClick = "addToCartAndBuy(#variables.logInFlag#,#variables.productId#,1,'#variables.encodedProductId#')">
                            Buy Now
                        </button>
                    </form>
                    </div>
                </div>
            </div>
        </div>
    </cfloop>
</main>
</cfoutput>


