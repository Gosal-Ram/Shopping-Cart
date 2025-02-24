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
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

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

    if (userNameValue === 0) {
        setError(userName, userNameError, "Enter phone number or email id");
    } else if (phoneRegex.test(userNameValue) === false && emailRegex.test(userNameValue) === false) {
        setError(userName, userNameError, "Enter a valid phone number or email id");
    } else {
        clearError(userName, userNameError);
    }

    const passwordValue = pwd.val().trim();

    if (passwordValue == 0) {
        setError(pwd, pwdError, "Enter your password");
    } else {
        clearError(pwd, pwdError);
    }
    
    return isValid;
}

function signupValidate() {
    let firstName = $("#firstName");
    let lastName = $("#lastName");
    let emailId = $("#emailId");
    let pwd1 = $("#pwd1");
    let pwd2 = $("#pwd2");
    let phone = $("#phone");

    let firstNameError = document.getElementById("firstNameError");
    let lastNameError = document.getElementById("lastNameError");
    let emailIdError = document.getElementById("emailIdError");
    let pwd1Error = document.getElementById("pwd1Error");
    let pwd2Error = document.getElementById("pwd2Error");
    let phoneError = document.getElementById("phoneError");

    const nameRegex = /^[A-Za-z]{2,}( [A-Za-z]{1,})?$/;
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^[0-9]{10}$/;
    const passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$/;

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
        setError(firstName, firstNameError, "First name is required");
    }
    else if(!nameRegex.test(firstNameValue)){
        setError(firstName, firstNameError, "Enter a valid first Name (must be atleast 2 characters).");
    }
    else {
        resetError(firstName, firstNameError);
    }

    let lastNameValue = lastName.val().trim();
    if (lastNameValue === "") {
        setError(lastName, lastNameError, "Last name is required");
    }
    else if(!nameRegex.test(lastNameValue)){
        setError(lastName, lastNameError, "Enter a valid last Name (must be atleast 2 characters).");
    }
    else {
        resetError(lastName, lastNameError);
    }

    let emailIdValue = emailId.val().trim();
    if (emailIdValue === "") {
        setError(emailId, emailIdError, "Email is required.");
    } 
    else if (!emailRegex.test(emailIdValue)) {
        setError(emailId, emailIdError, "Enter a valid email address.");
    } 
    else {
        resetError(emailId, emailIdError);
    }

    let pwd1Value = pwd1.val().trim();
    if (pwd1Value === "") {
        setError(pwd1, pwd1Error, "Password is required.");
    } 
    else if (passwordRegex.test(pwd1Value) == 0) {
        pwd1Error.textContent = 
        "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special symbol";
        pwd1.addClass("border-danger");
        isValid = false;
    } 
    else {
        pwd1Error.textContent = "";
        pwd1.removeClass("border-danger");
    }

    let pwd2Value = pwd2.val().trim();
    if (pwd2Value === ""&&pwd1Value != "") {
        setError(pwd2, pwd2Error, "Please confirm your password.");
    } 
    else if (pwd2Value !== pwd1Value) {
        setError(pwd2, pwd2Error, "Passwords do not match.");
    } 
    else {
        resetError(pwd2, pwd2Error);
    }

    let phoneValue = phone.val().trim();
    if (phoneValue === "") {
        setError(phone, phoneError, "Phone number is required.");
    } 
    else if (!phoneRegex.test(phoneValue)) {
        setError(phone, phoneError, "Enter a valid 10-digit phone number.");
    } 
    else {
        resetError(phone, phoneError);
    }

    if (!isValid) {
        event.preventDefault();

    }
}

