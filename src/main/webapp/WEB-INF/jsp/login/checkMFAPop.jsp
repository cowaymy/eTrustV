<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/js.cookie.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/pgwbrowser.min.js"></script>
<script  type = "text/javascript">


$(document).ready(function()
		{

    $("#code").unbind().bind("change keyup", function(e) {
        $(this).val($(this).val().replace(/[\D]/g,"").trim());
    });

    // time out to scan QR in 30Seconds
    setTimeout(function() {
        $("#checkMFAPop").remove();
      }, 30000);

    // on enter button send
    $("#code").keypress(function (event) {
        if (event.keyCode == 13) {
        	fn_submitMFA();
        }
    });

		});

function mfaPopUpClose()
{
     $("#checkMFAPop").remove();
}
</script>

<style>
.container {
    height: 600px;
    width: 600px;
}

 .container img {
    object-fit: cover;
    object-position: top;
    margin: 10px;
    display: block;
    height: 100%;
    width: 100%;
}
</style>

<body>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start size_big size_all size_small -->

<header class="pop_header"><!-- pop_header start -->
<h1>MFA OTP Authentication</h1>
<ul class="right_opt">
  <li><p class="btn_blue2"><a onclick="mfaPopUpClose();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<div style="text-align:center; margin:0 auto;"><!-- login_wrap start -->
    <article class="login_box"><!-- login_box start -->
        <form id="otpMfaForm" name="otpMfaForm" method="post">
          <h2><img src="${pageContext.request.contextPath}/resources/images/common/logo_etrust.gif" alt="Coway"/></h2></br>
         <input type="hidden" id="encodedKey" name="encodedKey" value = "${encodedKey}"/>
         <input type="hidden" id="userId" name="userId" value = "${userId}"/>
         <input type="hidden" id="email" name="email" value = "${email}"/>
         <input type="hidden" id="memCode" name="memCode" value = "${memCode}"/>

         <c:if test="${isHideQR eq '1' or isHideQR eq '3'}">
         <p style = "font-weight:bold;">User Name: ${userName}</p>
         </br>
         <p style = "font-weight:bold;">Staff Code: ${memCode}</p>
         </c:if>
         <c:if test="${isHideQR eq '0'}">
         <h2 style = "font-weight:bold;">Kindly scan the barcode below using Google Authenticator app to get your OTP :</h2>
         </br>
            <p style = "font-weight:bold;">QR Barcode Address: </p>
            <h2><img src="${QrUrl}" alt="Qr"/></h2>
         </c:if>

         </br>
         <p style = "font-weight:bold;">OTP Code: </p>
         </br>
           <ul class="center_btns" id="center_btns1">
           <li>
           <input maxlength="6" type = "text" class = "form-control"  id = "code" name = "code" placeholder = "Please enter the code" />
           </li>
           <li>
           <p class="btn_blue">
           <a onclick="fn_submitMFA();">Send</a>
           </p>
           </li>
           </ul>
           <c:if test="${isHideQR eq '1' and userTypeId eq '4'}">
           <br>
<!--            <ul class="login_opt">
 -->           <ul class="login_opt" style="list-style-type: none; padding: 0; margin-top: 20px;">

               <li style="text-align: center;"><a href="javascript:fnResetOTP();" style="font-size: 16px; color: #007bff; text-decoration: none;">Reset OTP</a></li>

<!--                <li><a href="javascript:fnResetOTP();">Reset OTP</a></li>
 -->           </ul>
           </c:if>
         <!-- <input type = "submit" class = "btn btn-lg btn-dark" value = "Send" style = "margin-top:10px;"> -->
        </form>
    </article><!-- login_box end -->
    </div> <!-- lgoin box end -->

    <c:if test="${isHideQR eq '0'}">
    <div style="text-align:left; margin:30;">
    <h3>Step Guidelines: </h3>
    <ol>
    <li>1.  Download & Install Google Authenticator from Apple app store/ Google play store.</li>
    <li>2.  Keyin Username and Password on eTrust login, a QR code will be shown for first attempt</li>
    <li>3.  Open Google Authenticator > click “+” icon > Scan a QR code.</li>
    <li>4.  Proceed to scan QR code from eTrust.</li>
    <li>5.  You will receive the 6 digits OTP in Google Authenticator app.</li>
    <li>6.  Keyin the OTP number into eTrust within validity time.</li>
    <li>7.  Success to login.</li>
    </ol>
    </div>
        </br>
        <div class="container">
        <img src="${pageContext.request.contextPath}/resources/images/common/otpMFAGuide.png" alt="Coway"/>
        </div>
    </br>
    </c:if>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>