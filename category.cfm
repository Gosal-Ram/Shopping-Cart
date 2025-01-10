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
      <header class="d-flex p-1 justify-content-between align-items-center w-100 bg-primary sticky-top">
          <div>
              <a href = "" class = "text-light text-decoration-none">
                <img src="./assets/images/grocery-cart.png" class = "py-2" alt="" width="25">
                <span>SHOPPING CART</span>    
              </a>  
          </div>
          <div class="ms-auto d-flex ">
            <a class="btn text-light" href="">
              ADMIN
              <img src="./assets/images/user.png" alt="" width="18" height="18" class="">
            </a>
          </div>
      </header>
      <main>
        <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow-lg">
          <div class = "d-flex justify-content-between align-items-center mb-3">
            <h3>Categories</h3>
            <button type="button" onclick = "openAddCategoryModal()" class = "btn btn-secondary rounded" data-bs-toggle="modal" data-bs-target="#staticBackdrop">New</button>
          </div>
          <cfset categoryResult = application.obj.fetchCategories()>
          <cfoutput>
            <cfloop query="categoryResult">
            <div class = "d-flex justify-content-between align-items-center" id = "#fldCategory_Id#">
              <div>#fldCategoryName#</div>
              <div>
                <button type="button" onclick = "editCategory(#fldCategory_Id#)" class = "btn btn-outline-info  px-3 my-2" data-bs-toggle="modal" data-bs-target="##staticBackdrop">
                  <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
                </button>
                <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteCategory(#fldCategory_Id#)">
                  <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
                </button>
                <button class = "btn btn-outline-info  px-3 my-2">
                  <img src="./assets/images/right-arrow.png" alt="" width="18" height="18" class="">
                </button>
              </div>
            </div>
            </cfloop>
              <span class="text-success" id ="categoryResult"></span>        
          </cfoutput>
        </div>
      </main>
      <footer></footer>
      <script src="assets/js/shoppingCart.js"></script>


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
                <button onClick = addCategory() type="submit" name = "modalSubmitBtn" class="btn btn-primary" id = "modalSubmitBtn" value = "">Add</button>
              </div>
            </div>
          </div>
        </div>
      </form>
    </body>
</html>
