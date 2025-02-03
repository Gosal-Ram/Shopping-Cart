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

function increaseCount(cartId,quantityCount){
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
            location.reload();
        }
    })

}

function decreaseCount(cartId,quantityCount){
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
                location.reload();
            }
        })
    }

}


