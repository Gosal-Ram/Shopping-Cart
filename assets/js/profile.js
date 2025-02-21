function updateUserInfoModal(){
    document.getElementById("firstNameError").textContent = "";
    document.getElementById("lastNameError").textContent = "";
    document.getElementById("emailIdError").textContent = "";
    document.getElementById("phoneError").textContent = "";
    
    $("#userFirstName").removeClass("border-danger");
    $("#userLastName").removeClass("border-danger");
    $("#userEmail").removeClass("border-danger");
    $("#userPhone").removeClass("border-danger");
}

function deleteAddress(addressId){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{addressId: addressId,
                  method:"deleteAddress"
            },
            success:function(){
            document.getElementById(addressId).remove();
            location.reload();
            }
        })
    }
}

