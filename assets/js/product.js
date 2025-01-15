// Function to clear error messages
function clearErrorMessages(){
    const errorFields = [
        "productNameError",
        "productDescriptionError",
        "productPriceError",
        "productTaxError",
        "productImagesError"
    ];

    errorFields.forEach(fieldId => {
        const errorElement = document.getElementById(fieldId);
        if (errorElement) {
            errorElement.textContent = "";
        }
    });
}

function openAddProductModal(){    
    clearErrorMessages();
    document.querySelector(".modal-title").textContent = "Add Product";
    document.getElementById("productAddForm").reset();
    document.getElementById("modalSubmitBtn").value = "";
    document.getElementById("categorySelect").onchange = function() {
		const categoryId = this.value;
        console.log(categoryId)
        $.ajax({
            type: "POST",
            url: "component/shoppingcart.cfc?method=fetchSubCategories",
            data: {
                categoryId: categoryId
            },
            success: function(response) {
                const responseParsed = JSON.parse(response);
                // console.log(responseParsed)
                document.getElementById("selectedSubCategoryId").innerHTML = "";
                for(let i=0; i<responseParsed.DATA.length; i++) {
                    const subCategoryId = responseParsed.DATA[i][1];
                    const subCategoryName = responseParsed.DATA[i][0];
                    const optionElement = document.createElement("option");
                    optionElement.value = subCategoryId;
                    optionElement.textContent = subCategoryName;
                    document.getElementById("selectedSubCategoryId").appendChild(optionElement);
                }
            }
        });
	}
}

function saveProduct(){
    let params = new URLSearchParams(document.location.search);
    let subCategoryId =params.get("subCategoryId")
    let categoryId =params.get("categoryId")
    let productId = document.getElementById("modalSubmitBtn").value
    // console.log(productId)
    const formattedData = new FormData(document.getElementById("productAddForm"))
    if (document.getElementById("modalSubmitBtn").value.length==0){
        // add NEW PRODUCT
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=addProduct",
            data:formattedData ,
            // for uploading img
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            success:function(response){
                // alert(response)
                let responseParsed = JSON.parse(response);
                document.getElementById("productFunctionResult").innerHTML = responseParsed;
            }
        })
    }
    else{   
        // edit EXISTING PRODUCT
        const formattedData = new FormData(document.getElementById("productAddForm"))
        const productId =  document.getElementById("modalSubmitBtn").value
        formattedData.append("productId",productId)
        let productName= document.getElementById("productName").value
        let selectedSubCategoryId= document.getElementById("selectedSubCategoryId").value
        // console.log(productId)
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=editProduct",
            data:formattedData,
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            success:function(response){
                let responseParsed = JSON.parse(response);
                // console.log(responseParsed)
                if (subCategoryId != selectedSubCategoryId){
                    // for removing other subcategory products in page
                    document.getElementById(productId).remove()
                } 
               if(responseParsed != "Product Name already exists" && subCategoryId == selectedSubCategoryId){
                    //setting edited details asynchronously without page refresh 
                    document.getElementById("productname-"+productId).textContent = productName
                    // all other ui details 
                    //price, brand

                }
                document.getElementById("productFunctionResult").innerHTML = responseParsed;
            }
    })
    }
}

function editProductOpenModal(fldProduct_Id){
    clearErrorMessages();
    document.getElementById("productAddForm").reset();
    document.querySelector(".modal-title").textContent = "Edit Product";
    
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc?method=fetchProductInfo",
        data:{productId:fldProduct_Id},
        success:function(response){
            // alert(response)
            let responseParsed = JSON.parse(response);
            // autopopulate Product details
            document.getElementById("productName").value =responseParsed.DATA[0][0];
            document.getElementById("productDescription").value = responseParsed.DATA[0][3];
            document.getElementById("brandSelect").value = responseParsed.DATA[0][2];;
            document.getElementById("productPrice").value = responseParsed.DATA[0][4];
            document.getElementById("productTax").value = responseParsed.DATA[0][5];
        }
    })
    document.getElementById("modalSubmitBtn").value = fldProduct_Id;
}

function openImgCarousal(fldProduct_Id) {
    $.ajax({
        type: "POST",
        url: "component/shoppingcart.cfc?method=fetchProductImages",
        data: {
            productId: fldProduct_Id
        },
        success: function(response) {
            const responseParsed = JSON.parse(response);
            $("#carousalDiv").empty();
            console.log(responseParsed)
            for (let i = 0; i < responseParsed.DATA.length; i++) {
                let isActive =""
                if (i === 0) {
                     isActive = "active"
                }
                else {
                     isActive = ""
                }

                let imgDiv = "";
            
                if (responseParsed.DATA[i][3] === 1) {
                    imgDiv = `
                        <div class="text-center p-2">
                            Default Image
                        </div>
                    `;
                } else {
                    // bottom button
                    imgDiv = `
                        <div class="d-flex justify-content-center pt-3 gap-5">
                            <button class="btn btn-success" value="${responseParsed.DATA[i][0]}" onclick="setDefaultImage(${responseParsed.DATA[i][1]})">Set as Default</button>
                            <button class="btn btn-danger" value="${responseParsed.DATA[i][0]}" onclick="deleteImage()">Delete</button>
                        </div>
                    `;
                }
            
            
                const carouselItem = `
                    <div class="carousel-item ${isActive}">
                        <img src="assets/images/productImages/${responseParsed.DATA[i][2]}" class="d-block w-100" alt="Product Image">
                        ${imgDiv}
                    </div>
                `;
                $("#carousalDiv").append(carouselItem);
            }
            
        }
    });
}

function setDefaultImage(productId){

    const productImageId = event.target.value;

    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc?method=editDefaultImg",
        data:{productId:productId,
            productImageId:productImageId
        },
        success:function(){
        }
    })
}

function deleteImage(){
    const productImageId = event.target.value;

    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc?method=deleteImg",
        data:{productImageId:productImageId
        },
        success:function(){
        }
    })
}

function modalValidate(){
    let isValid = true;
    let subCategoryName = document.getElementById("subCategoryName").value;
    
    if (subCategoryName.trim().length==0) {
        document.getElementById("subCategoryNameError").textContent = "Enter Category Name";
        isValid = false;
    }
    return isValid;
}

function deleteProduct(fldProduct_Id){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=deleteProduct",
            data:{productId: fldProduct_Id},
            success:function(){
            document.getElementById(fldProduct_Id).remove()  
            }
        })
    }
}

function logOut(){
    if(confirm("Confirm logout")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc?method=logOut",
            success:function(){
              location.reload();
            }
        })
    }
} 























    