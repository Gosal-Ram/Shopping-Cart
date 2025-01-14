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

