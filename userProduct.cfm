<cfinclude template="header.cfm">

<cfset variables.productId = url.productId>
<cfset variables.getAllProducts = application.shoppingCart.fetchProducts(productId = variables.productId)>
<cfset variables.getAllProductImages = application.shoppingCart.fetchProductImages(productId = variables.productId)>

<cfoutput>
<main>
    <div class="container my-5">
        <div class="row">
            <div class="col-md-6">
                <div class="d-flex">
                    <div class="me-3">
                        <div class="d-flex flex-column">
                            <cfloop query="variables.getAllProductImages">
                                <img src="assets/images/productImages/#variables.getAllProductImages.fldImageFilename#" 
                                class="img-thumbnail mb-2" 
                                alt="Product Thumbnail" 
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
                                alt="Product Image" 
                                style="height: 400px; object-fit: contain;">
                            </div>
                            <cfloop query="variables.getAllProductImages">
                            <div class="carousel-item">
                                <img src="assets/images/productImages/#variables.getAllProductImages.fldImageFilename#" class="d-block w-100" alt="Product Image" style="height: 400px; object-fit: contain;">
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
                <cfloop query="variables.getAllProducts">
                <h2 class="product-title">#variables.getAllProducts.fldProductName#</h2>
                <p class="text-muted">Brand: #variables.getAllProducts.fldBrandName#</p>
                <h3 class="text-dark"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#variables.getAllProducts.fldPrice#</h3>
                <p class="text-success">Tax : <i class="fa-solid fa-indian-rupee-sign me-1"></i>#variables.getAllProducts.fldTax#</p>
                <p class="product-description mt-4">#variables.getAllProducts.fldDescription#</p>

                <div class="mt-4">
                    <button class="btn addToCartBtn me-2">Add to Cart</button>
                    <button class="btn buyNowtBtn ">Buy Now</button>
                </div>
                </cfloop>
            </div>
        </div>
    </div>
</main>
</cfoutput>

<cfinclude template="footer.cfm">