function addressValidate(){
    let firstName = $("#receiverFirstName");
    let lastName = $("#receiverLastName");
    let phone = $("#receiverPhone");
    let addLine1 = $("#newAddressLine1");
    let addLine2 = $("#newAddressLine2");
    let city = $("#receiverCity");
    let state = $("#receiverState");
    let pincode = $("#receiverPin");

    let firstNameError = document.getElementById("receiverFirstNameError");
    let lastNameError = document.getElementById("receiverLastNameError");
    let phoneError = document.getElementById("receiverPhoneError");
    let addLine1Error = document.getElementById("addressLine1Error");
    let addLine2Error = document.getElementById("addressLine2Error");
    let cityError = document.getElementById("cityError");
    let stateError = document.getElementById("stateError");
    let pincodeError = document.getElementById("pincodeError");

    const nameCityStateRegex = /^[A-Za-z ]+$/;
    const phoneRegex = /^[0-9]{10}$/;
    const addressRegex = /^.+$/;
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
       
    let firstNameValue = firstName.val().trim();
    if (firstNameValue === "" || !nameCityStateRegex.test(firstNameValue)) {
        setError(firstName, firstNameError, "Enter a valid first name.");
    } else {
        resetError(firstName, firstNameError);
    }
    
    let lastNameValue = lastName.val().trim();
    if (lastNameValue === "" || !nameCityStateRegex.test(lastNameValue)) {
        setError(lastName, lastNameError, "Enter a valid last name.");
    } else {
        resetError(lastName, lastNameError);
    }
    
    let phoneValue = phone.val().trim();
    if (phoneValue === "" || !phoneRegex.test(phoneValue)) {
        setError(phone, phoneError, "Enter a valid 10-digit phone number.");
    } else {
        resetError(phone, phoneError);
    }
    
    let addLine1Value = addLine1.val().trim();
    if (addLine1Value === "" || !addressRegex.test(addLine1Value)) {
        setError(addLine1, addLine1Error, "Enter a valid address.");
    } else {
        resetError(addLine1, addLine1Error);
    }
    
    let addLine2Value = addLine2.val().trim();
    if (addLine2Value === "" || !addressRegex.test(addLine2Value)) {
        setError(addLine2, addLine2Error, "Enter a valid address.");
    } else {
        resetError(addLine2, addLine2Error);
    }

    let cityValue = city.val().trim();
    if (cityValue === "" || !nameCityStateRegex.test(cityValue)) {
        setError(city, cityError, "Enter a valid city name.");
    } else {
        resetError(city, cityError);
    }

    let stateValue = state.val().trim();
    if (stateValue === "" || !nameCityStateRegex.test(stateValue)) {
        setError(state, stateError, "Enter a valid state name.");
    } else {
        resetError(state, stateError);
    }

    let pincodeValue = pincode.val().trim();
    if (pincodeValue === "" || !pincodeRegex.test(pincodeValue)) {
        setError(pincode, pincodeError, "Enter a valid 6-digit pincode.");
    } else {
        resetError(pincode, pincodeError);
    }
    
    return isValid;
}

function cardValidate() {
    let cardNumber = $("#cardNumber");
    let cvv = $("#cvv");
    let cardNumberError = document.getElementById("cardNumberError");
    let cvvError = document.getElementById("cvvError");

    cardNumberError.textContent = "";
    cvvError.textContent = "";
    cardNumber.removeClass("border-danger");
    cvv.removeClass("border-danger");

    let isValid = true;
    const cardRegex = /^[0-9]{16}$/;
    const cvvRegex = /^[0-9]{3}$/;

    const setError = (element, errorElement, message) => {
        errorElement.textContent = message;
        element.addClass("border-danger");
        isValid = false;
    };

    const clearError = (element, errorElement) => {
        errorElement.textContent = "";
        element.removeClass("border-danger");
    };

    const cardNumberValue = cardNumber.val().trim();
    if (cardNumberValue === "") {
        setError(cardNumber, cardNumberError, "Enter your card number");
        // alert("Enter your card number");
        document.getElementById("flush-collapseThree").classList.add("show");
        document.getElementById("flush-collapseOne").classList.remove("show");
        document.getElementById("flush-collapseTwo").classList.remove("show");
    } else if (!cardRegex.test(cardNumberValue)) {
        setError(cardNumber, cardNumberError, "Card number must be exactly 16 digits");
        // alert("Card number must be exactly 16 digits");
        document.getElementById("flush-collapseThree").classList.add("show");
        document.getElementById("flush-collapseOne").classList.remove("show");
        document.getElementById("flush-collapseTwo").classList.remove("show");
    } else {
        clearError(cardNumber, cardNumberError);
    }

    const cvvValue = cvv.val().trim();
    if (cvvValue === "") {
        setError(cvv, cvvError, "Enter your CVV");
        // alert("Enter CVV");
        document.getElementById("flush-collapseThree").classList.add("show");
        document.getElementById("flush-collapseOne").classList.remove("show");
        document.getElementById("flush-collapseTwo").classList.remove("show");

    } else if (!cvvRegex.test(cvvValue)) {
        setError(cvv, cvvError, "CVV must be exactly 3 digits");
        // alert("CVV must be exactly 3 digits");
        document.getElementById("flush-collapseThree").classList.add("show");
        document.getElementById("flush-collapseOne").classList.remove("show");
        document.getElementById("flush-collapseTwo").classList.remove("show");

    } else {
        clearError(cvv, cvvError);
    }
    return isValid;
}

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

