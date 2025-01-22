<cfinclude  template="header.cfm">
<main class="d-flex flex-column">
<cfoutput>
  <div class="homeImgContainer mx-auto">
     <img src="./assets/images/Photo Modern New Collection Banner.png" alt="" 
          class= "w-100"
          style="height: 550px; object-fit: contain;">
  </div>
  <cfset variables.getAllProducts = application.shoppingCart.fetchProductsRandom()>
  <h3 class = "m-2 p-1">Random Products</h3>
  <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
    <!---  <cfdump  var="#variables.getAllProducts#">  --->
    <cfloop array="#variables.getAllProducts#" item="item">
      <a class = "card m-2 p-2 productCard overflow-hidden text-decoration-none bg-image hover-zoom" 
      data-mdb-ripple-color="light"
      href = "userProduct.cfm?productId=#item.productId#">
      <div>
        <img src="./assets/images/productImages/#item.imgName#" 
            class="w-100"  
            alt=""  
            class=""
            style="height: 150px; object-fit: contain;">
        <div class="card-body">
          <h5 class="card-title" id = "#item.productId#">#item.productName#</h5>
          <div class="card-text text-muted">  #item.brandName#</div>
          <div class="card-text text-dark fw-semibold"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#item.price#</div>
          <div class="card-text productDescription">#item.description#</div>
        </div>
      </div>
      </a>
    </cfloop>
  </div>
</cfoutput>
</main>
<cfinclude  template="footer.cfm">


