<main class="d-flex flex-column">
<cfoutput>
  <div class="homeImgContainer mx-auto">
     <img src="./assets/images/Photo Modern New Collection Banner.png" alt="" 
        class= "w-100 homeCartImg"
        height = "550">
  </div>
  <cfset variables.random = 1 >
  <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(random = variables.random)>
  <h3 class = "m-2 p-1">Random Products</h3>
  <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
    <cfloop array="#variables.getAllProducts#" item="local.item">
      <cfset variables.encryptedProductId = local.item.productId>
      <cfset variables.encodedProductId = encodeForURL(variables.encryptedProductId)>
      <a class = "card m-2 p-2 productCard overflow-hidden text-decoration-none"
        href = "userProduct.cfm?productId=#variables.encodedProductId#">
        <div>
          <img src="./assets/images/productImages/#local.item.imageFilename#" 
            class="w-100 productImg"  
            alt=""  
            height = "150">
          <div class="card-body">
            <h5 class="card-title" id = "#local.item.productId#">
              #local.item.productName#
            </h5>
            <p class="card-text text-muted mb-0">
              #local.item.brandName#
            </p>
            <p class="card-text text-dark fw-semibold mb-0">
              <i class="fa-solid fa-indian-rupee-sign me-1"></i>
              #local.item.price#
            </p>
            <p class="card-text productDescription mb-0">
              #local.item.description#
            </p>
          </div>
        </div>
      </a>
    </cfloop>
  </div>
</cfoutput>
</main>


