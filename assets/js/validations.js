function loginValidate() {
    const userName = $("#userInput");
    const pwd = $("#password");
    const userNameError = document.getElementById("userInputError");
    const pwdError = document.getElementById("passwordError");
    const userNameValue = userName.val().trim();
    const isUserNameNotEmpty = validateNotEmpty(userName, userNameError, "Enter your phone or email");
    const isPasswordValid = validateNotEmpty(pwd, pwdError, "Enter your password");
    let isUserNameValid = false;
    if (isUserNameNotEmpty) {
        //assuming userInput is phone
        isUserNameValid = /^\d+$/.test(userNameValue) ? validatePhone(userName, userNameError) : validateEmail(userName, userNameError);
    }
    const isValid = isUserNameValid && isPasswordValid;
    if (!isValid) {
        event.preventDefault();
    }
    return isValid;
}

function signupValidate() {
    const firstName = $("#firstName");
    const lastName = $("#lastName");
    const emailId = $("#emailId");
    const pwd1 = $("#pwd1");
    const pwd2 = $("#pwd2");
    const phone = $("#phone");
    const firstNameError = document.getElementById("firstNameError");
    const lastNameError = document.getElementById("lastNameError");
    const emailIdError = document.getElementById("emailIdError");
    const pwd1Error = document.getElementById("pwd1Error");
    const pwd2Error = document.getElementById("pwd2Error");
    const phoneError = document.getElementById("phoneError");
    let isValid = true;

    if (!validateName(firstName, firstNameError)) isValid = false;
    if (!validateName(lastName, lastNameError)) isValid = false;
    if (!validateEmail(emailId, emailIdError, "Email is required")) isValid = false;
    if (!validatePhone(phone, phoneError, "Phone number is required")) isValid = false;
    if (!validatePassword(pwd1, pwd1Error, "Password is required")) isValid = false;
    if (!validateMatch(pwd1, pwd2, pwd2Error, "Passwords do not match")) isValid = false;
    if (!isValid) {
        event.preventDefault();
        return isValid;
    }
}

function addressValidate() {
    const firstName = $("#receiverFirstName");
    const lastName = $("#receiverLastName");
    const phone = $("#receiverPhone");
    const addLine1 = $("#newAddressLine1");
    const addLine2 = $("#newAddressLine2");
    const city = $("#receiverCity");
    const state = $("#receiverState");
    const pincode = $("#receiverPin");
    const firstNameError = document.getElementById("receiverFirstNameError");
    const lastNameError = document.getElementById("receiverLastNameError");
    const phoneError = document.getElementById("receiverPhoneError");
    const addLine1Error = document.getElementById("addressLine1Error");
    const addLine2Error = document.getElementById("addressLine2Error");
    const cityError = document.getElementById("cityError");
    const stateError = document.getElementById("stateError");
    const pincodeError = document.getElementById("pincodeError");

    let isValid = true;

    if (!validateName(firstName, firstNameError)) isValid = false;
    if (!validateName(lastName, lastNameError)) isValid = false;
    if (!validatePhone(phone, phoneError, "Enter a valid 10-digit phone number.")) isValid = false;
    if (!validateNotEmpty(addLine1, addLine1Error, "Enter a valid address.")) isValid = false;
    if (!validateNotEmpty(addLine2, addLine2Error, "Enter a valid address.")) isValid = false;
    if (!validateName(city, cityError)) isValid = false;
    if (!validateName(state, stateError)) isValid = false;
    if (!validatePincode(pincode, pincodeError)) isValid = false;

    return isValid;
}

function cardValidate() {
    const cardNumber = $("#cardNumber");
    const cvv = $("#cvv");

    const cardNumberError = document.getElementById("cardNumberError");
    const cvvError = document.getElementById("cvvError");

    let isValid = true;

    if (!validateCardNumber(cardNumber, cardNumberError)) isValid = false;
    if (!validateCVV(cvv, cvvError)) isValid = false;

    return isValid;
}

function userProfileValidate() {
    const firstName = $("#userFirstName");
    const lastName = $("#userLastName");
    const emailId = $("#userEmail");
    const phone = $("#userPhone");

    const firstNameError = document.getElementById("firstNameError");
    const lastNameError = document.getElementById("lastNameError");
    const emailIdError = document.getElementById("emailIdError");
    const phoneError = document.getElementById("phoneError");

    let isValid = true;

    if (!validateName(firstName, firstNameError)) isValid = false;
    if (!validateName(lastName, lastNameError)) isValid = false;
    if (!validateEmail(emailId, emailIdError)) isValid = false;
    if (!validatePhone(phone, phoneError, "Enter a valid 10-digit phone number.")) isValid = false;

    if (!isValid) {
        event.preventDefault();
    }
    return isValid;
}

