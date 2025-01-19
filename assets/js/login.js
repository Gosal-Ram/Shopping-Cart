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

