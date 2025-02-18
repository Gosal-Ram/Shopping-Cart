<cfset variables.categoryId = decrypt(url.categoryId,application.key,"AES","Base64")>
<cfset variables.getCategoryName = application.shoppingCart.fetchCategories(variables.categoryId)>
<cfset variables.categoryName = #variables.getCategoryName[1].categoryName#>

<cfoutput>
<main>
  <cfset variables.getAllSubCategories = application.shoppingCart.fetchSubCategories(variables.categoryId)>
  <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow-lg" id ="mainDiv">
    <div class = "d-flex justify-content-between align-items-center mb-3" >
      <h3>#variables.categoryName#</h3>
      <button type="button" onclick = "openAddSubCategoryModal()" class = "btn btn-secondary rounded" data-bs-toggle="modal" data-bs-target="##staticBackdrop">
        New
      </button>
    </div>
    <span class="text-success" id ="subCategoryFunctionResult"></span>
    <cfloop array="#variables.getAllSubCategories#" item="local.item">
      <cfset variables.encryptedSubCategoryId = encrypt("#local.item.subCategoryId#",application.key,"AES","Base64")>
      <cfset variables.encodedSubCategoryId = encodeForURL(variables.encryptedSubCategoryId)>
      <div class = "d-flex justify-content-between align-items-center" id = "#local.item.subCategoryId#">
        <div id ="subcategoryname-#local.item.subCategoryId#">#local.item.subCategoryName#</div>
        <div>
          <button type="button" onclick = "editSubCategory(#local.item.subCategoryId#)" class = "btn btn-outline-info  px-3 my-2" data-bs-toggle="modal" data-bs-target="##staticBackdrop">
            <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
          </button>
          <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteSubCategory(#local.item.subCategoryId#)">
            <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
          </button>
          <a class = "btn btn-outline-info  px-3 my-2" id="subcategory-link-#local.item.subCategoryId#"
            href ="product.cfm?subCategoryId=#encodedSubCategoryId#">
            <img src="./assets/images/right-arrow.png" alt="" width="18" height="18" class="">
          </a>
        </div>
      </div>
    </cfloop>
  </div>
</main>
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
                <cfloop array="#variables.getAllCategories#" item="local.item">
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
            <input type="text" name="subCategoryName" id="subCategoryName" value="" placeholder="Sub Category Name" class="form-control">
            <div id="subCategoryNameError" class="text-danger"></div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          <button onClick = "saveSubCategory(#variables.categoryId#)" 
                  type="button" 
                  name ="modalSubmitBtn" 
                  class="btn btn-primary" 
                  id = "modalSubmitBtn">
                  Add
          </button>
        </div>
      </div>
    </div>
  </div>
</form>

</cfoutput>

