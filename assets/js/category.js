function clearErrorMessages(){
    const errorFields = [
        "categoryNameError"
    ];

    errorFields.forEach(fieldId => {
        const errorElement = document.getElementById(fieldId);
        if (errorElement) {
            errorElement.textContent = "";
        }
    });
}

function openAddCategoryModal(){
    clearErrorMessages();
    let categoryName = $("#categoryName");
    categoryName.removeClass("border-danger")
    document.querySelector(".modal-title").textContent = "Add Category";
    document.getElementById("categoryAddForm").reset();
    document.getElementById("modalSubmitBtn").value = "";
}

function saveCategory(){
    let isModalValid = modalValidate()
    if(!isModalValid){
        return false;  // client side validation failed case
    }

    const categoryName = document.getElementById("categoryName").value
    // console.log(categoryName)
    if (document.getElementById("modalSubmitBtn").value.length==0){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=addCategory",
            data:{categoryName: categoryName},
            success:function(response){
                // alert(response)
                let responseParsed = JSON.parse(response);
                // console.log(responseParsed)
                let categoryId = responseParsed.categoryId;
                document.getElementById("categoryFunctionResult").innerHTML = responseParsed.resultMsg;
                let categoryEachDiv = 
                `<div class = "d-flex justify-content-between align-items-center" id = "${categoryId}">
                    <div id = "categoryname-${categoryId}">${categoryName}</div>
                    <div>
                        <button type="button" 
                                onclick = "editCategory(${categoryId})" 
                                class = "btn btn-outline-info  px-3 my-2" 
                                data-bs-toggle="modal" 
                                data-bs-target="##staticBackdrop">
                        <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
                        </button>
                        <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteCategory(${categoryId})">
                        <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
                        </button>
                        <a class = "btn btn-outline-info  px-3 my-2" href ="subCategory.cfm?categoryId=${categoryId}&categoryName=${categoryName}">
                        <img src="./assets/images/right-arrow.png" alt="" width="18" height="18" class="">
                        </a>
                    </div>
                </div>`
                $("#mainDiv").append(categoryEachDiv);
                // location.reload();
            }
        })
    }
    else{   
        const categoryId =  document.getElementById("modalSubmitBtn").value
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=editCategory",
            data:{categoryName: categoryName,categoryId : categoryId},
            success:function(response){
                let responseParsed = JSON.parse(response);
                console.log(responseParsed)
                if(responseParsed != "Category Name already exists"){
                    document.getElementById("categoryname-"+categoryId).textContent=categoryName
                }
                document.getElementById("categoryFunctionResult").innerHTML = responseParsed;
            }
    })
    }
}

function editCategory(fldCategory_Id){
    clearErrorMessages();
    let categoryName = $("#categoryName");
    categoryName.removeClass("border-danger")
    document.querySelector(".modal-title").textContent = "Edit Category";
    // autopopulate category name
    document.getElementById("categoryName").value = document.getElementById(fldCategory_Id).childNodes[1].textContent;
    document.getElementById("modalSubmitBtn").value = fldCategory_Id;
    
}

function modalValidate(){
    let isValid = true;
    // const namePattern = /^[a-zA-Z\s- ]+$/
    let categoryName = $("#categoryName");
    
    if (categoryName.val().trim().length===0) {
        document.getElementById("categoryNameError").textContent = "Enter Category Name";
        categoryName.addClass("border-danger");
        isValid = false;
    }
    /* if (!namePattern.test(categoryName)) {
        document.getElementById("categoryNameError").textContent = "Category Name should only contain letters";
        isValid = false;
    } */

    return isValid;
}

function deleteCategory(fldCategory_Id){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=deleteCategory",
            data:{categoryId: fldCategory_Id},
            success:function(){
            document.getElementById(fldCategory_Id).remove()  
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
