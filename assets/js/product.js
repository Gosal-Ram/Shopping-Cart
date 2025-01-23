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
    const inputFields = [
        "#productName",
        "#productDescription",
        "#productPrice",
        "#productTax",
        "#imgFiles"
    ];

    inputFields.forEach(selector => {
        const inputElement = $(selector);
        inputElement.removeClass("border-danger");
    });
}

function modalValidate(){
    // alert("modalValidate");
    let isValid = true;
    
    let productName = $("#productName");
    if (productName.val().trim().length === 0) {
        document.getElementById("productNameError").textContent = "Enter product name.";
        productName.addClass("border-danger");
        isValid = false;
    } else {
        document.getElementById("productNameError").textContent = "";
    }

    let productDescription = $("#productDescription");
    if (productDescription.val().trim().length === 0) {
        document.getElementById("productDescriptionError").textContent = "Enter product description.";
        productDescription.addClass("border-danger");
        isValid = false;
    } else {
        document.getElementById("productDescriptionError").textContent = "";
    }

    let productPrice = $("#productPrice");
    if (productPrice.val().trim().length === 0 || parseFloat(productPrice.val()) <= 0) {
        document.getElementById("productPriceError").textContent = "Enter a valid product price.";
        productPrice.addClass("border-danger");
        isValid = false;
    } else {
        document.getElementById("productPriceError").textContent = "";
    }

    let productTax = $("#productTax");
    if (productTax.val().trim().length === 0 || parseFloat(productTax.val()) < 0) {
        document.getElementById("productTaxError").textContent = "Enter a valid product tax.";
        productTax.addClass("border-danger");
        isValid = false;
    } else {
        document.getElementById("productTaxError").textContent = "";
    }

    let categorySelect = document.getElementById("categorySelect").value;
    if (categorySelect === "") {
        alert("Select a category.");
        isValid = false;
    }

    let subCategorySelect = document.getElementById("selectedSubCategoryId").value;
    if (subCategorySelect === "") {
        alert("Select a sub-category.");
        isValid = false;
    }

    let brandSelect = document.getElementById("brandSelect").value;
    if (brandSelect === "") {
        alert("Select a brand.");
        isValid = false;
    }
    let productImages = $("#imgFiles");
    if (productImages[0].files.length === 0   &&   document.getElementById("modalSubmitBtn").value.length==0) {
        document.getElementById("productImagesError").textContent = "Upload at least one product image.";
        productImages.addClass("border-danger");
        isValid = false;
    } else {
        document.getElementById("productImagesError").textContent = "";
    }

    return isValid;

}

function openAddProductModal(){    
    clearErrorMessages();
    document.querySelector(".modal-title").textContent = "Add Product";
    document.getElementById("productAddForm").reset();
    document.getElementById("modalSubmitBtn").value = "";
    document.getElementById("categorySelect").onchange = function() {
		const categoryId = this.value;
        // console.log(categoryId);
        $.ajax({
            type: "POST",
            url: "component/shoppingcart.cfc",
            data: {
                method :"fetchSubCategories",
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
    let isModalValid = modalValidate()
    if(!isModalValid){
        return false;
    }
    let params = new URLSearchParams(document.location.search);
    // let subCategoryId =params.get("subCategoryId")
    // let categoryId =params.get("categoryId")
    // let productId = document.getElementById("modalSubmitBtn").value
    // console.log(productId)
    const formattedData = new FormData(document.getElementById("productAddForm"));
    if (document.getElementById("modalSubmitBtn").value.length==0){
        formattedData.append("method","addProduct");
        // add NEW PRODUCT
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data: formattedData,
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            success:function(response){
                let responseParsed = JSON.parse(response);
                // console.log(responseParsed.resultMsg);
                location.reload();
                document.getElementById("productFunctionResult").innerHTML = responseParsed.resultMsg;
            }
        })
    }
    else{   
        // edit EXISTING PRODUCT
        // const formattedData = new FormData(document.getElementById("productAddForm"));
        const productId =  document.getElementById("modalSubmitBtn").value;
        formattedData.append("productId",productId);
        formattedData.append("method","editProduct");
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:formattedData,
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            success:function(response){
                console.log(response)
                let responseParsed = JSON.parse(response);
                // console.log(responseParsed)
                /*                 if (subCategoryId != selectedSubCategoryId){
                    // for removing other subcategory products in page
                    document.getElementById(productId).remove()
                    } 
                    if(responseParsed != "Product Name already exists" && subCategoryId == selectedSubCategoryId){
                        //setting edited details asynchronously without page refresh 
                        document.getElementById("productname-"+productId).textContent = productName
                        //price, brand
                        } */
                document.getElementById("productFunctionResult").innerHTML = responseParsed;
                location.reload();
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
        url: "component/shoppingcart.cfc?",
        data:{productId:fldProduct_Id,
              method : "fetchProducts"
        },
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
        url: "component/shoppingcart.cfc",
        data: {
            productId: fldProduct_Id,
            method : "fetchProductImages"
        },
        success: function(response) {
            const responseParsed = JSON.parse(response);
            $("#carousalDiv").empty();
            // console.log(responseParsed);
            for (let i = 0; i < responseParsed.DATA.length; i++) {
                /* 
                responseParsed.DATA[i][3]   -- fldDefaultImg 
                responseParsed.DATA[i][0]   -- fldImageId 
                responseParsed.DATA[i][2]   -- fldImageFileName */
                let activeAttribute =""
                let imgDiv = "";
                if (responseParsed.DATA[i][3] === 1) {   //if thumbnail img
                    activeAttribute = "active";
                    imgDiv = `
                        <div class="text-center p-2">
                            Thumbnail Image
                        </div>`;
                } else { //all other img
                    activeAttribute = "";
                    imgDiv = `
                        <div class="d-flex justify-content-center pb-3 gap-5">
                            <button class="btn btn-outline-success" value="${responseParsed.DATA[i][0]}" onclick="setDefaultImage(${responseParsed.DATA[i][1]})">Set Thumbnail</button>
                            <button class="btn btn-outline-danger" value="${responseParsed.DATA[i][0]}" onclick="deleteImage()">Delete</button>
                        </div>`;
                }
            
                const carouselItem = `
                    <div class="carousel-item ${activeAttribute}">
                        ${imgDiv}
                        <img src="assets/images/productImages/${responseParsed.DATA[i][2]}" class="d-block w-100" alt="Product Image">
                    </div>`;
                $("#carousalDiv").append(carouselItem);
            }
        }
    });
}

function setDefaultImage(productId){
    const productImageId = event.target.value;
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{productId:productId,
            productImageId:productImageId,
            method : "editDefaultImg"
        },
        success:function(){
            location.reload();
        }
    })
}

function deleteImage(){
    const productImageId = event.target.value;
    $.ajax({
        type:"POST",
        url: "component/shoppingcart.cfc",
        data:{productImageId:productImageId,
              method: "deleteImg"},
        success:function(){
            location.reload();
        }
    })
}

function deleteProduct(fldProduct_Id){
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/shoppingcart.cfc",
            data:{productId: fldProduct_Id,
                method : "deleteProduct"
            },
            success:function(){
            document.getElementById(fldProduct_Id).remove();
            }
        })
    }
}
  