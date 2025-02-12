function openAddSubCategoryModal(){
    document.getElementById("subCategoryNameError").textContent="";
    document.querySelector(".modal-title").textContent = "Add Sub Category";
    document.getElementById("SubCategoryAddForm").reset();
    document.getElementById("modalSubmitBtn").value = "";
}

function saveSubCategory(){
    let isModalValid = modalValidate();
    if(!isModalValid){
        return false;
    }
    let params = new URLSearchParams(document.location.search);
    let categoryId =params.get("categoryId");
    let subCategoryId = document.getElementById("modalSubmitBtn").value;
    const subCategoryName = document.getElementById("subCategoryName").value
    const selectedCategoryId = document.getElementById("categorySelect").value;
    if (document.getElementById("modalSubmitBtn").value.length==0){          // add NEW SUB CATEGORY
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{subCategoryName: subCategoryName, 
                selectedCategoryId:selectedCategoryId,
                method : "addSubCategory"},
            success:function(response){
                let responseParsed = JSON.parse(response);
                document.getElementById("subCategoryFunctionResult").innerHTML = responseParsed.resultMsg;
                let subCategoryId = responseParsed.subCategoryid;
                location.reload();
            }
        })
    }
    else{   
        const subCategoryId =  document.getElementById("modalSubmitBtn").value;   // edit EXISTING SUB CATEGORY
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{subCategoryName: subCategoryName, 
                selectedCategoryId:selectedCategoryId, 
                subCategoryId : subCategoryId,
                method : "editSubCategory"
            },
            success:function(response){
                let responseParsed = JSON.parse(response);
                location.reload();
            }
        })
    }
}

function editSubCategory(fldSubCategory_Id){
    document.getElementById("SubCategoryAddForm").reset();
    document.getElementById("subCategoryNameError").textContent=""
    let subCategoryName = $("#subCategoryName");
    subCategoryName.removeClass("border-danger");
    document.querySelector(".modal-title").textContent = "Edit Sub Category";
    document.getElementById("subCategoryName").value = document.getElementById(fldSubCategory_Id).childNodes[1].textContent;  // autopopulate category name
    document.getElementById("modalSubmitBtn").value = fldSubCategory_Id;
    
}

function modalValidate(){
    let isValid = true;
    let subCategoryName = $("#subCategoryName");
    const namePattern = /^[A-Za-z ]+$/;

    if (subCategoryName.val().trim().length==0) {
        document.getElementById("subCategoryNameError").textContent = "Enter Category Name";
        subCategoryName.addClass("border-danger");
        isValid = false;
    }
    if (!namePattern.test((subCategoryName.val().trim()))) {
        document.getElementById("subCategoryNameError").textContent = "Subcategory Name should only contain letters";
        isValid = false;
    } 
    return isValid;
}

function deleteSubCategory(fldSubCategory_Id){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{subCategoryId: fldSubCategory_Id,
                method : "deleteSubCategory"
            },
            success:function(){
            document.getElementById(fldSubCategory_Id).remove();  
            }
        })
    }
}