
<cfset variables.categoryId = decrypt(url.categoryId,application.key,"AES","Base64")>
<cfset variables.getCategoryName = application.shoppingCart.fetchCategories(variables.categoryId)>
<cfset variables.categoryName = #variables.getCategoryName[1].categoryName#>

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
      <cfset variables.getAllSubCategories = application.shoppingCart.fetchSubCategories(variables.categoryId)>
      <span class="text-success" id ="subCategoryFunctionResult"></span>
      <cfloop array="#variables.getAllSubCategories#" item="item">
      
      <cfset variables.encryptedSubCategoryId = encrypt("#item.subCategoryId#",application.key,"AES","Base64")>
      <cfset variables.encodedSubCategoryId = encodeForURL(variables.encryptedSubCategoryId)>
        <!--- <cfloop query="variables.queryGetSubCategories"> --->
        <div class = "d-flex justify-content-between align-items-center" id = "#item.subCategoryId#">
          <div id = "subcategoryname-#item.subCategoryId#">#item.subCategoryName#</div>
          <div>
            <button type="button" 
                    onclick = "editSubCategory(#item.subCategoryId#)" 
                    class = "btn btn-outline-info  px-3 my-2" 
                    data-bs-toggle="modal" 
                    data-bs-target="##staticBackdrop">
              <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
            </button>
            <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteSubCategory(#item.subCategoryId#)">
              <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
            </button>
            <a class = "btn btn-outline-info  px-3 my-2" 
            id="subcategory-link-#item.subCategoryId#"
            href ="product.cfm?subCategoryId=#encodedSubCategoryId#">
<!---             href ="product.cfm?subCategoryId=#item.subCategoryId#&categoryId=#variables.categoryId#"> --->
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
                <!---<cfloop query="variables.getAllCategories"> --->
                <cfloop array="#variables.getAllCategories#" item="item">
                  <option 
                    <cfif variables.categoryId EQ #item.categoryId#>
                      selected
                    </cfif>
                    value="#item.categoryId#">
                    #item.categoryName#
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