function saveProductValidate(){
    const productName = $("#productName");
    const productDescription = $("#productDescription");
    const productPrice = $("#productPrice");
    const productTax = $("#productTax");
    const productTaxValue = productTax.val().trim();
    const productImages = $("#imgFiles");
    const categorySelect = document.getElementById("categorySelect").value;
    const subCategorySelect = document.getElementById("selectedSubCategoryId").value;
    const brandSelect = document.getElementById("brandSelect").value;

    const productNameError = document.getElementById("productNameError");
    const productDescriptionError = document.getElementById("productDescriptionError");
    const productPriceError = document.getElementById("productPriceError");
    const productTaxError = document.getElementById("productTaxError");
    const productImagesError = document.getElementById("productImagesError");

    let isValid = true;

    if (!validateNameWithDigits(productName, productNameError, "Enter a valid Product name")) isValid = false;
    if (!validateNameWithDigits(productDescription, productDescriptionError, "Enter a valid Product description")) isValid = false;

    if (productPrice.val().trim() == "" || parseFloat(productPrice.val()) <= 0) {
        setError(productPrice, productPriceError, "Enter a valid product price.");
        isValid = false;
    } else {
        clearError(productPrice, productPriceError);
    }

    if (productTaxValue == "" || productTaxValue < 0 || productTaxValue > 100) {
        setError(productTax, productTaxError, "Enter a valid product tax (0-100%).");
        isValid = false;
    } else {
        clearError(productTax, productTaxError);
    }

    if (categorySelect == "") {
        alertify.alert("Select a category.");
        isValid = false;
    }

    if (subCategorySelect == "") {
        alertify.alert("Select a sub-category.");
        isValid = false;
    }

    if (brandSelect == "") {
        alertify.alert("Select a brand.");
        isValid = false;
    }
    if (productImages[0].files.length == 0 && document.getElementById("modalSubmitBtn").value.length == 0) {
        // checking the value of element to check if it creating  new product or edit the existing product
        setError(productImages, productImagesError, "Upload at least one product image.");
        isValid = false;
    } else {
        clearError(productImages, productImagesError);
    }

    return isValid;
}

function saveSubCategoryValidate(){
    const subCategoryName = $("#subCategoryName");
    const subCategoryNameError = document.getElementById("subCategoryNameError");
    let isValid = true;
    if (!validateNameWithDigits(subCategoryName, subCategoryNameError, "Enter a valid sub category name")) isValid = false;
    return isValid;
}

function saveCategoryValidate(){
    const categoryName = $("#categoryName");
    const categoryNameError = document.getElementById("categoryNameError");
    let isValid = true;
    if (!validateNameWithDigits(categoryName, categoryNameError, "Enter a valid category name")) isValid = false;
    return isValid;
}

const setError = (element, errorElement, message) => {
    errorElement.textContent = message;
    element.addClass("border-danger");
    return false;
};

const clearError = (element, errorElement) => {
    errorElement.textContent = "";
    element.removeClass("border-danger");
    return true;
};

const regexPatterns = {
    phone: /^[0-9]{10}$/,
    email: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
    name: /^[A-Za-z]{2,}( [A-Za-z]{1,})?$/,
    nameWithDigits : /^[A-Za-z0-9 &-_]+$/,
    password: /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$/,
    card: /^[0-9]{16}$/,
    cvv: /^[0-9]{3}$/,
    pincode: /^[0-9]{6}$/
};

function validatePincode(element, errorElement) {
    if (element.val().trim() == "" || !regexPatterns.pincode.test(element.val().trim())) {
        return setError(element, errorElement, "Enter a valid 6-digit pincode.");
    } else {
        return clearError(element, errorElement);
    }
}

function validateName(element, errorElement) {
    if (element.val().trim() == "" || !regexPatterns.name.test(element.val().trim())) {
        return setError(element, errorElement, "Enter a valid name (at least 2 characters).");
    } else {
        return clearError(element, errorElement);
    }
}

function validateNameWithDigits(element, errorElement, message) {
    if (element.val().trim() == "" || !regexPatterns.nameWithDigits.test(element.val().trim())) {
        return setError(element, errorElement, message);
    } else {
        return clearError(element, errorElement);
    }
}

function validateEmail(element, errorElement, message = "Enter a valid email address.") {
    if (element.val().trim() == "" || !regexPatterns.email.test(element.val().trim())) {
        return setError(element, errorElement, message);
    } else {
        return clearError(element, errorElement);
    }
}

function validatePhone(element, errorElement,  message = "Enter a valid 10-digit phone number") {
    if (element.val().trim() == "" || !regexPatterns.phone.test(element.val().trim())) {
        return setError(element, errorElement, message);
    } else {
        return clearError(element, errorElement);
    }
}

function validatePassword(element, errorElement) {
    if (element.val().trim() == "" || !regexPatterns.password.test(element.val().trim())) {
        return setError(element, errorElement, "Password must be at least 8 characters, include upper/lowercase letters, a number, and a special symbol.");
    } else {
        return clearError(element, errorElement);
    }
}

function validateCardNumber(element, errorElement) {
    if (element.val().trim() == "" || !regexPatterns.card.test(element.val().trim())) {
        return setError(element, errorElement, "Card number must be exactly 16 digits.");
    } else {
        return clearError(element, errorElement);
    }
}

function validateCVV(element, errorElement) {
    if (element.val().trim() == "" || !regexPatterns.cvv.test(element.val().trim())) {
        return setError(element, errorElement, "CVV must be exactly 3 digits.");
    } else {
        return clearError(element, errorElement);
    }
}

function validateNotEmpty(element, errorElement, message) {
    if (element.val().trim() == "") {
        return setError(element, errorElement, message);
    } else {
        return clearError(element, errorElement);
    }
}

function validateMatch(element1, element2, errorElement, message) {
    if (element1.val().trim() == element2.val().trim()) {
        return clearError(element2, errorElement);
    } else {
        return setError(element2, errorElement, message);
    }
}
