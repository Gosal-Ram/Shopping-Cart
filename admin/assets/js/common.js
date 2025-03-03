function logOut(){
    if(confirm("Confirm logout")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{ method:"logOut"},
            success:function(){
              location.href= "home.cfm";
            }
        })
    }
} 

function saveNewAddress() {
    let isaddressModalValid = addressValidate();
    if(!isaddressModalValid){
        return false;  
    }
 
    let firstName = document.getElementById("receiverFirstName").value;
    let lastName = document.getElementById("receiverLastName").value;
    let phone = document.getElementById("receiverPhone").value;
    let addLine1 = document.getElementById("newAddressLine1").value;
    let addLine2 = document.getElementById("newAddressLine2").value;
    let city = document.getElementById("receiverCity").value;
    let state = document.getElementById("receiverState").value;
    let pincode = document.getElementById("receiverPin").value;

    console.log(pincode);
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{firstName: firstName,
            lastName: lastName,
            phone: phone,
            addLine1:addLine1,
            addLine2:addLine2,
            city: city,
            state: state,
            pincode: pincode,
            method : "addNewAddress"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);
            location.reload();
        }
    })
}

function openAddAddressModal(){
    document.getElementById("receiverFirstNameError").textContent = "";
    document.getElementById("receiverLastNameError").textContent = "";
    document.getElementById("receiverPhoneError").textContent = "";
    document.getElementById("addressLine1Error").textContent = "";
    document.getElementById("addressLine2Error").textContent = "";
    document.getElementById("cityError").textContent = "";
    document.getElementById("stateError").textContent = "";
    document.getElementById("pincodeError").textContent = "";
    
    $("#receiverFirstName").removeClass("border-danger");
    $("#receiverLastName").removeClass("border-danger");
    $("#receiverPhone").removeClass("border-danger");
    $("#newAddressLine1").removeClass("border-danger");
    $("#newAddressLine2").removeClass("border-danger");
    $("#receiverCity").removeClass("border-danger");
    $("#receiverState").removeClass("border-danger");
    $("#receiverPin").removeClass("border-danger");
    
    document.getElementById("userAddressAddForm").reset();
}
