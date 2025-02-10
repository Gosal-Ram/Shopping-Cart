function logOut(){
    if(confirm("Confirm logout")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{ method:"logOut"},
            success:function(){
              location.href= "home.cfm";
            }
        })
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

    const nameCityStateRegex = /^[A-Za-z ]+$/;
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
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
    
    let emailIdValue = emailId.val().trim();
    if (emailIdValue === "" || !emailRegex.test(emailIdValue)) {
        setError(emailId, emailIdError, "Enter a valid email address.");
    } else {
        resetError(emailId, emailIdError);
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

function saveNewAddress() {
    let isaddressModalValid = addressValidate();
    if(!isaddressModalValid){
        return false;  
    }
 
    let firstName = document.getElementById("receiverFirstName").value;
    let lastName = document.getElementById("receiverLastName").value;
    let phone = document.getElementById("receiverPhone").value;
    let addLine1 = document.getElementById("newAddressLine1").value;
    let addLine2 = document.getElementById("newAddressLine2").value;
    let city = document.getElementById("receiverCity").value;
    let state = document.getElementById("receiverState").value;
    let pincode = document.getElementById("receiverPin").value;

    console.log(pincode);
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{firstName: firstName,
            lastName: lastName,
            phone: phone,
            addLine1:addLine1,
            addLine2:addLine2,
            city: city,
            state: state,
            pincode: pincode,
            method : "addNewAddress"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);
            // console.log(responseParsed);
            location.reload();
        }
    })
}


