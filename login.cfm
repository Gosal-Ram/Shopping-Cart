<cfinclude  template="header.cfm">
<main>
  <div class="container flex-column mx-auto my-5 p-5 w-50 justify-content-center bg-light shadow">
    <h3 class= "text-center">Login</h3>
    <form class="d-flex flex-column my-5" method="POST" onsubmit = " return loginValidate()">
      <input type="text" name="userInput" id="userInput" class="form-control my-3 p-2" placeholder="Email address or phone number ">
      <span class="text-danger " id="userInputError"></span>
      <input type="password" name="password" id="password" class="form-control my-3 p-2" placeholder="Password">
      <span class="text-danger " id="passwordError"></span>
      <input type="submit" name="submitBtn"  class="btn btn-primary rounded mt-4" value = "Log in">
    </form>
    <cfif structKeyExists(form,"submitBtn")>   
      <cfif structKeyExists(url, "productId")>
        <!--- not loggedin user on ordering a product (OR) adding a product to cart --->
        <cfif structKeyExists(url, "buyNow")>
          <!--- not loggedin user on ordering a product using Buy now --->
          <cfset variables.loginResult = application.shoppingCart.logIn(form.userInput,form.password,url.productId,url.buyNow)>
        <cfelse>
          <!--- not loggedin user addiing a product to cart --->
          <cfset variables.loginResult = application.shoppingCart.logIn(form.userInput,form.password,url.productId)>
        </cfif>
      <cfelse>
        <cfset variables.loginResult = application.shoppingCart.logIn(form.userInput,form.password)>
      </cfif>
      <cfoutput>
          <span>#variables.loginResult#</span>
      </cfoutput>
    </cfif>
    <div class="text-center">
      Didn't have a account ? 
      <a href="/signup.cfm" class="text-decoration-none ">
        Register here
      </a>
    </div>
  </div>
</main>      
<cfinclude  template="footer.cfm">