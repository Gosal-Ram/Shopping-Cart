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

function loginValidate(){
    let userName = $("#userInput");
    let pwd = $("#password");
    let userNameError = document.getElementById("userInputError");
    let pwdError = document.getElementById("passwordError");
    userNameError.textContent = "";
    pwdError.textContent = "";
    userName.removeClass("border-danger")
    pwd.removeClass("border-danger")
    let isValid = true;
    const phoneRegex = /^[0-9]{10}$/;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; 

    const setError = (element, errorElement, message) => {
        errorElement.textContent = message;
        element.addClass("border-danger");
        isValid = false;
    };

    const clearError = (element, errorElement) => {
        errorElement.textContent = "";
        element.removeClass("border-danger");
    };

    const userNameValue = userName.val().trim();
    if (!userNameValue) {
        setError(userName, userNameError, "Enter phone number or email id");
    } else if (!phoneRegex.test(userNameValue) && !emailRegex.test(userNameValue)) {
        setError(userName, userNameError, "Enter a valid phone number or email id");
    } else {
        clearError(userName, userNameError);
    }
    const passwordValue = pwd.val().trim();
    if (!passwordValue) {
        setError(pwd, pwdError, "Enter your password");
    } else {
        clearError(pwd, pwdError);
    }
    return isValid;
}

function openAddCategoryModal(){
    clearErrorMessages();
    document.querySelector(".modal-title").textContent = "Add Category";
    document.getElementById("categoryAddForm").reset();
    document.getElementById("modalSubmitBtn").value = "";
}

function addCategory(){
    const categoryName = document.getElementById("categoryName").value
    console.log(categoryName)
    if (document.getElementById("modalSubmitBtn").value.length==0){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=addCategory",
            data:{categoryName: categoryName},
            success:function(response){
                let responseParsed = JSON.parse(response);
                document.getElementById("categoryResult").value = responseParsed;
                location.reload()
            }
        })
    }
    else{   
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=editCategory",
            data:{categoryName: categoryName,categoryId : document.getElementById("modalSubmitBtn").value},
            success:function(response){
                let responseParsed = JSON.parse(response);
                document.getElementById("categoryResult").value = responseParsed;
                location.reload()
            }
    })
    }

}

function editCategory(fldCategory_Id){
    clearErrorMessages();
    document.querySelector(".modal-title").textContent = "Edit Category";
    document.getElementById("categoryName").value = document.getElementById(fldCategory_Id).childNodes[1].textContent;
    document.getElementById("modalSubmitBtn").value = fldCategory_Id;
    
}

function modalValidate(){
    let isValid = true;
    const namePattern = /^[a-zA-Z\s- ]+$/
    let categoryName = document.getElementById("categoryName").value;
    
    if (categoryName.trim().length==0) {
        document.getElementById("categoryNameError").textContent = "Enter Category Name";
        isValid = false;
    }
    if (!namePattern.test(categoryName)) {
        document.getElementById("categoryNameError").textContent = "Category Name should only contain letters";
        isValid = false;
    }

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
