<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<!-- <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script> -->
<!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script> -->
<!-- <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script> -->
<!-- <link rel="canonical" href="https://getbootstrap.com/docs/5.1/forms/checks-radios/"> -->
<style>

   .applicationshadow {
       box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
   }

   .add-colon:after {
       content: ": ";
       position: absolute;
       right: 0;
   }

   .spanFontType {
       color: #EA635C;
       font-family: frutiger45_light,"Helvetica Neue",Arial,sans-serif;
       font-size: 12px;
   }

 .form-control {display:block;  height:40px; line-height:40px; border:1px solid #ddd; margin:auto; text-indent:19px; font-size:11px;}

 .button {
   background-color: #25527c; /* Blue */
   border: none;
   color: white;
   padding: 15px 32px;
   text-align: center;
   text-decoration: none;
   display: inline-block;
   font-size: 16px;
   margin: 4px 2px;
   cursor: pointer;
   width:90%;
 }

 .wrap {
   border-radius: 5px;
   background-color: #f2f2f2;
   padding: 20px;
 }

 .container {
   border-radius: 5px;
/*    background-color: #f2f2f2; */
   padding: 20px;
 }


</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/js.cookie.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/pgwbrowser.min.js"></script>
<script type="text/javaScript">

    $(function(){
        //hide footer
        let x = document.querySelector('.bottom_msg_box');
        x.style.display = "none";

        let maskedPhoneNo;
        maskedPhoneNo = "${mobileNo}".substr(-4).padStart("${mobileNo}".length, '*');
        document.getElementById('phoneNo').innerText=maskedPhoneNo;

        startCountdown(5);


        $('#btnResend').click(function(evt) {
            Common.ajax("GET","/enquiry/getTacNo.do",{orderNo: "${orderNo}"}  , function (result){});
        });

        $('#btnContinue').click(function(evt) {
        	console.log($("#tacForm").serializeJSON());
            Common.ajax("GET","/enquiry/verifyTacNo.do", $("#tacForm").serializeJSON() , function (result){
                console.log(result);
                if(result.code =="00"){
                    Common.alert(result.message, goCustomerInfoPage);
                }
                else{
                    Common.alert(result.message);
                }
            });
      });



    });

    function startCountdown(seconds) {
    	  let counter = seconds;

    	  const interval = setInterval(() => {
    		document.getElementById('countDown').innerText=counter;
    	    counter--;

    	    if (counter < 0 ) {
    	      clearInterval(interval);
    	      Common.alert('Your TAC number is expired. Please click "Resend TAC" to get new code.');
    	    }
    	  }, 1000);
    }

    function reload(){
        location.reload();
    }

    function goCustomerInfoPage(){
    	  $("#tacForm").attr("target", "");
          $("#tacForm").attr({
              action: getContextPath() + "/enquiry/selectCustomerInfo.do",
              method: "POST"
          }).submit();
    }


</script>
<body style="background:#e6f9ff !important">

<div class="container body-content">
    <div class="container">
        <div style="height:100px"></div>
        <div class="row">
            <div class="col-xs-12 col-md-6 offset-md-3">
                <div class="card">
                    <div class="text-center card-header" style="background:#25527c">
                        <div class="card-header text-white" style="text-align:center;color:white">
                            <h2><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"/></h2>
                            <div>
                               <h6 style="text-align:justify;color:white">
                                To proceed with the update installation address, a Transaction Authorization Code (TAC) has been sent to your registered mobile phone (<span id="phoneNo" style="text-align:justify;color:white"></span>).
                                Enter it below and then click "Continue".
                                Please leave the dialog box open on this page while waiting for TAC.
                           </h6>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <form role="form" id="tacForm">
                        <input type="hidden" name="orderNo"  value="${orderNo}">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="form-group">
                                        <div style="text-align:center;font-size:12px;font-weight:bold;">Enter TAC received via SMS</div>
                                        <br>
                                        <input type="password" class="form-control"  name="tacNo" id="tacNo"/>
                                        <br>
                                        <div style="text-align:right;font-size:12px;font-weight:bold;">TAC will expire in <u class="must text-danger"><span class="must text-danger" id="countDown"></span></u> secs</div>
                                        <br>
                                    </div>
                                </div>

                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <h6 id="btnResend"><u>Resend TAC</u></h6>
                                        <h6><u>Need help?</u></h6>
                                </div>


                            </div>

                        </form>
                    </div>
                    <div>
                    <div class="row" >
                    <div class="col-lg-6 col-md-6 mb-3  float-left" style="text-align:center">
                            <p class="button"  id="btnCancel" ><a href="javascript:void(0);" style="color:white">Cancel</a></p>
                        </div>
                        <div class="col-lg-6 col-md-6 mb-3" style="text-align:center">
                            <p class="button"  id="btnContinue" ><a href="javascript:void(0);" style="color:white">Continue</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</body>
