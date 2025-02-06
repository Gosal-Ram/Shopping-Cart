<cfinclude template="header.cfm">
  <cfset variables.queryGetAddresses = application.shoppingCart.fetchAddresses()>

<cfoutput>
<main>
    <cfif structKeyExists(form,"userSubmitBtn")>   
        <cfset variables.editUserDetailsResult = application.shoppingCart.updateUserInfo(
            firstName = form.userFirstName,
            lastName = form.userLastName,
            emailId = form.userEmail,
            phone = form.userPhone)>
    </cfif>
    <div class="container my-3">
        <div class = "text-center">
            <img src = "assets/images/userprofile.jpg" alt="" height="75" width = "125" class="img-fluid">
        </div>
        <h2 class="mb-4 text-center">Hello #session.firstName# #session.lastName# !</h2>
        <div class="card p-4 shadow-sm">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <p class ="mb-1 text-muted">Name  : <span class="fw-semibold text-dark"> #session.firstName# #session.lastName#</span></p>
                    <p class="mb-1 text-muted">Email :<span class="fw-semibold text-dark"> #session.email#</span></p>
                </div>

                <button onClick = "updateUserInfoModal()" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="##editUserModal">
                    <i class="fa-solid fa-edit me-1"></i> Edit
                </button>
            </div>
            <cfif structKeyExists(variables, "editUserDetailsResult")>
                <cfif structKeyExists(variables.editUserDetailsResult, "resultMsg")>
                    <span class = "fw-semibold">#variables.editUserDetailsResult.resultMsg#</span>
                </cfif>
            </cfif>
        </div>
        <h4 class="mt-4">Saved Addresses</h4>
        <div class="card p-4 shadow-sm">
            <span class="text-success" id ="categoryFunctionResult"></span>        
            <cfloop array="#variables.queryGetAddresses#" item="local.item">
                <div class = "d-flex justify-content-between align-items-center" id = "#local.item.addressId#">
                    <div id ="address-#local.item.addressId#" class = "">
                        <p class = "mb-1 fw-6">Name: 
                            <span class="fw-semibold text-dark">#local.item.firstName# #local.item.lastName#</span>
                        </p>
                        <p class = "mb-0">Phone: 
                            <span class="fw-semibold text-dark">#local.item.phone#</span>
                        </p>
                        <p class = "mb-1 fw-6">Address: 
                            <span class="fw-semibold text-dark">
                                #local.item.addLine1#  ,
                                #local.item.addLine2# ,
                                #local.item.city# ,
                                #local.item.state# 
                            </span>
                        </p>
                        <p class = "mb-0">Pin: 
                            <span class="fw-semibold text-dark">#local.item.pincode#</span>
                        </p>
                    </div>
                    <button class = "btn btn-outline-danger px-3 my-2" onClick = "deleteAddress(#local.item.addressId#)">
                        Remove
                    </button>
                </div>
                <hr>
            </cfloop>
            <div>
                <button type="button" onClick = "openAddAddressModal()" class="btn btn-outline-success mt-3 fw-semibold" data-bs-toggle="modal" data-bs-target="##addAddressModal">
                    <i class="fa-solid fa-plus me-1"></i> Add Address
                </button>
                <a href="orderDetails.cfm" class="btn btn-outline-primary mt-3 ms-3 fw-semibold">
                    <i class='fas fa-shopping-bag'></i> My Orders
                </a>
            </div>
        </div>
    </div>
    <!--- Edit User Details Modal --->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id ="userUpdateForm" method="POST" onsubmit = "userProfileValidate()">
                        <div class="mb-3">
                            <label class="form-label">First Name</label>
                            <input type="text" class="form-control" id="userFirstName" name="userFirstName" value = "#session.firstName#">
                            <span id="firstNameError" class="text-danger"></span>

                        </div>
                        <div class="mb-3">
                            <label class="form-label">Last Name</label>
                            <input type="text" class="form-control" id="userLastName" name="userLastName" value = "#session.lastName#">
                            <span id="lastNameError" class="text-danger"></span>

                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="text" class="form-control" id="userEmail" name="userEmail" value = "#session.email#">
                            <span id="emailIdError" class="text-danger"></span>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="text" class="form-control" id="userPhone" name="userPhone" value = "#session.phone#">
                            <span id="phoneError" class="text-danger"></span>
                        </div>
                        <button type="submit" name = "userSubmitBtn" class="btn btn-primary w-100">Save Changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!--- Add Address Modal --->
    <div class="modal fade" id="addAddressModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Address</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id ="userAddressAddForm" method="POST">
                        <div class="mb-3">
                            <label class="form-label">First Name</label>
                            <input type="text" class="form-control" id="receiverFirstName" name="receiverFirstName">
                            <span id="receiverFirstNameError" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Last Name</label>
                            <input type="text" class="form-control" id="receiverLastName" name="receiverLastName">
                            <span id="receiverLastNameError" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="number" class="form-control" id="receiverPhone" maxlength="10" name="receiverPhone">
                            <span id="receiverPhoneError" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="text" class="form-control" id="receiverEmail" name="receiverEmail">
                            <span id="receiverEmailError" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Address Line 1</label>
                            <textarea class="form-control" id="newAddressLine1" rows="3"></textarea>
                            <span id="addressLine1Error" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Address Line 2</label>
                            <textarea class="form-control" id="newAddressLine2" rows="3"></textarea>
                            <span id="addressLine2Error" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">City</label>
                            <input type="text" class="form-control" id="receiverCity" name="receiverCity">
                            <span id="cityError" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">State</label>
                            <input type="text" class="form-control" id="receiverState" name="receiverState">
                            <span id="stateError" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Pincode</label>
                            <input type="number" maxlength="6" class="form-control" id="receiverPin" name="receiverPin">
                            <span id="pincodeError" class="text-danger"></span>
                        </div>

                        <button type="button" name = "userAddressSubmitBtn" onClick = "saveNewAddress()" class="btn btn-primary w-100">Save Changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>
</cfoutput>
<cfinclude  template="footer.cfm">

