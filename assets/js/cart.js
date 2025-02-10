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

function increaseCount(cartId){
    let quantityElement = document.getElementById(`quantityCount_${cartId}`);
    let prevCount = parseInt(quantityElement.innerHTML); 
    let quantity = prevCount + 1 ;
    /*  
    to convert number with comma and replace with incremented number and send with previous format
    let productPrice = document.getElementById("productPrice").getAttribute("value");
    productPrice= Number(productPrice)*quantity;
    productPrice=Intl.NumberFormat('en-IN').format(productPrice)
    document.getElementById("productPrice").innerHTML = productPrice; */
    // .parseFloat(x).toFixed(2)
/* 
    let TotalproductPriceElement = document.getElementById("productPrice");
    productPrice = quantity
    console.log(productPrice);
    let productTaxElement = document.getElementById("productTax");
    console.log(productTax);
    let productActualPriceElement = document.getElementById("productActualPrice");
    console.log(productActualPrice);
    let totalCartActualPriceElement = document.getElementById("totalActualPrice");
    console.log(totalActualPrice);
    let totalCartTaxElement = document.getElementById("totalTax");
    console.log(totalTax);
    let totalCartPriceElement = document.getElementById("totalPrice");
    console.log(totalPrice); */


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
            // productActualPriceElement.innerHTML = quantity * productActualPriceElement.innerHTML;
            // productTaxElement.innerHTML = quantity * productTaxElement.innerHTML;
            // TotalproductPriceElement = productActualPriceElement.innerHTML +  productTaxElement.innerHTML;



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
                // quantityElement.innerHTML = quantity;
                location.reload();
            }
        })
    }

}


