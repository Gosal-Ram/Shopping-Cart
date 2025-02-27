let offset = 0;
let limit = 4;
function toggleView(subCategoryId, sortFlag, filterMin, filterMax){
    offset += 4;
    $.ajax({
        type:"POST",
        url: "/component/shoppingcart.cfc",
        data:{
            subCategoryId: subCategoryId,
            offset : offset,
            limit : limit, 
            sortFlag : sortFlag,
            filterMin : filterMin,
            filterMax : filterMax,
            method : "fetchProducts"
        },
        success:function(response){
            let data = JSON.parse(response);
            console.log(data);
            if(data.length < 4 ){
                $("#viewEditBtn").hide();
            }
            data.forEach(product => {
                console.log(product);
                let productId = encodeURIComponent(product.productId)
               $(`<a class="card m-2 p-2 productCard text-decoration-none" href="/userProduct.cfm?productId=${productId}">
                      <div>
                          <img src="./productImages/${product.imageFilenames[0]}" 
                               class="w-100"  
                               alt="${product.productName}" 
                               style="height: 150px; object-fit: contain;">
                          <div class="card-body">
                              <h6 class="card-title" id="${product.productId}">
                                  ${product.productName}
                              </h6>
                              <div class="card-text text-muted">
                                  ${product.brandName}
                              </div>
                              <div class="card-text text-dark fw-semibold">
                                  <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                  ${product.price}
                              </div>
                              <div class="card-text productDescription">
                                  ${product.description}
                              </div>
                          </div>
                      </div>
                  </a>`).hide().appendTo("#productListingContainer").fadeToggle();
                 // Append each product card to the container
            //   $("#productListingContainer").append(productHTML);

          }); 
        }
    });
}
