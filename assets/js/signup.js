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
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$/;
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
    }
    else if(!nameRegex.test(firstNameValue)){
        setError(firstName, firstNameError, "Enter a valid first Name ");
    }
    else {
        resetError(firstName, firstNameError);
    }

    let lastNameValue = lastName.val().trim();
    if (lastNameValue === "") {
        setError(lastName, lastNameError, "Last name must be atleast 2 characters.");
    }
    else if(!nameRegex.test(lastNameValue)){
        setError(lastName, lastNameError, "Enter a valid last Name ");
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
    if (passwordRegex.test(pwd1Value) == 0) {
        pwd1Error.textContent = "Password must be at least 8 characters, include a letter, a number, and a special symbol.";
        pwd1.addClass("border-danger");
        isValid = false;
    } 
    else {
        pwd1Error.textContent = "";
        pwd1.removeClass("border-danger");
    }

    let pwd2Value = pwd2.val().trim();
    if (pwd2Value === "") {
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
