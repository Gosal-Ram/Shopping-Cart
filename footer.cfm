      <cfset local.adminWebPages = ["/category.cfm","/subCategory.cfm","/product.cfm","/login.cfm","/signup.cfm"]>
      <cfif arrayContains(local.adminWebPages, cgi.SCRIPT_NAME)>
        <footer class = "text-dark bg-white p-3 text-center w-100 position-sticky">
            &copy; 2025 Admin Panel | All Rights Reserved
        </footer>
      <cfelse>
        <footer> 
          <div class="f-top d-flex">
            <div class="f-top-left d-flex pe-5">
              <ul>
                  <div class="f-heading">ABOUT</div>
                  <li><a href="">Contact Us</a></li>
                  <li><a href="">About Us</a></li>
                  <li><a href="">Careers</a></li>
                  <li><a href="">Stories</a></li>
                  <li><a href="">Press</a></li>
                  <li><a href="">Corporate Information</a></li>
              </ul>
              <ul>
                  <div class="f-heading">GROUP COMPANIES</div>
                  <li><a href="">Myntra</a></li>
                  <li><a href="">Cleartrip</a></li>
                  <li><a href="">Shopsy</a></li>
              </ul>
              <ul>
                  <div class="f-heading">HELP</div>
                  <li><a href="">Payments</a></li>
                  <li><a href="">Shipping</a></li>
                  <li><a href="">Cancellation & Returns</a></li>
                  <li><a href="">FAQ</a></li>
                  <li><a href="">Report Infringement</a></li>
              </ul>
              <ul>
                  <div class="f-heading">CONSUMER POLICY</div>
                  <li><a href="">Cancellation & Returns</a></li>
                  <li><a href="">Terms of Use</a></li>
                  <li><a href="">Security</a></li>
                  <li><a href="">Privacy</a></li>
                  <li><a href="">Sitemap</a></li>
                  <li><a href="">Grievance Redressal</a></li>
                  <li><a href="">EPR Compliance</a></li>
              </ul>
            </div>
            <div class="f-top-right d-flex">
              <ul>
                  <div class="f-heading">Mail Us:</div>
                  <li>ABC Internet Private Limited,<br/>
                Buildings Alyssa, Begonia &<br/>
                Clove Embassy Tech Village,<br/>
                Outer Ring Road, Devarabeesanahalli Village,<br/>
                Bengaluru, 560103,<br/>Karnataka, India
                  </li>
                  <li class="mt-3">
                    <div class="f-heading">Social</div>
                    <div class="socialMediaIcons">
                <img src="assets/images/social-icons.png" alt="social-icon" width="120">
              </div>
                  </li>
              </ul>
              <ul>
                  <div class="f-heading">Registered Office Address:</div>
                  <li>ABC Internet Private Limited,<br/>
                Buildings Alyssa, Begonia &<br/>
                Clove Embassy Tech Village,<br/>
                Outer Ring Road, Devarabeesanahalli Village,<br/>
                Bengaluru, 560103,<br/>Karnataka, India<br/>
                CIN : U51109KA2012PTC066107<br/>
                Telephone: <span class="text-primary">044-45614700</span> / <span class="text-primary">044-67415800</span>
                  </li>
              </ul>
            </div>
          </div>
          <div class="f-bottom"d-flex justify-content-center>
            <div class="f-bottom-quick-links d-flex justify-content-around align-items-center">
              <div class="quickLink1 px-4">
                  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNSIgdmlld0JveD0iMCAwIDE2IDE1Ij4KICAgIDxkZWZzPgogICAgICAgIDxsaW5lYXJHcmFkaWVudCBpZD0iYSIgeDE9IjAlIiB4Mj0iODYuODc2JSIgeTE9IjAlIiB5Mj0iODAuMjAyJSI+CiAgICAgICAgICAgIDxzdG9wIG9mZnNldD0iMCUiIHN0b3AtY29sb3I9IiNGRkQ4MDAiLz4KICAgICAgICAgICAgPHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjRkZBRjAwIi8+CiAgICAgICAgPC9saW5lYXJHcmFkaWVudD4KICAgIDwvZGVmcz4KICAgIDxnIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCI+CiAgICAgICAgPHBhdGggZD0iTS0yLTJoMjB2MjBILTJ6Ii8+CiAgICAgICAgPHBhdGggZmlsbD0idXJsKCNhKSIgZmlsbC1ydWxlPSJub256ZXJvIiBkPSJNMTUuOTMgNS42MTRoLTIuOTQ4VjQuMTRjMC0uODE4LS42NTUtMS40NzMtMS40NzMtMS40NzNIOC41NmMtLjgxNyAwLTEuNDczLjY1NS0xLjQ3MyAxLjQ3M3YxLjQ3NEg0LjE0Yy0uODE4IDAtMS40NjYuNjU2LTEuNDY2IDEuNDc0bC0uMDA3IDguMTA1YzAgLjgxOC42NTUgMS40NzQgMS40NzMgMS40NzRoMTEuNzljLjgxOCAwIDEuNDc0LS42NTYgMS40NzQtMS40NzRWNy4wODhjMC0uODE4LS42NTYtMS40NzQtMS40NzQtMS40NzR6bS00LjQyMSAwSDguNTZWNC4xNGgyLjk0OHYxLjQ3NHoiIHRyYW5zZm9ybT0idHJhb		nNsYXRlKC0yIC0yKSIvPgogICAgPC9nPgo8L3N2Zz4K" alt="">
                  <a href="" class="text-decoration-none text-white ms-1"><span class="">Become a Seller</span></a>
              </div>
              <div class="quickLink2 px-4">
                  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNSIgaGVpZ2h0PSIxNSIgdmlld0JveD0iMCAwIDE1IDE1Ij4KICAgIDxkZWZzPgogICAgICAgIDxsaW5lYXJHcmFkaWVudCBpZD0iYSIgeDE9IjAlIiB4Mj0iODYuODc2JSIgeTE9IjAlIiB5Mj0iODAuMjAyJSI+CiAgICAgICAgICAgIDxzdG9wIG9mZnNldD0iMCUiIHN0b3AtY29sb3I9IiNGRkQ4MDAiLz4KICAgICAgICAgICAgPHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjRkZBRjAwIi8+CiAgICAgICAgPC9saW5lYXJHcmFkaWVudD4KICAgIDwvZGVmcz4KICAgIDxnIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCI+CiAgICAgICAgPHBhdGggZD0iTS0zLTNoMjB2MjBILTN6Ii8+CiAgICAgICAgPHBhdGggZmlsbD0idXJsKCNhKSIgZmlsbC1ydWxlPSJub256ZXJvIiBkPSJNMTAuNDkyIDNDNi4zNTMgMyAzIDYuMzYgMyAxMC41YzAgNC4xNCAzLjM1MyA3LjUgNy40OTIgNy41QzE0LjY0IDE4IDE4IDE0LjY0IDE4IDEwLjUgMTggNi4zNiAxNC42NCAzIDEwLjQ5MiAzem0zLjE4IDEyTDEwLjUgMTMuMDg4IDcuMzI3IDE1bC44NC0zLjYwN0w1LjM3IDguOTdsMy42OS0uMzE1TDEwLjUgNS4yNWwxLjQ0IDMuMzk4IDMuNjkuMzE1LTIuNzk4IDIuNDIyLjg0IDMuNjE1eiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTMgLTMpIi8+CiAgICA8L2c+Cjwvc3ZnPgo=" alt="">
                  <a href="" class="text-decoration-none text-white ms-1"><span class="">Advertise</span></a>
              </div>
              <div class="quickLink3 px-4">
                  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxOCIgaGVpZ2h0PSIxNyIgdmlld0JveD0iMCAwIDE4IDE3Ij4KICAgIDxkZWZzPgogICAgICAgIDxsaW5lYXJHcmFkaWVudCBpZD0iYSIgeDE9IjAlIiB4Mj0iODYuODc2JSIgeTE9IjAlIiB5Mj0iODAuMjAyJSI+CiAgICAgICAgICAgIDxzdG9wIG9mZnNldD0iMCUiIHN0b3AtY29sb3I9IiNGRkQ4MDAiLz4KICAgICAgICAgICAgPHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjRkZBRjAwIi8+CiAgICAgICAgPC9saW5lYXJHcmFkaWVudD4KICAgIDwvZGVmcz4KICAgIDxnIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCI+CiAgICAgICAgPHBhdGggZD0iTS0xLTFoMjB2MjBILTF6Ii8+CiAgICAgICAgPHBhdGggZmlsbD0idXJsKCNhKSIgZmlsbC1ydWxlPSJub256ZXJvIiBkPSJNMTYuNjY3IDVIMTQuODVjLjA5Mi0uMjU4LjE1LS41NDIuMTUtLjgzM2EyLjQ5NyAyLjQ5NyAwIDAgMC00LjU4My0xLjM3NUwxMCAzLjM1bC0uNDE3LS41NjdBMi41MSAyLjUxIDAgMCAwIDcuNSAxLjY2N2EyLjQ5NyAyLjQ5NyAwIDAgMC0yLjUgMi41YzAgLjI5MS4wNTguNTc1LjE1LjgzM0gzLjMzM2MtLjkyNSAwLTEuNjU4Ljc0Mi0xLjY1OCAxLjY2N2wtLjAwOCA5LjE2NkExLjY2IDEuNjYgMCAwIDAgMy4zMzMgMTcuNWgxMy4zMzRhMS42NiAxLjY2IDAgMCAwIDEuNjY2LTEuNjY3VjYuNjY3QTEuNjYgMS42NiAwI		DAgMCAxNi42NjcgNXptMCA2LjY2N0gzLjMzM3YtNWg0LjIzNEw1LjgzMyA5LjAyNWwxLjM1Ljk3NSAxLjk4NC0yLjdMMTAgNi4xNjdsLjgzMyAxLjEzMyAxLjk4NCAyLjcgMS4zNS0uOTc1LTEuNzM0LTIuMzU4aDQuMjM0djV6IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMSAtMSkiLz4KICAgIDwvZz4KPC9zdmc+Cg==" alt="">
                  <a href="" class="text-decoration-none text-white ms-1"><span class="">Gift-cards</span></a>
              </div>
              <div class="quickLink4 px-4">
                  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNSIgaGVpZ2h0PSIxNSIgdmlld0JveD0iMCAwIDE1IDE1Ij4KICAgIDxkZWZzPgogICAgICAgIDxsaW5lYXJHcmFkaWVudCBpZD0iYSIgeDE9IjAlIiB4Mj0iODYuODc2JSIgeTE9IjAlIiB5Mj0iODAuMjAyJSI+CiAgICAgICAgICAgIDxzdG9wIG9mZnNldD0iMCUiIHN0b3AtY29sb3I9IiNGRkQ4MDAiLz4KICAgICAgICAgICAgPHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjRkZBRjAwIi8+CiAgICAgICAgPC9saW5lYXJHcmFkaWVudD4KICAgIDwvZGVmcz4KICAgIDxnIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCI+CiAgICAgICAgPHBhdGggZD0iTS0yLTNoMjB2MjBILTJ6Ii8+CiAgICAgICAgPHBhdGggZmlsbD0idXJsKCNhKSIgZmlsbC1ydWxlPSJub256ZXJvIiBkPSJNOS41IDNDNS4zNiAzIDIgNi4zNiAyIDEwLjUgMiAxNC42NCA1LjM2IDE4IDkuNSAxOGM0LjE0IDAgNy41LTMuMzYgNy41LTcuNUMxNyA2LjM2IDEzLjY0IDMgOS41IDN6bS43NSAxMi43NWgtMS41di0xLjVoMS41djEuNXptMS41NTMtNS44MTNsLS42NzYuNjljLS41NC41NDgtLjg3Ny45OTgtLjg3NyAyLjEyM2gtMS41di0uMzc1YzAtLjgyNS4zMzgtMS41NzUuODc3LTIuMTIzbC45My0uOTQ1Yy4yNzgtLjI3LjQ0My0uNjQ1LjQ0My0xLjA1NyAwLS44MjUtLjY3NS0xLjUtMS41LTEuNVM4IDcuNDI1IDggOC4yNUg2L		jVhMyAzIDAgMSAxIDYgMGMwIC42Ni0uMjcgMS4yNi0uNjk3IDEuNjg4eiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTIgLTMpIi8+CiAgICA8L2c+Cjwvc3ZnPgo=" alt="">
                  <a href="" class="text-decoration-none text-white ms-1"><span class="">Help Center</span></a>
              </div>
              <div class="quickLink5 px-4">
                  <a href="" class="text-decoration-none text-white ms-1"><span class="">2007-2024 ShoppingCart.com</span></a>
              </div>
              <div class="quickLink5 px-4">
                  <img src="assets/images/payment-methods.svg" alt="cards">
              </div>
            </div>
          </div>
        </footer>
      </cfif>
      <cfswitch expression="#cgi.SCRIPT_NAME#">
        <cfcase value="/login.cfm">
          <script src="assets/js/login.js"></script>
        </cfcase>

        <cfcase value="/cart.cfm">
          <script src="assets/js/cart.js"></script>
        </cfcase>

        <cfcase value="/signup.cfm">
          <script src="assets/js/signup.js"></script>
        </cfcase>

        <cfcase value="/category.cfm">
          <script src="assets/js/category.js"></script>
        </cfcase>

        <cfcase value="/subCategory.cfm">
          <script src="assets/js/subCategory.js"></script>
        </cfcase>

        <cfcase value="/product.cfm">
          <script src="assets/js/product.js"></script>
        </cfcase>

        <cfcase value="/userProduct.cfm">
          <script src="assets/js/userProduct.js"></script>
        </cfcase>

        <cfcase value="/userSubCategory.cfm">
          <script src="assets/js/userSubCategory.js"></script>
        </cfcase>
        
        <cfcase value="/home.cfm">
          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </cfcase>
      </cfswitch>
 
      <script src="assets/js/common.js"></script>
    </body>
</html>

