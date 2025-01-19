<cfif cgi.SCRIPT_NAME EQ "/login.cfm">
  <script src="assets/js/login.js"></script>
<cfelseif cgi.SCRIPT_NAME EQ "/signup.cfm"> 
  <script src="assets/js/signup.js"></script>
<cfelseif cgi.SCRIPT_NAME EQ "/category.cfm"> 
  <script src="assets/js/category.js"></script>
<cfelseif cgi.SCRIPT_NAME EQ "/subCategory.cfm"> 
  <script src="assets/js/subCategory.js"></script>
<cfelseif cgi.SCRIPT_NAME EQ "/product.cfm"> 
  <script src="assets/js/product.js"></script>
<cfelse>
</cfif> 
  <script src="assets/js/common.js"></script>
    </body>
</html>
<!---       <cfdump  var="#cgi#"> --->




