<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sub Categories</title>
        <link rel="stylesheet" href="assets/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link href="assets/images/shopping-cart.png" rel="icon">
        <script src="assets/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery-3.7.1.min.js"></script>
    </head>
    <body>
      <cfset categoryId = url.categoryId>
      <cfset categoryName = url.categoryName>
      <cfoutput>
        <cfinclude  template="header.cfm">
        <main>
          <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow-lg" id ="mainDiv">
            <div class = "d-flex justify-content-between align-items-center mb-3" >
              <h3>#categoryName#</h3>
              <button type="button"
                      onclick = "openAddSubCategoryModal()"
                      class = "btn btn-secondary rounded" 
                      data-bs-toggle="modal" 
                      data-bs-target="##staticBackdrop">
                      New
              </button>
            </div>
            <cfset subCategoryResult = application.obj.fetchSubCategories(categoryId)>
            <span class="text-success" id ="subCategoryFunctionResult"></span>
            <cfloop query="subCategoryResult">
              <div class = "d-flex justify-content-between align-items-center" id = "#fldSubCategory_Id#">
                <div id = "subcategoryname-#fldSubCategory_Id#">#fldSubCategoryName#</div>
                <div>
                  <button type="button" 
                          onclick = "editSubCategory(#fldSubCategory_Id#)" 
                          class = "btn btn-outline-info  px-3 my-2" 
                          data-bs-toggle="modal" 
                          data-bs-target="##staticBackdrop">
                    <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
                  </button>
                  <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteSubCategory(#fldSubCategory_Id#)">
                    <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
                  </button>
                  <a class = "btn btn-outline-info  px-3 my-2" 
                  id="subcategory-link-#fldSubCategory_Id#"
                  href ="product.cfm?subCategoryId=#fldSubCategory_Id#&subCategoryName=#fldSubCategoryName#&categoryId=#categoryId#">
                    <img src="./assets/images/right-arrow.png" alt="" width="18" height="18" class="">
                  </a>
                </div>
              </div>
            </cfloop>
          </div>
        </main>
        <footer></footer>


      <!-- Modal -->
      <form method="POST" id="SubCategoryAddForm" onsubmit="return modalValidate()">
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h1 class="modal-title fs-5" id="staticBackdropLabel">Add Sub Category</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                  <label class="modalLabel mb-2">Category Name</label>
                  <select class="form-select mb-2" id = categorySelect>
                  <cfset getOptions = application.obj.fetchCategories()>
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
                  <input type="text" name="subCategoryName" id="subCategoryName" value="" placeholder="Sub Category Name" class="form-control">
                  <div id="subCategoryNameError" class="text-danger"></div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button onClick = saveSubCategory() 
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
      </cfoutput>
      <script src="assets/js/subCategory.js"></script>
    </body>
</html>
