<cfinclude  template="header.cfm">
<main>
  <div class="container flex-column mx-auto mt-5 p-5 w-50 justify-content-center bg-light shadow-lg">
    <h3 class= "text-center">Login</h3>
    <form class="d-flex flex-column my-5" method="POST" onsubmit = " return loginValidate()">
      <input type="text" name="userInput" id="userInput" class="form-control my-3 p-2" placeholder="Email address or phone number ">
      <span class="text-danger " id="userInputError"></span>
      <input type="password" name="password" id="password" class="form-control my-3 p-2" placeholder="Password">
      <span class="text-danger " id="passwordError"></span>
      <input type="submit" name="submitBtn"  class="btn btn-primary rounded mt-4" value = "Log in">
    </form>
    <cfif structKeyExists(form,"submitBtn")>   
      <cfset variables.loginResult = application.shoppingCart.logIn(form.userInput,form.password)>
      <cfoutput>
          <span>#variables.loginResult#</span>
      </cfoutput>
    </cfif>
    <div class="text-center">
      Didn't have a account 
      <a href="/signup.cfm" class="text-decoration-none ">
        Register here
      </a>
    </div>
  </div>
</main>      
<cfinclude  template="footer.cfm">
      





