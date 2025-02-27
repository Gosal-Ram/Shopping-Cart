function removeProduct(cartId) {
    alertify.confirm("Confirm remove cart item",
        function() { 
            $.ajax({
                type:"POST",
                url: "/component/user.cfc",
                data:{cartId: cartId,
                    method : "deleteCartItem"
                },
                success:function(){
                    document.getElementById(`cartId_${cartId}`).remove();
                    location.reload();
                },
                error: function() {
                    alertify.error('Failed to remove product');
                }
            })
        },
        function() { 
            alertify.error('remove canceled');
        }
    );
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
        url: "/component/user.cfc",
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
                    <a href="/home.cfm" class="btn btn-primary m-2">Go to Home</a>
                    <a href="/orderDetails.cfm" class="btn btn-success m-2">View Order Details</a>
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
    let increaseBtn = document.getElementById(`btnIncrease_${cartId}`);
    let decreaseBtn = document.getElementById(`btnDecrease_${cartId}`);

    increaseBtn.disabled = true;
    decreaseBtn.disabled = true;


    $.ajax({
        type:"POST",
        url: "/component/user.cfc",
        data:{cartId: cartId,
            quantity : newQuantity,
            method : "editCart"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);
            quantityElement.innerHTML = responseParsed.updatedQuantity;

            let updatedProductActualPrice = (productActualPriceElementValue / prevCount) * responseParsed.updatedQuantity;
            let updatedProductTax = (productTaxElementValue / prevCount) * responseParsed.updatedQuantity;
            let updatedTotalPrice = updatedProductActualPrice + updatedProductTax;

            productActualPriceElement.text(updatedProductActualPrice.toFixed(2));
            totalActualPriceElement.text(updatedProductActualPrice.toFixed(2));

            productTaxElement.text(updatedProductTax.toFixed(2));
            totalTaxElement.text(updatedProductTax.toFixed(2));

            productPriceElement.text(updatedTotalPrice.toFixed(2));
            totalPriceElement.text(updatedTotalPrice.toFixed(2));
        }
    }).always( function(){
        increaseBtn.disabled = false;
        decreaseBtn.disabled = false;
    });

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

        let increaseBtn = document.getElementById(`btnIncrease_${cartId}`);
        let decreaseBtn = document.getElementById(`btnDecrease_${cartId}`);
    
        increaseBtn.disabled = true;
        decreaseBtn.disabled = true;


        $.ajax({
            type:"POST",
            url: "/component/user.cfc",
            data:{cartId: cartId,
                quantity : newQuantity,
                method : "editCart"
            },
            success:function(response){
                let responseParsed = JSON.parse(response);
                quantityElement.innerHTML = responseParsed.updatedQuantity;

                let updatedProductActualPrice = (productActualPriceElementValue / prevCount) * responseParsed.updatedQuantity;
                let updatedProductTax = (productTaxElementValue / prevCount) * responseParsed.updatedQuantity;
                let updatedTotalPrice = updatedProductActualPrice + updatedProductTax;

                productActualPriceElement.text(updatedProductActualPrice.toFixed(2));
                totalActualPriceElement.text(updatedProductActualPrice.toFixed(2));
    
                productTaxElement.text(updatedProductTax.toFixed(2));
                totalTaxElement.text(updatedProductTax.toFixed(2));
    
                productPriceElement.text(updatedTotalPrice.toFixed(2));
                totalPriceElement.text(updatedTotalPrice.toFixed(2));
            }
        }).always( function(){
            increaseBtn.disabled = false;
            decreaseBtn.disabled = false;
        });
    }

}

