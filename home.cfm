<cfinclude  template="header.cfm">
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
    <cfloop query="variables.getAllProducts">
      <cfset variables.encryptedProductId = encrypt("#variables.getAllProducts.fldProduct_Id#",application.key,"AES","Base64")>
      <cfset variables.encodedProductId = encodeForURL(variables.encryptedProductId)>
      <a class = "card m-2 p-2 productCard overflow-hidden text-decoration-none"
        href = "userProduct.cfm?productId=#variables.encodedProductId#">
        <div>
          <img src="./assets/images/productImages/#variables.getAllProducts.fldImageFilename#" 
            class="w-100 productImg"  
            alt=""  
            height = "150">
          <div class="card-body">
            <h5 class="card-title" id = "#variables.getAllProducts.fldProduct_Id#">
              #variables.getAllProducts.fldProductName#
            </h5>
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
</cfoutput>
</main>
<cfinclude  template="footer.cfm">


