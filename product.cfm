<cfset variables.subCategoryId = decrypt(url.subCategoryId,application.key,"AES","Base64")>
<!---fetching products's categoryId ,subcategoryname for dynamic switching the categories & subcategories while adding a new product--->
<cfset variables.getCategoryId = application.shoppingCart.fetchSubCategories(subCategoryId = variables.subCategoryId)>
<cfset variables.categoryId = variables.getCategoryId[1].categoryId>
<cfset variables.getSubCategoryName = application.shoppingCart.fetchSubCategories(categoryId = variables.categoryId,
                                                                                  subCategoryId = variables.subCategoryId)>
<cfset variables.subCategoryName = variables.getSubCategoryName[1].subCategoryName>
<cfoutput>
<cfinclude  template="header.cfm">
<main>
  <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow-lg" id ="mainDiv">
    <div class = "d-flex justify-content-between align-items-center mb-3" >
      <h3>#variables.subCategoryName#</h3>
      <button type="button" 
        onclick = "openAddProductModal()" 
        class = "btn btn-secondary rounded" 
        data-bs-toggle="modal" 
        data-bs-target="##staticBackdrop">
        New
      </button>
    </div>
    <cfset variables.queryGetAllProducts = application.shoppingCart.fetchProducts(variables.subCategoryId)>
    <span class="text-success" id ="productFunctionResult"></span>
    <cfloop query="variables.queryGetAllProducts">
      <div class = "d-flex justify-content-between align-items-center w-100 col-6" 
            id = "#variables.queryGetAllProducts.fldProduct_Id#">
        <div class="col-6">
          <div id = "productname-#variables.queryGetAllProducts.fldProduct_Id#" 
            class="h5 text-bold">#variables.queryGetAllProducts.fldProductName#
          </div>
          <div class = "d-flex justify-content-between align-items-center">
            <div class="text-secondary">
              <div class="h6 text-muted">#variables.queryGetAllProducts.fldBrandName#</div>
              <div class="h6 text-bold"> #variables.queryGetAllProducts.fldPrice#</div>
            </div>
            <button type="button" 
              onclick = "openImgCarousal(#variables.queryGetAllProducts.fldProduct_Id#)"
              class="border-0"  
              data-bs-toggle="modal" 
              data-bs-target="##imgModal">
              <img src="./assets/images/productImages/#variables.queryGetAllProducts.fldImageFileName#" 
                alt="" 
                width="85">
            </button>
          </div>
        </div>
        <div class="">
          <button type="button" 
            onclick = "editProductOpenModal(#variables.queryGetAllProducts.fldProduct_Id#)" 
            class = "btn btn-outline-info  px-3 my-2" 
            data-bs-toggle="modal" 
            data-bs-target="##staticBackdrop">
            <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
          </button>
          <button class = "btn btn-outline-info  px-3 my-2" 
            onClick = "deleteProduct(#variables.queryGetAllProducts.fldProduct_Id#)">
            <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
          </button>
        </div>
      </div>
    </cfloop>
  </div>
</main>

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
              <cfset variables.queryGetCategories = application.shoppingCart.fetchCategories()>
              <cfloop array="#variables.queryGetCategories#" item="local.item">
                <option 
                  <cfif variables.categoryId EQ #local.item.categoryId#>
                    selected
                  </cfif>
                  value="#local.item.categoryId#">
                  #local.item.categoryName#
                </option>
              </cfloop>
            </select>
            <label class="modalLabel mb-2">Sub Category Name</label>
            <select class="form-select mb-2" id = "selectedSubCategoryId" name = "selectedSubCategoryId"> 
              <cfset variables.queryGetSubCategories = application.shoppingCart.fetchSubCategories(variables.categoryId)>
              <cfloop array="#variables.queryGetSubCategories#" item="local.item">
                <option 
                  <cfif variables.subCategoryId EQ #local.item.subCategoryId#>
                    selected
                  </cfif>
                  value="#local.item.subCategoryId#">
                  #local.item.subCategoryName#
                </option>
              </cfloop>
            </select>
            <label class="modalLabel mb-2">Product Name</label>
            <input type="text" name="productName" id="productName" value="" placeholder="Product Name" class="form-control">
            <div id="productNameError" class="text-danger"></div>
            <label class="modalLabel mb-2">Product Brand</label>
            <select class="form-select mb-2" id = "brandSelect"  name= "selectedBrandId">
              <option selected value> - Select a Brand - </option>
              <cfset variables.queryGetAllBrands = application.shoppingCart.fetchBrands()>
              <cfloop query="variables.queryGetAllBrands">
                <option 
                  value="#variables.queryGetAllBrands.fldBrand_Id#">
                  #variables.queryGetAllBrands.fldBrandName#
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
            <input type="file" name="productImages" id="imgFiles" class="form-control" accept="image/*" multiple>
            <div id="productImagesError" class="text-danger"></div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          <button onClick = "saveProduct()" type="button" name = "modalSubmitBtn" class="btn btn-primary" id = "modalSubmitBtn">
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
        <h5 class="modal-title" id="staticBackdropLabel">Set Thumbnail</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div id="carouselExampleIndicators" class="carousel slide">
          <div class="carousel-inner" id = "carousalDiv"> <!--- dynamically populating images here--->
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
    </div>
  </div>
</div>
</cfoutput>

<cfinclude  template="footer.cfm">

