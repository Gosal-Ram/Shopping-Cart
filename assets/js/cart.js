function removeProduct(cartId){
    if(confirm("Confirm delete cart item")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{cartId: cartId,
                method : "deleteCartItem"
            },
            success:function(){
            document.getElementById(cartId).remove();
            // location.reload();
            }
        })
    }
}

function increaseCount(cartId,quantityCount){
    // alert("inc");
    console.log(cartId,quantityCount);
    document.getElementById("quantityCount").innerHTML + 1 ;
    console.log(document.getElementById("quantityCount").innerHTML);

}

function decreaseCount(cartId,quantityCount){
    // alert("dec");
    console.log(cartId,quantityCount);
    let count = document.getElementById("quantityCount").innerHTML;
    if(count ==1){
        removeProduct(cartId);
    }
    console.log(document.getElementById("quantityCount").innerHTML);

}
