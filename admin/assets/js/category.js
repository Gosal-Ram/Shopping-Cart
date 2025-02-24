function openAddCategoryModal(){
    document.getElementById( "categoryNameError").textContent = "";
    $("#categoryName").removeClass("border-danger")
    document.querySelector(".modal-title").textContent = "Add Category";
    document.getElementById("categoryAddForm").reset();
    document.getElementById("modalSubmitBtn").value = ""; // to differntiate add AND edit
}

function saveCategory(){
    let isModalValid = saveCategoryValidate();
    if(!isModalValid){
        return false;  
    }
    const categoryName = document.getElementById("categoryName").value;
    if (document.getElementById("modalSubmitBtn").value.length==0){
        $.ajax({
            type:"POST",
            url: "/component/admin.cfc",
            data:{categoryName: categoryName,
                method : "addCategory"
            },
            success:function(response){
                let responseParsed = JSON.parse(response);
                let categoryId = responseParsed.categoryId;
                document.getElementById("categoryFunctionResult").innerHTML = responseParsed.resultMsg;
                /* let categoryEachDiv = 
                `<div class = "d-flex justify-content-between align-items-center" id = "${categoryId}">
                    <div id = "categoryname-${categoryId}">${categoryName}</div>
                    <div>
                        <button type="button" 
                                onclick = "editCategory(${categoryId})" 
                                class = "btn btn-outline-info  px-3 my-2" 
                                data-bs-toggle="modal" 
                                data-bs-target="#staticBackdrop">
                        <img src="/assets/images/editing.png" alt="" width="18" height="18" class="">
                        </button>
                        <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteCategory(${categoryId})">
                        <img src="/assets/images/trash.png" alt="" width="18" height="18" class="">
                        </button>
                        <a class = "btn btn-outline-info  px-3 my-2" href ="subCategory.cfm?categoryId=${categoryId}&categoryName=${categoryName}">
                        <img src="/assets/images/right-arrow.png" alt="" width="18" height="18" class="">
                        </a>
                    </div>
                </div>`;
                $("#mainDiv").append(categoryEachDiv); */
                location.reload();  
            }
        })
    }
    else{   
        const categoryId =  document.getElementById("modalSubmitBtn").value;
        $.ajax({
            type:"POST",
            url: "/component/admin.cfc",
            data:{categoryName: categoryName,
                categoryId : categoryId,
                method : "editCategory"},
            success:function(response){
                let responseParsed = JSON.parse(response);
                if(responseParsed == "Category Edited"){
                    document.getElementById("categoryname-"+categoryId).textContent=categoryName;
                }
                document.getElementById("categoryFunctionResult").innerHTML = responseParsed;
            }
    })
    }
}

function editCategory(categoryId){
    document.getElementById( "categoryNameError").textContent = "";
    let categoryName = $("#categoryName");
    categoryName.removeClass("border-danger");
    document.querySelector(".modal-title").textContent = "Edit Category";
    document.getElementById("categoryName").value = document.getElementById(categoryId).childNodes[1].textContent;// autopopulate category name
    document.getElementById("modalSubmitBtn").value = categoryId;
}


function deleteCategory(categoryId) {
    alertify.confirm("Confirm delete",
        function() { 
            $.ajax({
                type: "POST",
                url: "/component/admin.cfc",
                data: {
                    categoryId: categoryId,
                    method: "deleteCategory"
                },
                success: function() {
                    document.getElementById(categoryId).remove();
                    alertify.success('Category deleted');
                },
                error: function() {
                    alertify.error('Failed to delete category');
                }
            });
        },
        function() { 
            alertify.error('Delete canceled');
        }
    );
}
