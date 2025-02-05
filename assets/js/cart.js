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

   /*  let productPrice = document.getElementById("productPrice").getAttribute("value");
    productPrice= Number(productPrice)*quantity;
    productPrice=Intl.NumberFormat('en-IN').format(productPrice)
    document.getElementById("productPrice").innerHTML = productPrice; */


    // .parseFloat(x).toFixed(2)
    console.log(productPrice);


    let productTax = document.getElementById("productTax").innerHTML;
    console.log(productTax);
    let productActualPrice = document.getElementById("productActualPrice").innerHTML;
    console.log(productActualPrice);
    let totalActualPrice = document.getElementById("totalActualPrice").innerHTML;
    console.log(totalActualPrice);
    let totalTax = document.getElementById("totalTax").innerHTML;
    console.log(totalTax);
    let totalPrice = document.getElementById("totalPrice").innerHTML;
    console.log(totalPrice);


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


