<cfinclude  template="header.cfm">
<main>
  <div class="container flex-column mx-auto mt-5 px-5 pt-5 w-50 justify-content-center bg-light shadow-lg">
    <h3 class= "text-center">Sign Up</h3>
    <form class="d-flex flex-column my-5" method="POST" onsubmit = "signupValidate()">
      <input type="text" name="firstName" id="firstName" class="form-control my-3 p-2" placeholder="First Name">
      <span id="firstNameError" class="text-danger"></span>
      <input type="text" name="lastName" id="lastName" class="form-control my-3 p-2" placeholder="Last Name">
      <span id="lastNameError" class="text-danger"></span>
      <input type="mail" name="emailId" id="emailId" class="form-control my-3 p-2" placeholder="Email ID">
      <span id="emailIdError" class="text-danger"></span>
      <input type="text" name="phone" id="phone" class="form-control my-3 p-2" placeholder="Phone">
      <span class="text-danger " id="phoneError"></span>
      <input type="password" name="pwd1" id="pwd1" class="form-control my-3 p-2" placeholder="Password">
      <span id="pwd1Error" class="text-danger"></span>
      <input type="password" name="pwd2" id="pwd2" class="form-control my-3 p-2" placeholder="Confirm Password">
      <span id="pwd2Error" class="text-danger"></span>
      <input type="submit" name="submitBtn"  class="btn btn-primary rounded mt-4" value = "Sign Up">
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
<cfinclude  template="footer.cfm">
