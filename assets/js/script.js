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
    if(userName.val() == ''){
        userNameError.textContent = "Enter a valid phone number or email id";
        userName.addClass("border-danger")
        isValid = false;
    }
    if(pwd.val() == ''){
        pwdError.textContent = "Enter your password";
        pwd.addClass("border-danger")
        isValid = false;
    }
    return isValid;
}

