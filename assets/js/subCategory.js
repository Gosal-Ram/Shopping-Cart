function openAddSubCategoryModal(){
    document.getElementById("subCategoryNameError").textContent=""
    document.querySelector(".modal-title").textContent = "Add Sub Category";
    document.getElementById("categoryAddForm").reset();
    document.getElementById("modalSubmitBtn").value = "";
}

function saveSubCategory(){
    let params = new URLSearchParams(document.location.search);
    let categoryId =params.get("categoryId")
    let subCategoryId = document.getElementById("modalSubmitBtn").value
    // console.log(subCategoryId)
    
    const subCategoryName = document.getElementById("subCategoryName").value
    const selectedCategoryId = document.getElementById("categorySelect").value
    // console.log(subCategoryName)
    // console.log(selectedCategoryId)
    if (document.getElementById("modalSubmitBtn").value.length==0){
        // add NEW SUB CATEGORY
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=addSubCategory",
            data:{subCategoryName: subCategoryName, selectedCategoryId:selectedCategoryId},
            success:function(response){
                // alert(response)
                let subCategoryId = JSON.parse(response);
                // document.getElementById("subCategoryFunctionResult").innerHTML = responseParsed;
                let subCategoryEachDiv = 
                `<div class = "d-flex justify-content-between align-items-center" id = "${subCategoryId}">
                <div id = "subcategoryname-${subCategoryId}">${subCategoryName}</div>
                <div>
                  <button type="button" 
                          onclick = "editSubCategory(${subCategoryId})" 
                          class = "btn btn-outline-info  px-3 my-2" 
                          data-bs-toggle="modal" 
                          data-bs-target="#staticBackdrop">
                    <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
                  </button>
                  <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteSubCategory(${subCategoryId})">
                    <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
                  </button>
                  <a class = "btn btn-outline-info  px-3 my-2" href ="product.cfm?subCategoryId=${subCategoryId}&subCategoryName=${subCategoryName}">
                    <img src="./assets/images/right-arrow.png" alt="" width="18" height="18" class="">
                  </a>
                </div>
              </div>`
                $("#mainDiv").append(subCategoryEachDiv);
            }
        })
    }
    else{   
        // edit EXISTING SUB CATEGORY
        const subCategoryId =  document.getElementById("modalSubmitBtn").value
        // console.log(categoryId)
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=editSubCategory",
            data:{subCategoryName: subCategoryName, selectedCategoryId:selectedCategoryId, subCategoryId : subCategoryId},
            success:function(response){
                let responseParsed = JSON.parse(response);
                // console.log(responseParsed)
                if (categoryId != selectedCategoryId){
                    document.getElementById(subCategoryId).remove()
                }
                if(responseParsed != "Sub Category Name already exists"){
                    document.getElementById("subcategoryname-"+subCategoryId).textContent=subCategoryName

                }
                document.getElementById("subCategoryFunctionResult").innerHTML = responseParsed;
            }
    })
    }
}

function editSubCategory(fldSubCategory_Id){
    document.getElementById("subCategoryNameError").textContent=""
    document.querySelector(".modal-title").textContent = "Edit Sub Category";
    // autopopulate category name
    document.getElementById("subCategoryName").value = document.getElementById(fldSubCategory_Id).childNodes[1].textContent;
    document.getElementById("modalSubmitBtn").value = fldSubCategory_Id;
    
}

function modalValidate(){
    let isValid = true;
    let subCategoryName = document.getElementById("subCategoryName").value;
    
    if (subCategoryName.trim().length==0) {
        document.getElementById("subCategoryNameError").textContent = "Enter Category Name";
        isValid = false;
    }
    return isValid;
}

function deleteSubCategory(fldSubCategory_Id){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=deleteSubCategory",
            data:{subCategoryId: fldSubCategory_Id},
            success:function(){
            document.getElementById(fldSubCategory_Id).remove()  
            }
        })
    }
}

function logOut(){
    if(confirm("Confirm logout")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=logOut",
            success:function(){
              location.reload();
            }
        })
    }
} 
