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

function removeProduct(cartId){
    if(confirm("Confirm remove cart item")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{cartId: cartId,
                method : "deleteCartItem"
            },
            success:function(){
                document.getElementById(cartId).remove();
                location.reload();
            }
        })
    }
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
        alert("Enter your card number");
    } else if (!cardRegex.test(cardNumberValue)) {
        setError(cardNumber, cardNumberError, "Card number must be exactly 16 digits");
        alert("Card number must be exactly 16 digits");
    } else {
        clearError(cardNumber, cardNumberError);
    }

    const cvvValue = cvv.val().trim();
    if (cvvValue === "") {
        setError(cvv, cvvError, "Enter your CVV");
        alert("Enter CVV");

    } else if (!cvvRegex.test(cvvValue)) {
        setError(cvv, cvvError, "CVV must be exactly 3 digits");
        alert("CVV must be exactly 3 digits");

    } else {
        clearError(cvv, cvvError);
    }

    return isValid;
}

function placeOrder(productId,productQuantity){ 
    let isValidCard = cardValidate();
    if(!isValidCard){
        return false;  
    }
    let cardNumber = document.getElementById("cardNumber").value;
    let cvv = document.getElementById("cvv").value;
    let selectedAddress = document.querySelector('input[name="selectedAddress"]:checked').value;
    let totalPrice = document.getElementById("totalPrice").innerHTML;
    let totalTax = document.getElementById("totalTax").innerHTML;
    // console.log(cardNumber);
    // console.log(cvv);
    // console.log(selectedAddress);
    // console.log(totalPrice);
    // console.log(totalTax);
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{cardNumber: cardNumber,
            cvv: cvv,
            selectedAddress:selectedAddress,
            totalPrice:totalPrice,
            totalTax:totalTax,
            productId:productId,
            productQuantity:productQuantity,
            method : "placeOrder"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);
            alert(responseParsed.resultMsg);
            location.href = "orderDetails.cfm";
            /* if(responseParsed.resultMsg =="Order placed SuccessFully"){
                // header cart icon update
                let cartCountPrev = Number(document.getElementById("cartCount").innerHTML);
                let cartCount = cartCountPrev +1;
                document.getElementById("cartCount").innerHTML = cartCount;
            } */
        //    location.reload();
        }
    })
}

function increaseCount(cartId){
    let quantityElement = document.getElementById(`quantityCount_${cartId}`);
    let prevCount = parseInt(quantityElement.innerHTML); 
    let quantity = prevCount + 1 ;
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{cartId: cartId,
            quantity : quantity,
            method : "editCart"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);
            console.log(responseParsed);
            quantityElement.innerHTML = quantity;
            location.reload();
            // $("#flush-collapseOne").removeClass("show");
            // $("#flush-collapseTwo").addClass("show");
        }
    })

}

function decreaseCount(cartId){
    let quantityElement = document.getElementById(`quantityCount_${cartId}`);
    let prevCount = parseInt(quantityElement.innerHTML); 
    if(prevCount > 1){
        let quantity = prevCount - 1;
        console.log(quantity);
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{cartId: cartId,
                quantity : quantity,
                method : "editCart"
            },
            success:function(response){
                let responseParsed = JSON.parse(response);
                console.log(responseParsed);
                quantityElement.innerHTML = quantity;
                location.reload();
            }
        })
    }

}

