function userProfileValidate() {
    let firstName = $("#userFirstName");
    let lastName = $("#userLastName");
    let emailId = $("#userEmail");
    let phone = $("#userPhone");

    let firstNameError = document.getElementById("firstNameError");
    let lastNameError = document.getElementById("lastNameError");
    let emailIdError = document.getElementById("emailIdError");
    let phoneError = document.getElementById("phoneError");

    const nameRegex = /^[A-Za-z ]{2,}( [A-Za-z ]{1,})?$/;
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^[0-9]{10}$/;

    let isValid = true;
    let setError = (element, errorElement, message) => {
        errorElement.textContent = message;
        element.addClass("border-danger");
        isValid = false;
    };
    let resetError = (element, errorElement) => {
        errorElement.textContent = "";
        element.removeClass("border-danger");
    };

    let firstNameValue = firstName.val().trim();
    if (firstNameValue === "") {
        setError(firstName, firstNameError, "First name must be atleast 2 characters.");
    } else if (!nameRegex.test(firstNameValue)) {
        setError(firstName, firstNameError, "Enter a valid first Name ");
    } else {
        resetError(firstName, firstNameError);
    }

    let lastNameValue = lastName.val().trim();
    if (lastNameValue === "") {
        setError(lastName, lastNameError, "Last name must be atleast 2 characters.");
    } else if (!nameRegex.test(lastNameValue)) {
        setError(lastName, lastNameError, "Enter a valid last Name ");
    } else {
        resetError(lastName, lastNameError);
    }

    let emailIdValue = emailId.val().trim();
    console.log(emailIdValue);
    if (emailIdValue == "") {
        setError(emailId, emailIdError, "Email is required.");
    } else if (!emailRegex.test(emailIdValue)) {
        setError(emailId, emailIdError, "Enter a valid email address.");
    } else {
        resetError(emailId, emailIdError);
    }

    let phoneValue = phone.val().trim();
    if (phoneValue === "") {
        setError(phone, phoneError, "Phone number is required.");
    } else if (!phoneRegex.test(phoneValue)) {
        setError(phone, phoneError, "Enter a valid 10-digit phone number.");
    } else {
        resetError(phone, phoneError);
    }

    if (!isValid) {
        event.preventDefault();

    }
}

