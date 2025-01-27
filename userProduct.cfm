<cfinclude template="header.cfm">
<cfset variables.productId = decrypt(url.productId,application.key,"AES","Base64")>
<cfset variables.getAllProducts = application.shoppingCart.fetchProducts(productId = variables.productId)>
<cfset variables.subCategoryId = variables.getAllProducts.fldSubCategoryId>
<cfset variables.getAllProductImages = application.shoppingCart.fetchProductImages(productId = variables.productId)>

<cfset variables.getCategoryId = application.shoppingCart.fetchSubCategories(subCategoryId = variables.subCategoryId)>
<cfset variables.categoryId = #variables.getCategoryId[1].categoryId#>
<cfset variables.subCategoryName = #variables.getCategoryId[1].subCategoryName#>
<cfset variables.getCategoryName = application.shoppingCart.fetchCategories(variables.categoryId)>
<cfset variables.categoryName = #variables.getCategoryName[1].categoryName#>

<cfset variables.encryptedCategoryId = encrypt("#variables.categoryId#",application.key,"AES","Base64")>
<cfset variables.encodedCategoryId = encodeForURL(variables.encryptedCategoryId)>

<cfset variables.encryptedSubCategoryId = encrypt("#variables.subCategoryId#",application.key,"AES","Base64")>
<cfset variables.encodedSubCategoryId = encodeForURL(variables.encryptedSubCategoryId)>

<cfoutput>
    <main>
        <cfloop query="variables.getAllProducts">
            <div class="container my-5">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="home.cfm">Home</a></li>
                        <li class="breadcrumb-item"><a  href="userCategory.cfm?categoryId=#variables.encodedCategoryId#"> #variables.categoryName# </a></li>
                        <li class="breadcrumb-item"><a  href="userSubCategory.cfm?subCategoryId=#variables.encodedSubCategoryId#"> #variables.subCategoryName# </a></li>
                        <li class="breadcrumb-item active" aria-current="page"> #variables.getAllProducts.fldProductName# </li>
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
                                        alt="" 
                                        style="height: 65px; width: 90px;"
                                        onmouseover="changeMainImage(this.src)">
                                    </cfloop>
                                </div>
                            </div>
                            <div id="productCarousel" class="carousel slide" data-bs-ride="carousel" style="width: 100%;">
                                <div class="carousel-inner">
                                    <div class="carousel-item active">
                                        <img src="assets/images/productImages/#variables.getAllProducts.fldImageFilename#" 
                                        id = "mainProductImage"
                                        class="d-block w-100 mainImg" 
                                        alt="" 
                                        style="height: 400px; object-fit: contain;">
                                    </div>
                                    <cfloop query="variables.getAllProductImages">
                                    <div class="carousel-item">
                                        <img src="assets/images/productImages/#variables.getAllProductImages.fldImageFilename#" 
                                        class="d-block w-100" 
                                        alt="Product Image" 
                                        style="height: 400px; object-fit: contain;">
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
                        <h2 class="product-title">#variables.getAllProducts.fldProductName#</h2>
                        <p class="text-muted">Brand: #variables.getAllProducts.fldBrandName#</p>
                        <h3 class="text-dark"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#variables.getAllProducts.fldPrice#</h3>
                        <p class="text-success">Tax : <i class="fa-solid fa-indian-rupee-sign me-1"></i>#variables.getAllProducts.fldTax#</p>
                        <p class="product-description mt-4">#variables.getAllProducts.fldDescription#</p>

                        <div class="mt-4">
                        <form method = "POST">
                            <button type = "submit" name = "addToCartBtn" class="btn addToCartBtn me-2">Add to Cart</button>
                            <button class="btn buyNowtBtn ">Buy Now</button>
                        </form>
                        </div>
                    </div>
                </div>
            </div>
        </cfloop>
    
        <cfif structKeyExists(form, "addToCartBtn")>
            <cfif NOT structKeyExists(session, "isLoggedIn") OR session.isloggedIn EQ false>
                <cflocation  url="login.cfm">
            </cfif>
            <cfset variables.userProductCartResult = application.shoppingCart.addToCart( productId = variables.productId)>
            <span>
                #variables.userProductCartResult.resultMsg#
            </span>
        </cfif> 
    </main>
</cfoutput>

<cfinclude template="footer.cfm">

