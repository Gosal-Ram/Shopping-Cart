function openAddCategoryModal(){
    document.getElementById( "categoryNameError").textContent = "";
    let categoryName = $("#categoryName");
    categoryName.removeClass("border-danger")
    document.querySelector(".modal-title").textContent = "Add Category";
    document.getElementById("categoryAddForm").reset();
    document.getElementById("modalSubmitBtn").value = ""; // to differntiate add AND edit
}

function saveCategory(){
    let isModalValid = modalValidate();
    if(!isModalValid){
        return false;  
    }
    const categoryName = document.getElementById("categoryName").value;
    if (document.getElementById("modalSubmitBtn").value.length==0){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{categoryName: categoryName,
                method : "addCategory"
            },
            success:function(response){
                let responseParsed = JSON.parse(response);
                let categoryId = responseParsed.categoryId;
                document.getElementById("categoryFunctionResult").innerHTML = responseParsed.resultMsg;
                location.reload();
            }
        })
    }
    else{   
        const categoryId =  document.getElementById("modalSubmitBtn").value;
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{categoryName: categoryName,
                categoryId : categoryId,
                method : "editCategory"},
            success:function(response){
                let responseParsed = JSON.parse(response);
                location.reload();
            }
    })
    }
}

function editCategory(fldCategory_Id){
    document.getElementById( "categoryNameError").textContent = "";
    let categoryName = $("#categoryName");
    categoryName.removeClass("border-danger");
    document.querySelector(".modal-title").textContent = "Edit Category";
    document.getElementById("categoryName").value = document.getElementById(fldCategory_Id).childNodes[1].textContent;// autopopulate category name
    document.getElementById("modalSubmitBtn").value = fldCategory_Id;
}

function modalValidate(){
    let isValid = true;
    const namePattern = /^[A-Za-z ]+$/;
    let categoryName = $("#categoryName");
    
    if (categoryName.val().trim().length===0) {
        document.getElementById("categoryNameError").textContent = "Enter Category Name";
        categoryName.addClass("border-danger");
        isValid = false;
    }
    if (!namePattern.test((categoryName.val().trim()))) {
        document.getElementById("categoryNameError").textContent = "Category Name should only contain letters";
        isValid = false;
    } 
    return isValid;
}

function deleteCategory(fldCategory_Id){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{categoryId: fldCategory_Id,
                  method:"deleteCategory"
            },
            success:function(){
            document.getElementById(fldCategory_Id).remove();
            }
        })
    }
}