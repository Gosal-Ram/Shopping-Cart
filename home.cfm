<cfinclude  template="header.cfm">
<main class="d-flex flex-column">
<cfoutput>
  <div class="homeImgContainer mx-auto">
     <img src="./assets/images/Photo Modern New Collection Banner.png" alt="" 
        class= "w-100"
        style="height: 550px; object-fit: contain;">
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
            class="w-100"  
            alt=""  
            class=""
            style="height: 150px; object-fit: contain;">
          <div class="card-body">
            <h5 class="card-title" id = "#variables.getAllProducts.fldProduct_Id#">#variables.getAllProducts.fldProductName#</h5>
            <div class="card-text text-muted">#variables.getAllProducts.fldBrandName#</div>
            <div class="card-text text-dark fw-semibold"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#variables.getAllProducts.fldPrice#</div>
            <div class="card-text productDescription">#variables.getAllProducts.fldDescription#</div>
          </div>
        </div>
      </a>
    </cfloop>
  </div>
</cfoutput>
</main>
<cfinclude  template="footer.cfm">


