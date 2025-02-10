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
                document.getElementById(`cartId_${cartId}`).remove();
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

function increaseCount(cartId,document){
    let quantityElement = document.getElementById(`quantityCount_${cartId}`);
    let prevCount = parseInt(quantityElement.innerHTML); 
    let quantity = prevCount + 1 ;
    let orderContainer = document.getElementById(`cartId_${cartId}`);
    console.log(orderContainer);
    // console.log(orderContainer.getElementsByName("productPrice"));
    // $("#cartId_234 [name='productPrice']").text()

    // let productPriceElement = orderContainer.getElementsByName("productPrice")[0].textContent;
    // console.log(productPriceElement);
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{cartId: cartId,
            quantity : quantity,
            method : "editCart"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);
            // console.log(responseParsed);
            quantityElement.innerHTML = quantity;
            location.reload();
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

