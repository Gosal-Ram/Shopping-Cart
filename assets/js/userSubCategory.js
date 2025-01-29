let offset = 0;
function toggleView(subCategoryId){
    console.log(subCategoryId);
    offset += 4;
    // let offset =  document.getElementById("viewEditBtn").value;    
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{
            subCategoryId: subCategoryId,
            offset : offset,
            method : "fetchProducts"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);
            console.log(responseParsed);
            const columns = responseParsed.COLUMNS;
            const data = responseParsed.DATA;    
            let productListingContainer = document.getElementById("productListingContainer");

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



   /*  let offset = 0;

    function toggleView(subCategoryId) {
        console.log(subCategoryId);
        offset += 4;
    
        $.ajax({
            type: "POST",
            url: "component/shoppingcart.cfc",
            data: {
                subCategoryId: subCategoryId,
                offset: offset,
                method: "fetchProducts"
            },
            success: function (response) {
                let responseParsed = JSON.parse(response);
                console.log(responseParsed);
    
                // Extract COLUMNS and DATA arrays
                const columns = responseParsed.COLUMNS;
                const data = responseParsed.DATA;
    
                // Locate the product listing container
                let productListingContainer = document.getElementById("productListingContainer");
    
                // Ensure container exists
                if (!productListingContainer) {
                    console.error("Product listing container not found!");
                    return;
                }
    
                // Generate HTML for each product and append it to the container
                data.forEach(product => {
                    let productHTML = `
                        <a class="card m-2 p-2 productCard text-decoration-none" href="userProduct.cfm?productId=${encodeURIComponent(product[columns.indexOf('FLDPRODUCT_ID')])}">
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
    
                    // Append product HTML to the container
                    productListingContainer.insertAdjacentHTML("beforeend", productHTML);
                });
            },
            error: function (error) {
                console.error("Error fetching products:", error);
            }
        });
    }
     */
