function saveProductValidate(){
    let isValid = true;
    
    let productName = $("#productName");
    const namePattern = /^[A-Za-z0-9 &-]+$/;
    if (productName.val().trim().length === 0) {
        document.getElementById("productNameError").textContent = "Enter product name.";
        productName.addClass("border-danger");
        isValid = false;
    }
    else if (!namePattern.test((productName.val().trim()))) {
        document.getElementById("productNameError").textContent = "Enter  a valid product name.";
        isValid = false;
    }  
    else {
        document.getElementById("productNameError").textContent = "";
    }

    let productDescription = $("#productDescription");
    if (productDescription.val().trim().length === 0) {
        document.getElementById("productDescriptionError").textContent = "Enter product description.";
        productDescription.addClass("border-danger");
        isValid = false;
    } 
    else if (!namePattern.test((productDescription.val().trim()))) {
        document.getElementById("productDescriptionError").textContent = "Enter valid product description.";
        isValid = false;
    } 
    else {
        document.getElementById("productDescriptionError").textContent = "";
    }

    let productPrice = $("#productPrice");
    if (productPrice.val().trim().length === 0 || parseFloat(productPrice.val()) <= 0) {
        document.getElementById("productPriceError").textContent = "Enter a valid product price.";
        productPrice.addClass("border-danger");
        isValid = false;
    } 
    else {
        document.getElementById("productPriceError").textContent = "";
    }

    let productTax = $("#productTax");
    if (productTax.val().trim().length === 0 || parseFloat(productTax.val()) < 0) {
        document.getElementById("productTaxError").textContent = "Enter a valid product tax.";
        productTax.addClass("border-danger");
        isValid = false;
    } 
    else if ( parseFloat(productTax.val()) > 100) {
        document.getElementById("productTaxError").textContent = "Product tax must below 100%";
        productTax.addClass("border-danger");
        isValid = false;
    }
    else {
        document.getElementById("productTaxError").textContent = "";
    }

    let categorySelect = document.getElementById("categorySelect").value;
    if (categorySelect === "") {
        alert("Select a category.");
        isValid = false;
    }

    let subCategorySelect = document.getElementById("selectedSubCategoryId").value;
    if (subCategorySelect === "") {
        alert("Select a sub-category.");
        isValid = false;
    }

    let brandSelect = document.getElementById("brandSelect").value;
    if (brandSelect === "") {
        alert("Select a brand.");
        isValid = false;
    }
    let productImages = $("#imgFiles");
    if (productImages[0].files.length === 0   &&   document.getElementById("modalSubmitBtn").value.length==0) {
        document.getElementById("productImagesError").textContent = "Upload at least one product image.";
        productImages.addClass("border-danger");
        isValid = false;
    } 
    else {
        document.getElementById("productImagesError").textContent = "";
    }

    return isValid;

}

function saveSubCategoryValidate(){
    let isValid = true;
    let subCategoryName = $("#subCategoryName");
    const namePattern = /^[A-Za-z0-9 ]+$/;

    if (subCategoryName.val().trim().length==0) {
        document.getElementById("subCategoryNameError").textContent = "Enter Sub Category Name";
        subCategoryName.addClass("border-danger");
        isValid = false;
    }
    else if (!namePattern.test((subCategoryName.val().trim()))) {
        document.getElementById("subCategoryNameError").textContent = "Enter a valid Sub Category Name";
        isValid = false;
    } 
    return isValid;
}

function saveCategoryValidate(){
    let isValid = true;
    const namePattern = /^[A-Za-z0-9]+$/;
    let categoryName = $("#categoryName");
    
    if (categoryName.val().trim().length===0) {
        document.getElementById("categoryNameError").textContent = "Enter Category Name";
        categoryName.addClass("border-danger");
        isValid = false;
    }
    else if (!namePattern.test((categoryName.val().trim()))) {
        document.getElementById("categoryNameError").textContent = "Enter a valid Category Name";
        isValid = false;
    } 
    return isValid;
}