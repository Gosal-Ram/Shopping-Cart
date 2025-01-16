<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Products</title>
        <link rel="stylesheet" href="assets/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link href="assets/images/shopping-cart.png" rel="icon">
        <script src="assets/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery-3.7.1.min.js"></script>
    </head>
    <body>
      <cfset subCategoryId = url.subCategoryId>
      <cfset subCategoryName = url.subCategoryName>
      <cfset categoryId = url.categoryId>

      <cfoutput>
        <cfinclude  template="header.cfm">
        <main>
          <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow-lg" id ="mainDiv">
            <div class = "d-flex justify-content-between align-items-center mb-3" >
              <h3>#subCategoryName#</h3>
              <button type="button"
                onclick = "openAddProductModal()"
                class = "btn btn-secondary rounded" 
                data-bs-toggle="modal" 
                data-bs-target="##staticBackdrop">
                New
              </button>
            </div>
            <cfset productResult = application.shoppingCart.fetchProducts(subCategoryId)>
            <span class="text-success" id ="productFunctionResult"></span>
            <cfloop query="productResult">
              <div class = "d-flex justify-content-between align-items-center w-100 col-6" id = "#fldProduct_Id#">
                <div class="col-6">
                  <div id = "productname-#fldProduct_Id#" class="h5 text-bold">#fldProductName#</div>
                  <div class = "d-flex justify-content-between align-items-center">
                    <div class="text-secondary">
                      <div class="h6 text-muted">#fldBrandName#</div>
                      <div class="h6 text-bold"> #fldPrice#</div>
                    </div>
                    <button type="button" 
                      onclick = "openImgCarousal(#fldProduct_Id#)"
                      class="border-0" 
                      data-bs-toggle="modal" 
                      data-bs-target="##imgModal"
                    >
                      <img src="./assets/images/productImages/#fldImageFileName#" alt="" width="85" height="" class="">
                    </button>
                  </div>
                </div>
                <div class="">
                  <button type="button" 
                    onclick = "editProductOpenModal(#fldProduct_Id#)" 
                    class = "btn btn-outline-info  px-3 my-2" 
                    data-bs-toggle="modal" 
                    data-bs-target="##staticBackdrop">
                    <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
                  </button>
                  <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteProduct(#fldProduct_Id#)">
                    <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
                  </button>
                </div>
              </div>
            </cfloop>
          </div>
        </main>
        <footer></footer>


        <!-- Save product Modal -->
        <form method="POST" id="productAddForm" enctype="multipart/form-data" onsubmit="modalValidate()">
          <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5" id="staticBackdropLabel">Add Product</h1>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <label class="modalLabel mb-2">Category Name</label>
                    <select class="form-select mb-2" id = "categorySelect" name = "selectedCategoryId">
                      <cfset getOptions = application.shoppingCart.fetchCategories()>
                      <cfloop query="getOptions">
                        <option 
                          <cfif categoryId EQ #getOptions.fldCategory_Id#>
                            selected
                          </cfif>
                          value="#getOptions.fldCategory_Id#">
                          #getOptions.fldCategoryName#
                        </option>
                      </cfloop>
                    </select>
                    <label class="modalLabel mb-2">Sub Category Name</label>
                    <select class="form-select mb-2" id = "selectedSubCategoryId" name = "selectedSubCategoryId"> 
                      <cfset getSubCategoryOptions = application.shoppingCart.fetchSubCategories(categoryId)>
                      <cfloop query="getSubCategoryOptions">
                        <option 
                          <cfif subCategoryId EQ #getSubCategoryOptions.fldSubCategory_Id#>
                            selected
                          </cfif>
                          value="#getSubCategoryOptions.fldSubCategory_Id#">
                          #getSubCategoryOptions.fldSubCategoryName#
                        </option>
                      </cfloop>
                    </select>
                    <label class="modalLabel mb-2">Product Name</label>
                    <input type="text" name="productName" id="productName" value="" placeholder="Product Name" class="form-control">
                    <div id="productNameError" class="text-danger"></div>
                    <label class="modalLabel mb-2">Product Brand</label>
                    <select class="form-select mb-2" id = "brandSelect"  name= "selectedBrandId">
                      <option selected value> - Select a Brand - </option>
                      <cfset getBrandOptions = application.shoppingCart.fetchBrands()>
                      <cfloop query="getBrandOptions">
                        <option 
                          value="#getBrandOptions.fldBrand_Id#">
                          #getBrandOptions.fldBrandName#
                        </option>
                      </cfloop>
                    </select>
                    <label class="modalLabel mb-2">Product Description</label>
                    <input type="text" name="productDescription" id="productDescription" value="" placeholder="Product Description" class="form-control">
                    <div id="productDescriptionError" class="text-danger"></div>
                    <label class="modalLabel mb-2">Product Price</label>
                    <input type="number" name="productPrice" id="productPrice" value="" placeholder="Product Price" class="form-control">
                    <div id="productPriceError" class="text-danger"></div>
                    <label class="modalLabel mb-2">Product Tax</label>
                    <input type="number" name="productTax" id="productTax" value="" placeholder="Product Tax" class="form-control">
                    <div id="productTaxError" class="text-danger"></div>
                    <label for="imgFiles" class="modalLabel mb-2">Product Images</label>
                    <input type="file" name="productImages" id="imgFiles" class="form-control" multiple>
                    <div id="productImagesError" class="text-danger"></div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button onClick = "saveProduct()" 
                          type="button" 
                          name = "modalSubmitBtn" 
                          class="btn btn-primary" 
                          id = "modalSubmitBtn" 
                          value = "">
                          Add
                  </button>
                </div>
              </div>
            </div>
          </div>
        </form>
        <!-- Carousal modal -->
        <div class="modal fade" id="imgModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <div id="carouselExampleIndicators" class="carousel slide">
                  <div class="carousel-inner" id = "carousalDiv">
                    <!--- <div class="carousel-item active">                      
                      <img src="./assets/images/productImages/samsung tv.jpg" alt="" width="85" class="d-block w-100" alt="...">
                    </div>
                    <div class="carousel-item">
                      <img src="./assets/images/productImages/sonybravia.jpg" alt="" width="85" class="d-block w-100" alt="...">
                    </div>
                    <div class="carousel-item">
                      <img src="./assets/images/productImages/Apple-TV.jpg" alt="" width="85" class="d-block w-100" alt="...">
                    </div> --->
                  </div>
                  <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleIndicators" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                  </button>
                  <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleIndicators" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                  </button>
                </div>
              </div>
              <!--- <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Understood</button>
              </div> --->
            </div>
          </div>
        </div>

      </cfoutput>
      <script src="assets/js/product.js"></script>
    </body>
</html>
