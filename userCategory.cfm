<cfinclude template="header.cfm">
<cfset variables.categoryId = url.categoryId>
<!--- <cfdump  var="#variables.categoryId#"> --->
<cfoutput>
<main>
    <div class="container-fluid my-3 ms-3">
        <cfset variables.getCategoryNames = application.shoppingCart.fetchCategoryInfo(variables.categoryId)>
        <!---<cfdump  var="#variables.getCategoryNames.fldCategoryName#">--->
        <h2>#variables.getCategoryNames.fldCategoryName#</h2>
        <cfset variables.getAllSubCategories = application.shoppingCart.fetchSubCategories(variables.categoryId)>
        <cfloop query="variables.getAllSubCategories">
            <h4> #variables.getAllSubCategories.fldSubCategoryName#</h4>
            <cfset variables.getAllProducts = application.shoppingCart.fetchProducts(subCategoryId = variables.getAllSubCategories.fldSubCategory_Id)>
            <!---<cfdump  var="#variables.getAllProducts#"> --->
            <div class= "productListingContainer d-flex flex-sm-wrap ms-5 mb-3 ">
                <cfloop query="variables.getAllProducts">
                    <div class = "card m-2 productCard">
                        <img src="./assets/images/productImages/#variables.getAllProducts.fldImageFilename#" class="w-100"  alt="" height="170" class="">
                        <div class="card-body">
                            <h6 class="card-title" id = "#variables.getAllProducts.fldProduct_Id#">#variables.getAllProducts.fldProductName#</h6>
                            <div class="card-text">  #variables.getAllProducts.fldBrandName#</div>
                            <div class="card-text">#variables.getAllProducts.fldPrice#</div>
                            <div class="card-text productDescription">#variables.getAllProducts.fldDescription#</div>
                        </div>
                    </div>
                </cfloop> 
            </div>
        </cfloop>  
    </div>
</main>

</cfoutput>

<cfinclude  template="footer.cfm">

