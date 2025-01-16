<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Categories</title>
        <link rel="stylesheet" href="assets/bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link href="assets/images/shopping-cart.png" rel="icon">
        <script src="assets/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery-3.7.1.min.js"></script>
    </head>
    <body>
      <cfinclude  template="header.cfm">
      <main>
        <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow-lg" id ="mainDiv">
          <div class = "d-flex justify-content-between align-items-center mb-3">
            <h3>Categories</h3>
            <button type="button"
                    onclick = "openAddCategoryModal()"
                    class = "btn btn-secondary rounded" 
                    data-bs-toggle="modal" 
                    data-bs-target="#staticBackdrop">
                    New
            </button>
          </div>
          <cfset categoryResult = application.shoppingCart.fetchCategories()>
          <cfoutput>
            <span class="text-success" id ="categoryFunctionResult"></span>        
            <cfloop query="categoryResult">
            <div class = "d-flex justify-content-between align-items-center" id = "#fldCategory_Id#">
              <div id = "categoryname-#fldCategory_Id#">#fldCategoryName#</div>
              <div>
                <button type="button" 
                        onclick = "editCategory(#fldCategory_Id#)" 
                        class = "btn btn-outline-info  px-3 my-2" 
                        data-bs-toggle="modal" 
                        data-bs-target="##staticBackdrop">
                  <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
                </button>
                <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteCategory(#fldCategory_Id#)">
                  <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
                </button>
                <a class = "btn btn-outline-info  px-3 my-2" href ="subCategory.cfm?categoryId=#fldCategory_Id#&categoryName=#fldCategoryName#">
                  <img src="./assets/images/right-arrow.png" alt="" width="18" height="18" class="">
                </a>
              </div>
            </div>
            </cfloop>
          </cfoutput>
        </div>
      </main>
      <footer></footer>
      <script src="assets/js/category.js"></script>


      <!-- Modal -->
      <form method="POST" id="categoryAddForm" onsubmit="return modalValidate()">
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h1 class="modal-title fs-5" id="staticBackdropLabel">Add Category</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                  <label class="modalLabel mb-2">Category Name</label>
                  <input type="text" name="categoryName" id="categoryName" value="" placeholder="Category Name" class="form-control">
                  <div id="categoryNameError" class="text-danger"></div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button onClick = saveCategory() 
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
    </body>
</html>
