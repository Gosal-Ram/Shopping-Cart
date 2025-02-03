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

