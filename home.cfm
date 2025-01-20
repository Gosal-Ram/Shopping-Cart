<cfinclude  template="header.cfm">
<main>
<cfoutput>
  <div class="imgContainer w-100">
    <!-- <img src="./assets/images/offer.png" alt="" width="%" height="%"> -->
  </div>
  <cfset local.getAllProducts = application.shoppingCart.fetchProductsRandom()>
  <h3 class = "m-2 p-1">Random Products</h3>
  <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
    <!---  <cfdump  var="#local.getAllProducts#">  --->
    <cfloop array="#local.getAllProducts#" item="item">
      <div class = "card m-2 productCard">
        <img src="./assets/images/productImages/#item.imgName#" class="w-100"  alt="" height="170" class="">
        <div class="card-body">
          <h5 class="card-title" id = "#item.productId#">#item.productName#</h5>
          <div class="card-text">  #item.brandName#</div>
          <div class="card-text">#item.price#</div>
          <div class="card-text">#item.description#</div>
        </div>
      </div>
    </cfloop>
  </div>
</cfoutput>
</main>
<cfinclude  template="footer.cfm">


