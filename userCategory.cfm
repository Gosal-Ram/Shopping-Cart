<cfinclude template="header.cfm">
<cfset variables.categoryId = url.categoryId>
<cfoutput>
<main>
    <div class="container-fluid my-3 ms-3">
        <cfset variables.getCategoryNames = application.shoppingCart.fetchCategories(variables.categoryId)>
        <h2>#variables.getCategoryNames.fldCategoryName#</h2>
        <cfset variables.getAllSubCategories = application.shoppingCart.fetchSubCategories(variables.categoryId)>
        <cfloop query="variables.getAllSubCategories">
            <a class="h4 text-decoration-none" href = "userSubCategory.cfm?subCategoryId=#variables.getAllSubCategories.fldSubCategory_Id#&subCategoryName=#variables.getAllSubCategories.fldSubCategoryName#" >
            <h4> #variables.getAllSubCategories.fldSubCategoryName#</h4>
            </a>
            <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(subCategoryId = variables.getAllSubCategories.fldSubCategory_Id)>
            <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
                <cfloop query="variables.getAllProducts">
                    <a  class = "card m-2 p-2 productCard text-decoration-none" href = "userProduct.cfm?productId=#variables.getAllProducts.fldProduct_Id#">
                    <div>
                        <img src="./assets/images/productImages/#variables.getAllProducts.fldImageFilename#" 
                            class="w-100"
                            alt="" 
                            class=""
                            style="height: 150px; object-fit: contain;">
                        <div class="card-body">
                            <h6 class="card-title" id = "#variables.getAllProducts.fldProduct_Id#">#variables.getAllProducts.fldProductName#</h6>
                            <div class="card-text text-muted">  #variables.getAllProducts.fldBrandName#</div>
                            <div class="card-text text-dark fw-semibold"><i class="fa-solid fa-indian-rupee-sign me-1"></i>#variables.getAllProducts.fldPrice#</div>
                            <div class="card-text productDescription">#variables.getAllProducts.fldDescription#</div>
                        </div>
                    </div>
                    </a>
                </cfloop> 
            </div>
        </cfloop>  
    </div>
</main>

</cfoutput>

<cfinclude  template="footer.cfm">

