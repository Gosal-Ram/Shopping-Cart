function changeMainImage(src) {
    const activeItem = document.querySelector(".carousel-item.active img");
    if (activeItem) {
        activeItem.src = src;
    }
}
function addToCart(logInFlag, productId){
    const isLoggedIn = logInFlag;

    if(isLoggedIn){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{
                productId: productId,
                method : "addToCart"
            },
            success:function(response){
                let responseParsed = JSON.parse(response);
                console.log(responseParsed);
                location.reload();
            }
        });
    } 
    else{
        location.href="login.cfm?productId="+productId ;
    }
}