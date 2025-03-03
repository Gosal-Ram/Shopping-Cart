document.getElementById("categorySelect").onchange = function() {      //dyanamic change of subcategories on change of categories
    const categoryId = this.value;
    $.ajax({
        type: "POST",
        url: "/component/shoppingcart.cfc",
        data: {
            method :"fetchSubCategories",
            categoryId: categoryId
        },
        success: function(response) {
            const responseParsed = JSON.parse(response);
            document.getElementById("selectedSubCategoryId").innerHTML = "";
            for(let i=0; i<responseParsed.length; i++) {
                const subCategoryId = responseParsed[i].subCategoryId;
                const subCategoryName = responseParsed[i].subCategoryName;
                const optionElement = document.createElement("option");
                optionElement.value = subCategoryId;
                optionElement.textContent = subCategoryName;
                document.getElementById("selectedSubCategoryId").appendChild(optionElement);
            }
        }
    });
}

function clearErrorMessages(){    // Function to clear error messages and border
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

function openAddProductModal(){    
    clearErrorMessages();
    document.querySelector(".modal-title").textContent = "Add Product";
    document.getElementById("productAddForm").reset();
    document.getElementById("modalSubmitBtn").value = "";
}

function saveProduct(){
    let isModalValid = saveProductValidate()
    if(!isModalValid){
        return false;
    }
    let params = new URLSearchParams(document.location.search);
    const formattedData = new FormData(document.getElementById("productAddForm"));
    if (document.getElementById("modalSubmitBtn").value.length==0){    // add NEW PRODUCT
        formattedData.append("method","addProduct");                 
        $.ajax({
            type:"POST",
            url: "/component/admin.cfc",
            data: formattedData,
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            success:function(response){
                let responseParsed = JSON.parse(response);
                document.getElementById("productFunctionResult").innerHTML = responseParsed.resultMsg;
                location.reload();
            }
        })
    }
    else{   
        const productId =  document.getElementById("modalSubmitBtn").value;           // edit EXISTING PRODUCT
        formattedData.append("productId",productId);
        formattedData.append("method","editProduct");
        $.ajax({
            type:"POST",
            url: "/component/admin.cfc",
            data:formattedData,
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            success:function(response){
                let responseParsed = JSON.parse(response);
                document.getElementById("productFunctionResult").innerHTML = responseParsed;
                location.reload();
            }
    })
    }
}

function editProductOpenModal(productId){
    clearErrorMessages();
    document.getElementById("productAddForm").reset();
    document.querySelector(".modal-title").textContent = "Edit Product";    
    $.ajax({
        type:"POST",
        url: "/component/shoppingcart.cfc?",
        data:{productId: productId,
              method: "fetchProducts"
        },
        success:function(response){
            let responseParsed = JSON.parse(response);         // autopopulate Product details
            // console.log(responseParsed)
            document.getElementById("productName").value =responseParsed[0].productName;
            document.getElementById("productDescription").value = responseParsed[0].description;
            document.getElementById("brandSelect").value = responseParsed[0].brandId;
            document.getElementById("productPrice").value = responseParsed[0].price;
            document.getElementById("productTax").value = responseParsed[0].tax;
        }
    })
    document.getElementById("modalSubmitBtn").value = productId;
}

function openImgCarousal(productId) {
    $.ajax({
        type: "POST",
        url: "/component/admin.cfc",
        data: {
            productId: productId,
            method : "fetchProductImages"
        },
        success: function(response) {
            const responseParsed = JSON.parse(response);
            // console.log(responseParsed)
            $("#carousalDiv").empty();
            for (let i = 0; i < responseParsed.length; i++) {
                let activeAttribute = "";
                let imgDiv = "";
                if (responseParsed[i].thumbnailFlag == 1) {     //if thumbnail img
                    activeAttribute = "active";
                    imgDiv = `
                        <div class="text-center p-2">
                            Thumbnail Image
                        </div>`;
                } else {                                   //all other img
                    activeAttribute = "";
                    imgDiv = `
                        <div class="d-flex justify-content-center pb-3 gap-5">
                            <button class="btn btn-outline-success" value="${responseParsed[i].productImageId}" onclick="setDefaultImage(${responseParsed[i].productId})">Set Thumbnail</button>
                            <button class="btn btn-outline-danger" value="${responseParsed[i].productImageId}" onclick="deleteImage('${responseParsed[i].imageFileName}')">Delete</button>
                        </div>`;
                }
            
                const carouselItem = `
                    <div class="carousel-item ${activeAttribute}">
                        ${imgDiv}
                        <img src="/productImages/${responseParsed[i].imageFileName}" class="d-block w-100" alt="Product Image">
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
        url: "/component/admin.cfc",
        data:{productId:productId,
            productImageId:productImageId,
            method : "editDefaultImg"
        },
        success:function(){
            location.reload();
        }
    })
}

function deleteImage(fileName){
    const productImageId = event.target.value;
    console.log(fileName);
    $.ajax({
        type:"POST",
        url: "/component/admin.cfc",
        data:{productImageId:productImageId,
                fileName : fileName,
              method: "deleteImg"},
        success:function(response){
            console.log(response);
            // location.reload();
        }
    })
}

function deleteProduct(productId) {
    alertify.confirm("Confirm delete",
        function() { 
            $.ajax({
                type: "POST",
                url: "/component/admin.cfc",
                data:{productId: productId,
                    method : "deleteProduct"
                },
                success: function() {
                    document.getElementById(productId).remove();
                    alertify.success('Product deleted');
                },
                error: function() {
                    alertify.error('Failed to delete Product');
                }
            });
        },
        function() { 
            alertify.error('Delete canceled');
        }
    );
}