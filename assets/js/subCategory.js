function openAddSubCategoryModal(){
    document.getElementById("subCategoryNameError").textContent="";
    document.querySelector(".modal-title").textContent = "Add Sub Category";
    document.getElementById("SubCategoryAddForm").reset();
    document.getElementById("modalSubmitBtn").value = "";
}

function saveSubCategory(categoryId){
    let isModalValid = modalValidate();
    if(!isModalValid){
        return false;
    }
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
                        </div>`;
                $("#mainDiv").append(subCategoryEachDiv);
                // location.reload();
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
                console.log(responseParsed.resultMsg);
                document.getElementById("subCategoryFunctionResult").innerHTML = responseParsed.resultMsg;
                if (categoryId != selectedCategoryId){
                    document.getElementById(subCategoryId).remove();
                }
                if(responseParsed.resultMsg != "Sub Category Name already exists"){
                    document.getElementById("subcategoryname-"+subCategoryId).textContent=responseParsed.subCategoryName;
                }
                // location.reload();
            }
        })
    }
}

function editSubCategory(subCategoryId){
    document.getElementById("SubCategoryAddForm").reset();
    document.getElementById("subCategoryNameError").textContent="";
    let subCategoryName = $("#subCategoryName");
    subCategoryName.removeClass("border-danger");
    document.querySelector(".modal-title").textContent = "Edit Sub Category";
    document.getElementById("subCategoryName").value = document.getElementById(subCategoryId).childNodes[1].textContent;  // autopopulate category name
    document.getElementById("modalSubmitBtn").value = subCategoryId;
    
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

function deleteSubCategory(subCategoryId){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{subCategoryId: subCategoryId,
                method : "deleteSubCategory"
            },
            success:function(){
            document.getElementById(subCategoryId).remove();  
            }
        })
    }
}