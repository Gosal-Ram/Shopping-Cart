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
    
    $("#totalActualPrice").text(totalActualPrice);
    $("#totalTax").text(totalTax);
    $("#totalPrice").text(totalPrice);
}

function increaseCount(cartId){
    let quantityElement = document.getElementById(`quantityCount_${cartId}`);
    let prevCount = parseInt(quantityElement.innerHTML); 
    let newQuantity = prevCount + 1 ;

    let productActualPriceElement = $(`#cartId_${cartId} [name='productActualPrice']`);
    let productTaxElement = $(`#cartId_${cartId} [name='productTax']`);
    let productPriceElement = $(`#cartId_${cartId} [name='productPrice']`);

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

            productTaxElement.text(updatedProductTax);

            productPriceElement.text(updatedTotalPrice);
            updateCartTotals();
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
    
                productTaxElement.text(updatedProductTax);
    
                productPriceElement.text(updatedTotalPrice);     
                updateCartTotals();
            }
        })
    }

}




