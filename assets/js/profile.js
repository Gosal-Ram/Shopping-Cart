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
    // console.log(emailIdValue);
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

function deleteAddress(addressId){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{addressId: addressId,
                  method:"deleteAddress"
            },
            success:function(){
            document.getElementById(addressId).remove();
            }
        })
    }
}

