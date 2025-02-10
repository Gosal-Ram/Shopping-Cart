function changeMainImage(src) {
    const activeItem = document.querySelector(".carousel-item.active img");
    // let imageElement = document.getElementById("productThumbnailImg");
    if (activeItem) {
        activeItem.src = src;
        // imageElement.classList.add("border-primary");        
    }
}
function addToCartAndBuy(logInFlag, productId, buyNowFlag,encodedProductId){

    if(logInFlag){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{
                productId: productId,
                method : "addToCart"
            },
            success:function(response){
                let responseParsed = JSON.parse(response);
                if(responseParsed.resultMsg =="Product added to the Cart"){
                    // header cart icon update
                    let cartCountPrev = Number(document.getElementById("cartCount").innerHTML);
                    let cartCount = cartCountPrev +1;
                    document.getElementById("cartCount").innerHTML = cartCount;
                    location.href = "cart.cfm";
                }

                if(buyNowFlag){
                    let encodedCartId = responseParsed.cartId;
                    let quantityCount = responseParsed.quantity;
                    // location.href = `order.cfm?productId=${encodedProductId}&cartId=${encodedCartId}&quantityCount=${quantityCount}`;
                    location.href = `order.cfm?productId=${encodedProductId}&cartId=${encodedCartId}`;
                }
                
            }
        });
    } 
    else{
        // console.log(encodedProductId);
        if(buyNowFlag){
            location.href =`login.cfm?productId=${encodedProductId}&buyNow=1`;
        }else{
            location.href =`login.cfm?productId=${encodedProductId}`;
        }
    }
}

