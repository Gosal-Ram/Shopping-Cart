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

function placeOrder(productId){ 
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
            method : "placeOrder"
        },
        success: function(response) {
            let responseParsed = JSON.parse(response);
        
            $(".orderContainer").hide();
            $("footer").remove();
            let resultHtml = `
                <div class="text-center mt-4">
                    <h4>${responseParsed.resultMsg}</h4>
                    <a href="home.cfm" class="btn btn-primary m-2">Go to Home</a>
                    <a href="orderDetails.cfm" class="btn btn-success m-2">View Order Details</a>
                </div>
            `;
        
            $("#resultContainer").html(resultHtml).show();
            if(responseParsed.resultMsg =="Order placed SuccessFully and cart updated"){
                // header cart icon update
                document.getElementById("cartCount").innerHTML = responseParsed.cartCount;
            } 
        }
    })
}

function increaseCount(cartId){
    let quantityElement = document.getElementById(`quantityCount_${cartId}`);
    let prevCount = parseInt(quantityElement.innerHTML); 
    let newQuantity = prevCount + 1 ;

    let productActualPriceElement = $(`#cartId_${cartId} [name='productActualPrice']`);
    let productTaxElement = $(`#cartId_${cartId} [name='productTax']`);
    let productPriceElement = $(`#cartId_${cartId} [name='productPrice']`);
    let totalActualPriceElement = $("#totalActualPrice");
    let totalTaxElement = $("#totalTax"); 
    let totalPriceElement = $("#totalPrice");

    let productActualPriceElementValue = Number(productActualPriceElement.text());
    let productTaxElementValue = Number(productTaxElement.text());


    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{cartId: cartId,
            quantity : newQuantity,
            method : "editCart"
        },
        success:function(response){
            quantityElement.innerHTML = newQuantity;

            let updatedProductActualPrice = (productActualPriceElementValue / prevCount) * newQuantity;
            let updatedProductTax = (productTaxElementValue / prevCount) * newQuantity;
            let updatedTotalPrice = updatedProductActualPrice + updatedProductTax;

            productActualPriceElement.text(updatedProductActualPrice);
            totalActualPriceElement.text(updatedProductActualPrice);

            productTaxElement.text(updatedProductTax);
            totalTaxElement.text(updatedProductTax);

            productPriceElement.text(updatedTotalPrice);
            totalPriceElement.text(updatedTotalPrice);
        }
    })

}

function decreaseCount(cartId){
    let quantityElement = document.getElementById(`quantityCount_${cartId}`);
    let prevCount = parseInt(quantityElement.innerHTML); 
    if(prevCount > 1){
        let newQuantity = prevCount - 1;
        let productActualPriceElement = $(`#cartId_${cartId} [name='productActualPrice']`);
        let productTaxElement = $(`#cartId_${cartId} [name='productTax']`);
        let productPriceElement = $(`#cartId_${cartId} [name='productPrice']`);
        let totalActualPriceElement = $("#totalActualPrice");
        let totalTaxElement = $("#totalTax"); 
        let totalPriceElement = $("#totalPrice");

        let productActualPriceElementValue = Number(productActualPriceElement.text());
        let productTaxElementValue = Number(productTaxElement.text());


        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{cartId: cartId,
                quantity : newQuantity,
                method : "editCart"
            },
            success:function(response){
                let responseParsed = JSON.parse(response);
                quantityElement.innerHTML = newQuantity;
                let updatedProductActualPrice = (productActualPriceElementValue / prevCount) * newQuantity;
                let updatedProductTax = (productTaxElementValue / prevCount) * newQuantity;
                let updatedTotalPrice = updatedProductActualPrice + updatedProductTax;

                productActualPriceElement.text(updatedProductActualPrice);
                totalActualPriceElement.text(updatedProductActualPrice);
    
                productTaxElement.text(updatedProductTax);
                totalTaxElement.text(updatedProductTax);
    
                productPriceElement.text(updatedTotalPrice);
                totalPriceElement.text(updatedTotalPrice);
            }
        })
    }

}

