<main>
  <div class="container flex-column mx-auto my-5 px-5 pt-5 pb-3 w-50 justify-content-center bg-light shadow">
    <h3 class= "text-center">Sign Up</h3>
    <form class="d-flex flex-column my-5" method="POST" onsubmit="signupValidate()">
      <label for="firstName">First Name <span class="text-danger">*</span></label>
      <input type="text" name="firstName" id="firstName" class="form-control my-2 p-2" placeholder="Enter your first name" required>
      <span id="firstNameError" class="text-danger"></span>
    
      <label for="lastName">Last Name <span class="text-danger">*</span></label>
      <input type="text" name="lastName" id="lastName" class="form-control my-2 p-2" placeholder="Enter your last name" required>
      <span id="lastNameError" class="text-danger"></span>
    
      <label for="emailId">Email ID <span class="text-danger">*</span></label>
      <input type="email" name="emailId" id="emailId" class="form-control my-2 p-2" placeholder="Enter your email" required>
      <span id="emailIdError" class="text-danger"></span>
    
      <label for="phone">Phone <span class="text-danger">*</span></label>
      <input type="text" name="phone" id="phone" maxlength="10" class="form-control my-2 p-2" placeholder="Enter your phone number" required>
      <span id="phoneError" class="text-danger"></span>
    
      <label for="pwd1">Password <span class="text-danger">*</span></label>
      <input type="password" name="pwd1" id="pwd1" class="form-control my-2 p-2" placeholder="Enter your password" required>
      <span id="pwd1Error" class="text-danger"></span>
    
      <label for="pwd2">Confirm Password <span class="text-danger">*</span></label>
      <input type="password" name="pwd2" id="pwd2" class="form-control my-2 p-2" placeholder="Confirm your password" required>
      <span id="pwd2Error" class="text-danger"></span>
    
      <input type="submit" name="submitBtn" class="btn btn-primary rounded mt-4" value="Sign Up">
    </form>
    
    <cfif structKeyExists(form,"submitBtn")>   
      <cfset variables.signupResult = application.shoppingCart.signUp(
              firstName = form.firstName,
              lastName = form.lastName,
              emailId = form.emailId,
              pwd1 = form.pwd1,
              pwd2 = form.pwd2,
              phone = form.phone
          )>
      <cfoutput>
        <span>#variables.signupResult#</span>
      </cfoutput>
    </cfif>
  </div>  
</main>      
