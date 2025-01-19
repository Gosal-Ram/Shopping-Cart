<cfset variables.categoryId = url.categoryId>
<cfset variables.categoryName = url.categoryName>
<cfoutput>
  <cfinclude  template="header.cfm">
  <main>
    <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow-lg" id ="mainDiv">
      <div class = "d-flex justify-content-between align-items-center mb-3" >
        <h3>#variables.categoryName#</h3>
        <button type="button"
                onclick = "openAddSubCategoryModal()"
                class = "btn btn-secondary rounded" 
                data-bs-toggle="modal" 
                data-bs-target="##staticBackdrop">
                New
        </button>
      </div>
      <cfset variables.queryGetSubCategories = application.shoppingCart.fetchSubCategories(variables.categoryId)>
      <span class="text-success" id ="subCategoryFunctionResult"></span>
      <cfloop query="variables.queryGetSubCategories">
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
            href ="product.cfm?subCategoryId=#fldSubCategory_Id#&subCategoryName=#fldSubCategoryName#&categoryId=#variables.categoryId#">
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
              <cfset variables.getAllCategories = application.shoppingCart.fetchCategories()>
                <cfloop query="variables.getAllCategories">
                  <option 
                    <cfif variables.categoryId EQ #variables.getAllCategories.fldCategory_Id#>
                      selected
                    </cfif>
                    value="#variables.getAllCategories.fldCategory_Id#">
                    #variables.getAllCategories.fldCategoryName#
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
<cfinclude  template="footer.cfm">