function addressValidate(){
    let firstName = $("#receiverFirstName");
    let lastName = $("#receiverLastName");
    let emailId = $("#receiverEmail");
    let phone = $("#receiverPhone");
    let addLine1 = $("#newAddressLine1");
    let addLine2 = $("#newAddressLine2");
    let city = $("#receiverCity");
    let state = $("#receiverState");
    let pincode = $("#receiverPin");

    let firstNameError = document.getElementById("receiverFirstNameError");
    let lastNameError = document.getElementById("receiverLastNameError");
    let emailIdError = document.getElementById("receiverEmailError");
    let phoneError = document.getElementById("receiverPhoneError");
    let addLine1Error = document.getElementById("addressLine1Error");
    let addLine2Error = document.getElementById("addressLine2Error");
    let cityError = document.getElementById("cityError");
    let stateError = document.getElementById("stateError");
    let pincodeError = document.getElementById("pincodeError");

    const nameRegex = /^[A-Za-z ]{2,}( [A-Za-z ]{1,})?$/;
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^[0-9]{10}$/;
    const addressRegex = /^[A-Za-z0-9 ,#-]{3,}$/;
    const cityStateRegex = /^[A-Za-z ]{2,}$/;
    const pincodeRegex = /^[0-9]{6}$/;

    let isValid = true;
    let setError = (element, errorElement, message) => {
        errorElement.textContent = message;
        element.addClass("border-danger");
        isValid = false;
    };
    let resetError = (element, errorElement) => {
        errorElement.textContent = "";
        element.removeClass("border-danger");
    };

    let validateField = (field, errorElement, regex, emptyMessage, invalidMessage) => {
        let value = field.val().trim();
        if (value === "") {
            setError(field, errorElement, emptyMessage);
        } else if (!regex.test(value)) {
            setError(field, errorElement, invalidMessage);
        } else {
            resetError(field, errorElement);
        }
    };

    validateField(firstName, firstNameError, nameRegex, "First name is required.", "Enter a valid first name.");
    validateField(lastName, lastNameError, nameRegex, "Last name is required.", "Enter a valid last name.");
    validateField(emailId, emailIdError, emailRegex, "Email is required.", "Enter a valid email address.");
    validateField(phone, phoneError, phoneRegex, "Phone number is required.", "Enter a valid 10-digit phone number.");
    validateField(addLine1, addLine1Error, addressRegex, "Address Line 1 is required.", "Enter a valid address.");
    validateField(city, cityError, cityStateRegex, "City is required.", "Enter a valid city name.");
    validateField(state, stateError, cityStateRegex, "State is required.", "Enter a valid state name.");
    validateField(pincode, pincodeError, pincodeRegex, "Pincode is required.", "Enter a valid 6-digit pincode.");

    return isValid;
}

function updateUserInfoModal(){
    document.getElementById("firstNameError").textContent = "";
    document.getElementById("lastNameError").textContent = "";
    document.getElementById("emailIdError").textContent = "";
    document.getElementById("phoneError").textContent = "";
    
    $("#userFirstName").removeClass("border-danger");
    $("#userLastName").removeClass("border-danger");
    $("#userEmail").removeClass("border-danger");
    $("#userPhone").removeClass("border-danger");
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

/* 
function saveUserProfile() {
    let isModalValid = userProfileValidate();
    if(!isModalValid){
        return false;
    }
    let firstName = document.getElementById("userFirstName").value;
    let lastName = document.getElementById("userLastName").value;
    let email = document.getElementById("userEmail").value;
    let phone = document.getElementById("userPhone").value;

    $.ajax({
        type: "POST",
        url: "component/user.cfc",
        data: { method: "updateUserInfo", firstName: firstName,firstName: firstName,  email: email, phone: phone },
        success: function () {
            document.getElementById("userName").textContent = name;
            document.getElementById("userEmail").textContent = email;
            document.getElementById("userPhone").textContent = phone;
            $("#editUserModal").modal("hide");
        }
    });
} 
    */

function saveNewAddress() {
    let isaddressModalValid = addressValidate();
    if(!isaddressModalValid){
        return false;  
    }



let address = document.getElementById("newAddress").value;

    $.ajax({
        type: "POST",
        url: "component/user.cfc",
        data: { method: "addAddress", address: address },
        success: function () {
            let newAddressHTML = `
                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="address" checked>
                    <label class="form-check-label">${address}</label>
                </div>
            `;
            document.getElementById("addressForm").insertAdjacentHTML("beforeend", newAddressHTML);
            $("#addAddressModal").modal("hide");
        }
    });
}


function openAddAddressModal(){
    document.getElementById("receiverFirstNameError").textContent = "";
    document.getElementById("receiverLastNameError").textContent = "";
    document.getElementById("receiverPhoneError").textContent = "";
    document.getElementById("receiverEmailError").textContent = "";
    document.getElementById("addressLine1Error").textContent = "";
    document.getElementById("addressLine2Error").textContent = "";
    document.getElementById("emailIdError").textContent = "";
    document.getElementById("cityError").textContent = "";
    document.getElementById("stateError").textContent = "";
    document.getElementById("pincodeError").textContent = "";
    
    $("#receiverFirstName").removeClass("border-danger");
    $("#receiverLastName").removeClass("border-danger");
    $("#receiverPhone").removeClass("border-danger");
    $("#receiverEmail").removeClass("border-danger");
    $("#newAddressLine1").removeClass("border-danger");
    $("#newAddressLine2").removeClass("border-danger");
    $("#receiverCity").removeClass("border-danger");
    $("#receiverState").removeClass("border-danger");
    $("#receiverPin").removeClass("border-danger");
    
    document.getElementById("userAddressAddForm").reset();
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
                let categoryEachDiv = 
                `<div class = "d-flex justify-content-between align-items-center" id = "${categoryId}">
                    <div id = "categoryname-${categoryId}">${categoryName}</div>
                    <div>
                        <button type="button" 
                                onclick = "editCategory(${categoryId})" 
                                class = "btn btn-outline-info  px-3 my-2" 
                                data-bs-toggle="modal" 
                                data-bs-target="#staticBackdrop">
                        <img src="./assets/images/editing.png" alt="" width="18" height="18" class="">
                        </button>
                        <button class = "btn btn-outline-info  px-3 my-2" onClick = "deleteCategory(${categoryId})">
                        <img src="./assets/images/trash.png" alt="" width="18" height="18" class="">
                        </button>
                        <a class = "btn btn-outline-info  px-3 my-2" href ="subCategory.cfm?categoryId=${categoryId}&categoryName=${categoryName}">
                        <img src="./assets/images/right-arrow.png" alt="" width="18" height="18" class="">
                        </a>
                    </div>
                </div>`;
                $("#mainDiv").append(categoryEachDiv);
                // location.reload();
            }
        })
    }
   
}