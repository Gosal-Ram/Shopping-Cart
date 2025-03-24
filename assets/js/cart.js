function increaseCount(cartId){
    let quantityElement = document.getElementById(`quantityCount_${cartId}`);
    let prevCount = parseInt(quantityElement.innerHTML); 
    let newQuantity = prevCount + 1 ;

    let increaseBtn = document.getElementById(`btnIncrease_${cartId}`);
    let decreaseBtn = document.getElementById(`btnDecrease_${cartId}`);

    increaseBtn.disabled = true;
    decreaseBtn.disabled = true;

    let productActualPriceElement = $(`#cartId_${cartId} [name='productActualPrice']`);
    let productTaxElement = $(`#cartId_${cartId} [name='productTax']`);
    let productPriceElement = $(`#cartId_${cartId} [name='productPrice']`);

    let productActualPriceElementValue = Number(productActualPriceElement.text());
    let productTaxElementValue = Number(productTaxElement.text());
    
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

            productTaxElement.text(updatedProductTax.toFixed(2));

            productPriceElement.text(updatedTotalPrice.toFixed(2));
            updateCartTotals();
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
    
                productTaxElement.text(updatedProductTax.toFixed(2));
    
                productPriceElement.text(updatedTotalPrice.toFixed(2));     
                updateCartTotals();
            }
        }).always( function(){
            increaseBtn.disabled = false;
            decreaseBtn.disabled = false;
        });
    }

}

function removeProduct(cartId) {
    alertify.confirm("Confirm remove item",
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

function updateCartTotals() {
    let totalActualPrice = 0;
    let totalTax = 0;
    let totalPrice = 0;

    $(".cartItem").each(function () {
        let productActualPrice = Number($(this).find("[name='productActualPrice']").text());
        let productTax = Number($(this).find("[name='productTax']").text());

        totalActualPrice += productActualPrice;
        totalTax += productTax;
        totalPrice += productActualPrice + productTax;
    });
    
    $("#totalActualPrice").text(totalActualPrice.toFixed(2));
    $("#totalTax").text(totalTax.toFixed(2));
    $("#totalPrice").text(totalPrice.toFixed(2));
}
