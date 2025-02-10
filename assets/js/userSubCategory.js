let offset = 0;
let limit = 4;
function toggleView(subCategoryId){
    // console.log(subCategoryId);
    offset += 4;
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{
            subCategoryId: subCategoryId,
            offset : offset,
            limit : limit,
            method : "fetchProducts"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);
            // console.log(responseParsed);
            const columns = responseParsed.COLUMNS; //arr
            const data = responseParsed.DATA;    //arr

            data.forEach(product => {
              let productHTML = `
                  <a class="card m-2 p-2 productCard text-decoration-none" href="userProduct.cfm?productId=${product[columns.indexOf('FLDPRODUCT_ID')]}">
                      <div>
                          <img src="./assets/images/productImages/${product[columns.indexOf('FLDIMAGEFILENAME')]}" 
                               class="w-100"  
                               alt="${product[columns.indexOf('FLDPRODUCTNAME')]}" 
                               style="height: 150px; object-fit: contain;">
                          <div class="card-body">
                              <h6 class="card-title" id="${product[columns.indexOf('FLDPRODUCT_ID')]}">
                                  ${product[columns.indexOf('FLDPRODUCTNAME')]}
                              </h6>
                              <div class="card-text text-muted">
                                  ${product[columns.indexOf('FLDBRANDNAME')]}
                              </div>
                              <div class="card-text text-dark fw-semibold">
                                  <i class="fa-solid fa-indian-rupee-sign me-1"></i>
                                  ${product[columns.indexOf('FLDPRICE')]}
                              </div>
                              <div class="card-text productDescription">
                                  ${product[columns.indexOf('FLDDESCRIPTION')]}
                              </div>
                          </div>
                      </div>
                  </a>
              `;
         // Append each product card to the container
              $("#productListingContainer").append(productHTML);
          });  
        }
    });
}


















